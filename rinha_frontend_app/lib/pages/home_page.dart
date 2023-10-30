import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_simple_treeview/flutter_simple_treeview.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/enum_stage.dart';
import '../controller/application_controller.dart';
import '../controller/json_controller.dart';
import 'display_big_files.dart';
import 'display_normal_files.dart';
import 'display_loading_page.dart';
import 'file_selector.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isUsingTreeNode = true;
  late bool usingTreeNode;
  bool isInvalid = false;
  ApplicationController applicationController =
      Get.put(ApplicationController());
  JsonController jsonController = Get.put(JsonController());

  void _openFile() async {
    setState(() {
      applicationController.setStage(StepStage.getFile);
    });
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json', 'txt'],
        onFileLoading: ((p0) {
          setState(() {
            applicationController.setStage(StepStage.loadingFile);
            debugPrint('Carregando arquivo...');
          });
        }));

    if (result != null) {
      String text = '';
      // Web
      if (kIsWeb) {
        debugPrint('[WEB] Lendo arquivo...');
        Uint8List? bytes = result.files.single.bytes;
        text = utf8.decode(bytes!);
        // SO normal
      } else {
        debugPrint('[Desktop] Lendo arquivo...');
        String? filePath = result.files.single.path;
        if (filePath != null) {
          final file = await File(filePath);
          List<int> bytes = await file.readAsBytes();
          text = utf8.decode(bytes);
        }
      }
      debugPrint('Iniciando validação de arquivo...');
      jsonController.setSelectedFileName(result.files.first.name);
      if (text != null) {
        bool arrayJson = jsonController.isJsonArray(text);
        if (!jsonValid(text) && !arrayJson) {
          setState(() {
            jsonController.setFileContent([]);
            applicationController.setSelectedFile(false);
            isInvalid = true;
            applicationController.setStage(StepStage.unknow);
          });
        } else {
          isInvalid = false;
          // Giant problem, alternative way
          if (text.length > 1000000) {
            debugPrint('Arquivo grande, forçando quebra de linhas...');
            text = jsonController.forceBreakLine(text);
          } else {
            debugPrint('Arquivo pequeno, formatando em modo texto...');
            text = jsonFormat(text);
          }
          debugPrint(
              'Validação secundária, assegurar a integridade do arquivo...');
          jsonValid(text);
          //
          // print(text.substring(0, text.length > 20000 ? 20000 : text.length));
          debugPrint('Criando um stringList, [melhorar isso]...');
          List<String> lines = LineSplitter.split(text).toList();
          lines.removeWhere((element) => element.trim() == '');
          if (lines.length > 5000) {
            debugPrint('Usando modo textual...');
            usingTreeNode = false;
          } else {
            debugPrint('Usando modo árvore...');
            usingTreeNode = isUsingTreeNode;
          }
          setState(() {
            applicationController.setStage(StepStage.displayData);
            jsonController.setFileContent(lines);
            applicationController.setSelectedFile(true);
            debugPrint('Camada de exibição...');
          });
        }
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    usingTreeNode = isUsingTreeNode;
  }

  Future<void> _openBigFile(BuildContext context) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return DisplayBigFiles();
        },
      ),
    );
  }

  Future<void> _openNormalFile(BuildContext context) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return DisplayNormalFiles();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Display Data Stage?
    if (applicationController.getStage() == StepStage.displayData) {
      if (usingTreeNode) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _openNormalFile(context);
        });
      } else {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _openBigFile(context);
        });
      }
    }
    if (applicationController.getStage() == StepStage.loadingFile) {
      return DisplayLoadingPage();
    }
    applicationController.setStage(StepStage.start);
    return Scaffold(
        body: FileSelectorPage(isValid: !isInvalid, onPressed: _openFile));
  }

  bool jsonValid(String text) {
    /*if (text.length > 10000) {
      return true;
    }*/
    return jsonController.isValid(text);
  }


  String jsonFormat(String text) {
    if (text.length > 1000000000) {
      return text;
    }
    return jsonController.format(text);
  }
}

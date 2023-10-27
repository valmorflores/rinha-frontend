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
          });
        }));

    if (result != null) {
      String text = '';
      // Web
      if (kIsWeb) {
        Uint8List? bytes = result.files.single.bytes;
        text = utf8.decode(bytes!);
        // SO normal
      } else {
        String? filePath = result.files.single.path;
        if (filePath != null) {
          final file = await File(filePath);
          List<int> bytes = await file.readAsBytes();
          text = utf8.decode(bytes);
        }
      }
      jsonController.setSelectedFileName(result.files.first.name);

      if (text != null) {
        if (!jsonValid(text)) {
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
            text = jsonController.forceBreakLine(text);
          } else {
            text = jsonFormat(text);
          }
          print(text.substring(0, text.length > 20000 ? 20000 : text.length));
          List<String> lines = LineSplitter.split(text).toList();
          lines.removeWhere((element) => element.trim() == '');
          if (lines.length > 10000) {
            usingTreeNode = false;
          } else {
            usingTreeNode = isUsingTreeNode;
          }
          applicationController.setStage(StepStage.displayData);
          jsonController.setFileContent(lines);
          applicationController.setSelectedFile(true);
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

  @override
  Widget build(BuildContext context) {
    if (applicationController.getStage() == StepStage.loadingFile) {
      return DisplayLoadingPage();
    }
    if (!applicationController.isSelectedFile()) {
      applicationController.setStage(StepStage.start);
      return Scaffold(
          body: FileSelectorPage(isValid: !isInvalid, onPressed: _openFile));
    } else if (usingTreeNode) {
      /*Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DisplayNormalFiles()),
      );*/
      return DisplayNormalFiles();
    } else {
      return DisplayBigFiles(context: context);
    }
  }

  bool jsonValid(String text) {
    if (text.length > 10000) {
      return true;
    }
    return jsonController.isValid(text);
  }

  String jsonFormat(String text) {
    if (text.length > 1000000000) {
      return text;
    }
    return jsonController.format(text);
  }
}

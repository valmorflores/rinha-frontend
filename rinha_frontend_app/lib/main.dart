import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rinhadefrontend/controller/json_controller.dart';
import 'package:rinhadefrontend/models/tree_model.dart';
import 'package:rinhadefrontend/pages/file_selector.dart';
import 'package:rinhadefrontend/ui/display.dart';
import 'package:rinhadefrontend/ui/root_point_widget.dart';

import 'ui/root_key_widget.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> fileContent = [];
  bool isSelectedFile = false;
  bool isInvalid = false;
  JsonController jsonController = Get.put(JsonController());

  void _openFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json', 'txt'],
    );

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
      text = jsonController.forceBreakLine(text);

      if (text != null) {
        if (!jsonValid(text)) {
          setState(() {
            fileContent = [];
            isSelectedFile = false;
            isInvalid = true;
          });
        } else {
          isInvalid = false;
          text = jsonFormat(text);
          List<String> lines = LineSplitter.split(text).toList();
          lines.removeWhere((element) => element.trim() == '');
          setState(() {
            fileContent = lines;
            isSelectedFile = true;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!isSelectedFile) {
      return Scaffold(
          body: FileSelectorPage(isValid: !isInvalid, onPressed: _openFile));
    } else {
      return Scaffold(
        appBar: AppBar(
          leading: InkWell(
            child: Icon(
              Icons.arrow_back,
            ),
            onTap: () {
              setState(() {
                isSelectedFile = false;
              });
            },
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(children: [
                Container(
                  width: 100,
                ),
                Text('${jsonController.getSelectedFileName()}',
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.w700, fontSize: 32)),
              ]),
              Expanded(
                child: ListView.builder(
                  itemCount: fileContent.length,
                  itemBuilder: (context, index) {
                    int profundidade = -1;
                    if (fileContent[index].contains(':')) {
                      String content = fileContent[index];
                      String keyInfo =
                          content.substring(0, content.indexOf(':') - 1);
                      keyInfo = keyInfo.trim();
                      keyInfo = keyInfo.replaceAll('"', '');
                      //log(keyInfo);
                      // Calculate profundidade name based
                      profundidade = jsonController.calcularProfundidade(
                          jsonController.getJsonData() ?? [], keyInfo);
                      String dataInfo =
                          content.substring(content.indexOf(':') + 1);

                      // Profundidade com base em posicionamento
                      if (profundidade < 0) {
                        if ((content.indexOf(keyInfo) > 1) &&
                            (content.indexOf(keyInfo) < 50)) {
                          profundidade = content.indexOf(keyInfo);
                        }
                      }

                      if (dataInfo.trim().contains('{')) {
                        return RootKeyWidget(
                          profundidade: profundidade,
                          keyName: keyInfo,
                          dataInfo: dataInfo,
                        );
                      }
                      if (dataInfo.trim().contains('[')) {
                        return RootKeyWidget(
                          profundidade: profundidade,
                          keyName: keyInfo,
                          dataInfo: dataInfo,
                        );
                      }
                      return DisplayWidget(
                        profundidade: profundidade,
                        keyName: keyInfo,
                        dataInfo: dataInfo,
                      );
                    } else {
                      return RootPointWidget(
                          profundidade: profundidade, data: fileContent[index]);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      );
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
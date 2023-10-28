import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rinhadefrontend/constants/enum_stage.dart';
import 'package:rinhadefrontend/controller/application_controller.dart';

import '../controller/json_controller.dart';
import '../ui/display.dart';
import '../ui/root_key_widget.dart';
import '../ui/root_point_widget.dart';

class DisplayBigFiles extends StatefulWidget {
  BuildContext context;
  DisplayBigFiles({required this.context, super.key});

  @override
  State<DisplayBigFiles> createState() => _DisplayBigFilesState();
}

class _DisplayBigFilesState extends State<DisplayBigFiles> {
  ApplicationController applicationController =
      Get.put(ApplicationController());
  JsonController jsonController = Get.put(JsonController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0, 
        leading: InkWell(
          child: Icon(
            Icons.arrow_back,
          ),
          onTap: () {
            setState(() {
              applicationController.setStage(StepStage.unknow);
              applicationController.setSelectedFile(false);
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
                itemCount: jsonController.getFileContent().length,
                itemBuilder: (context, index) {
                  int profundidade = -1;
                  if (jsonController.getFileContent()[index].contains(':')) {
                    String content = jsonController.getFileContent()[index];
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
                        profundidade: profundidade,
                        data: jsonController.getFileContent()[index]);
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

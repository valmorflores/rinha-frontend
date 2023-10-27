import 'package:flutter/material.dart';
import 'package:flutter_simple_treeview/flutter_simple_treeview.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rinhadefrontend/constants/enum_stage.dart';

import '../controller/application_controller.dart';
import '../controller/json_controller.dart';

class DisplayNormalFiles extends StatelessWidget {
  ApplicationController applicationController =
      Get.put(ApplicationController());
  JsonController jsonController = Get.put(JsonController());
  final TreeController _treeController = TreeController(allNodesExpanded: true);

  DisplayNormalFiles({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: InkWell(
            child: Icon(
              Icons.arrow_back,
            ),
            onTap: () {
              applicationController.setSelectedFile(false);
              applicationController.setStage(StepStage.start);
              jsonController.setFileContent([]);
            },
          ),
        ),
        body: SingleChildScrollView(
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
                Row(children: [
                  Container(
                    width: 100,
                  ),
                  buildTree(),
                ]),
              ]),
        ));
  }

  /// Builds tree or error message out of the entered content.
  Widget buildTree() {
    try {
      var parsedJson = jsonController.getJsonData();
      return TreeView(
        nodes: toTreeNodes(parsedJson),
        treeController: _treeController,
      );
    } on FormatException catch (e) {
      return Text(e.message);
    }
  }

  List<TreeNode> toTreeNodes(dynamic parsedJson) {
    if (parsedJson is Map<String, dynamic>) {
      return parsedJson.keys
          .map((k) => TreeNode(
              content: Text('$k:', style: TextStyle(color: Colors.blueAccent)),
              children: toTreeNodes(parsedJson[k])))
          .toList();
    }
    if (parsedJson is List<dynamic>) {
      // Se a lista tiver apenas um elemento, retorne o conteúdo diretamente.
      //return [TreeNode(content: Text(parsedJson[0].toString()))];
      return parsedJson
          .asMap()
          .map((i, element) => MapEntry(
              i,
              TreeNode(
                  content:
                      Text('[$i]:', style: TextStyle(color: Colors.blueAccent)),
                  children: toTreeNodes(element))))
          .values
          .toList();
    }
    return [TreeNode(content: Text(parsedJson.toString()))];
  }
}

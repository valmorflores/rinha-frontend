import 'package:flutter/material.dart';
import 'package:flutter_simple_treeview/flutter_simple_treeview.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rinhadefrontend/constants/enum_stage.dart';
import 'package:rinhadefrontend/pages/help.dart';

import '../constants/design_colors.dart';
import '../controller/application_controller.dart';
import '../controller/json_controller.dart';
import 'about.dart';

class DisplayNormalFiles extends StatefulWidget {
  const DisplayNormalFiles({super.key});

  @override
  State<DisplayNormalFiles> createState() => _DisplayNormalFilesState();
}

class _DisplayNormalFilesState extends State<DisplayNormalFiles> {
  ApplicationController applicationController =
      Get.put(ApplicationController());
  JsonController jsonController = Get.put(JsonController());
  final TreeController _treeController = TreeController(allNodesExpanded: true);

  String _message = 'Basic state';

  void updateState(String newMessage) {
    setState(() {
      _message = newMessage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: MenuDrawer(
            treeController: _treeController, updateMessage: updateState),
        appBar: AppBar(
          elevation: 0,
          /*leading: InkWell(
            child: Icon(
              Icons.arrow_back,
            ),
            onTap: () {
              applicationController.setSelectedFile(false);
              applicationController.setStage(StepStage.start);
              jsonController.setFileContent([]);
            },
          ),*/
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
              content:
                  Text('$k:', style: TextStyle(color: DesignColors.accent)),
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
                  content: Text('[$i]:',
                      style: TextStyle(color: DesignColors.accent)),
                  children: toTreeNodes(element))))
          .values
          .toList();
    }
    return [TreeNode(content: Text(parsedJson.toString()))];
  }
}

class MenuDrawer extends StatelessWidget {
  final Function(String) updateMessage;
  TreeController treeController;
  MenuDrawer(
      {required this.treeController, required this.updateMessage, super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.black,
              ),
              child: Column(
                children: [
                  Text(
                    'JSON Viewer',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Rinha de frontend',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    'by Valmor Flores',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ],
              )),
          ListTile(
            leading: Icon(Icons.add),
            title: Text('Expandir todos'),
            onTap: () {
              treeController.expandAll();
              updateMessage('Do update now');
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.remove),
            title: Text('Retrair todos'),
            onTap: () {
              treeController.collapseAll();
              updateMessage('Do update now');
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.help),
            title: Text('Ajuda'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Help()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text('Sobre'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => About()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.close),
            title: Text('Sair'),
            onTap: () {
              //treeController.expandAll();
              updateMessage('Refresh');
              Navigator.pop(context);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}

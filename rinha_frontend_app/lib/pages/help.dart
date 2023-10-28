import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rinhadefrontend/ui/text_default.dart';
import 'package:rinhadefrontend/ui/title_widget.dart';

class Help extends StatefulWidget {
  const Help({super.key});

  @override
  State<Help> createState() => _HelpState();
}

class _HelpState extends State<Help> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(),
    body: Padding(
      padding: const EdgeInsets.all(18.0),
      child: Column(children: [
        TitleWidget(title: 'Help'),
        TextDefault(text: 'Principais funções da aplicação: '),
        Row(children: [Chip(label: Text('Tab')),TextDefault(text: 'Navega entre as chaves principais')]),
        Row(children: [Chip(label: Text('Espaço')), TextDefault(text: 'Expande ou retrai a chave selecionada')]),
        Row(children: [Chip(label: Text('Page Down')), TextDefault(text: 'Page Down: Avança uma página')]),
        Row(children: [Chip(label: Text('Page Up')), TextDefault(text: 'Page Up: Retorna uma página'),]),
        Row(children: [Chip(label: Text('Ctrl+Tab')), Chip(label: Text('Shift+Tab')), TextDefault(text: 'Estas teclas podem levar até o menu e espaço permite abrir e fechar')]),
      ]),
    ),
    
    );
  }
}


import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rinhadefrontend/ui/title_widget.dart';

import '../ui/text_default.dart';

class About extends StatefulWidget {
  const About({super.key});

  @override
  State<About> createState() => _AboutState();
}

class _AboutState extends State<About> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(),
    body: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(children: [ TitleWidget(title: 'About'),
          TextDefault(text: 'Esta aplicação foi desenvolvida especificamente para competição'),
          TextDefault(text: 'da rinha de frontend. Foram tentadas diversas abordagens para '),
          TextDefault(text: 'lidar com os dados maiores, entretanto, ainda é necessário desenvolver '),
          TextDefault(text: 'um sistema híbrido que permita uma navegabilidade melhor sobre grandes dados,'),
          TextDefault(text: 'utilizando-se principalmente a opção de cargas parciais com paginação oculta'),
          TextDefault(text: 'fazendo-se um scroll infinito. '),
          TextDefault(text: ''),
          TextDefault(text: 'Desenvolvedor: Valmor Flores'),
          TextDefault(text: 'Esta aplicação foi desenvolvida em momentos de tempo livre (partial time),'),
          TextDefault(text: 'portanto, requer melhorias. Fique a vontade em copiar e melhorar!'),
      ]),
    ));
  }
}
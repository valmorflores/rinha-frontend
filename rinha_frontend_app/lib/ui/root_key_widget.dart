import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rinhadefrontend/ui/display_data_widget.dart';
import 'package:rinhadefrontend/ui/display_key_widget.dart';

class RootKeyWidget extends StatelessWidget {
  String keyName;
  String dataInfo;

  RootKeyWidget({required this.keyName, required this.dataInfo, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          child: DisplayKeyWidget(keyName: keyName),
          onTap: () {},
        ),
        DisplayDataWidget(dataInfo: dataInfo),
        /*Chip(
            label: Icon(
          Icons.menu,
          size: 16,
        )),*/
        Chip(label: Text('-'))
      ],
    );
  }
}

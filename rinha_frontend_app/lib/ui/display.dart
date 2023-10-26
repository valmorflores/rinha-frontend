import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rinhadefrontend/ui/display_data_widget.dart';
import 'package:rinhadefrontend/ui/display_key_widget.dart';

class DisplayWidget extends StatelessWidget {
  String keyName;
  String dataInfo;

  DisplayWidget({required this.keyName, required this.dataInfo, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        DisplayKeyWidget(keyName: keyName),
        DisplayDataWidget(dataInfo: dataInfo)
      ],
    );
  }
}

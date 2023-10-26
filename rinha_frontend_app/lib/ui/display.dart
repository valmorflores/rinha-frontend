import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rinhadefrontend/ui/display_data_widget.dart';
import 'package:rinhadefrontend/ui/display_key_widget.dart';

import 'margin_widget.dart';

class DisplayWidget extends StatelessWidget {
  String keyName;
  String dataInfo;
  int profundidade;

  DisplayWidget(
      {required this.profundidade,
      required this.keyName,
      required this.dataInfo,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        MarginWidget(profundidade: profundidade),
        DisplayKeyWidget(keyName: keyName),
        DisplayDataWidget(dataInfo: dataInfo)
      ],
    );
  }
}

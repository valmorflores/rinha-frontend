import 'package:flutter/material.dart';

import 'display_key_widget.dart';

class DisplayDataWidget extends StatelessWidget {
  String dataInfo;
  
  DisplayDataWidget({required this.dataInfo,super.key});

  @override
  Widget build(BuildContext context) {
    return Text('$dataInfo');
  }
}
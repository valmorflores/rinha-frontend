import 'package:flutter/material.dart';
import 'package:rinhadefrontend/constants/design_colors.dart';

class DisplayKeyWidget extends StatelessWidget {
  String keyName;
  DisplayKeyWidget({required this.keyName, super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      '$keyName',
      style: const TextStyle(color: DesignColors.accent),
    );
  }
}

import 'package:flutter/material.dart';

class DisplayKeyWidget extends StatelessWidget {
  String keyName;
  DisplayKeyWidget({required this.keyName, super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      '$keyName',
      style: TextStyle(color: Colors.blueAccent),
    );
  }
}

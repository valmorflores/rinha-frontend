import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class RootPointWidget extends StatelessWidget {
  String data;
  RootPointWidget({required this.data, super.key});

  @override
  Widget build(BuildContext context) {
    return Text('$data');
  }
}

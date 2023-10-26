import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rinhadefrontend/ui/margin_widget.dart';

class RootPointWidget extends StatelessWidget {
  int profundidade;
  String data;
  RootPointWidget({required this.profundidade, required this.data, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [MarginWidget(profundidade: profundidade), Text('$data')],
    );
  }
}

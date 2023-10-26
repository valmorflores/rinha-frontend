import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MarginWidget extends StatelessWidget {
  int profundidade;
  MarginWidget({required this.profundidade, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Container(
        width: 100,
      ),
      Container(
        height: 10,
        color: Colors.white,
        width: profundidade > 0 ? profundidade * 10 : 2,
      )
    ]);
  }
}

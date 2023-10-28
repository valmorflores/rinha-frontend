import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TitleWidget extends StatelessWidget {
  String title;
  TitleWidget({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(children: [ Text('${title}',
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.w700, fontSize: 32))],),
    );
  }
}
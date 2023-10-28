
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextDefault extends StatelessWidget {
  String text;
  TextDefault({this.text = '', super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(children: [ Text('$text',   
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.w300, fontSize: 16))],),
    );
  }
}
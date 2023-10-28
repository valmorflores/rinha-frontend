import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rinhadefrontend/constants/design_colors.dart';

class FileSelectorPage extends StatefulWidget {
  bool isValid;
  Function onPressed;
  FileSelectorPage({required this.isValid, required this.onPressed, super.key});

  @override
  State<FileSelectorPage> createState() => _FileSelectorPageState();
}

class _FileSelectorPageState extends State<FileSelectorPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('JSON Tree Viewer',
                style: GoogleFonts.inter(
                    fontWeight: FontWeight.w700, fontSize: 48)),
          ],
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0,15,0,15),
          child: Text(
              'Simple JSON Viewer that runs completely on-client. No data exchange',
              style:
                  GoogleFonts.inter(fontWeight: FontWeight.w400, fontSize: 24)),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: ElevatedButton(
               style: ElevatedButton.styleFrom(
              
            ),
              onPressed: (() => widget.onPressed()),
              child: Container(
                width: 100,
                height: 40,
                child: Center(
                    child: Text('Load JSON',
                        style: TextStyle(color: Colors.black))),
                decoration: BoxDecoration(
                  ),
                ),
              ),
          
          ),
        ),
        Visibility(
          visible: !widget.isValid,
          child: Text('Erro, arquivo inválido - ajuste mensagem',
              style: TextStyle(color: Colors.red)),
        ),
        Spacer(),
      ],
    );
  }
}

import 'dart:convert';

import 'package:get/get.dart';

class JsonController extends GetxController {
  String selectedFileName = '';

  setSelectedFileName(String cFile) => selectedFileName = cFile;
  getSelectedFileName() => selectedFileName;

  bool isValid(jsonString) {
    try {
      Map<String, dynamic> jsonData = json.decode(jsonString);
      // O JSON é válido, e você pode continuar usando jsonData.
      return true;
    } catch (e) {
      // O JSON é inválido.
      print('JSON inválido: $e');
    }
    return false;
  }

  String format(String text) {
    // Dividir o conteúdo do arquivo em partes (linhas)
    bool isInString = false;
    int ident = 0;
    String dataStr = '';
    for (int i = 0; i < text.length; ++i) {
      String information = text[i];
      if (text[i] == '"') {
        isInString = !isInString;
      }
      if ((!isInString) && '{['.contains(text[i])) {
        ++ident;
        information = information + '\n';
      }
      if ((!isInString) && '}]'.contains(text[i])) {
        --ident;
        information = information + '\n';
      }
      dataStr = dataStr + information;
    }
    text = dataStr;
    return text;
  }

  forceBreakLine(String text) {
    String str = text.replaceAll('",', '",\n');
    str = str.replaceAll(',"', ',\n"');
    str = str.replaceAll(', "', ',\n"');
    return str;
  }
}

import 'dart:convert';

import 'package:get/get.dart';

class JsonController extends GetxController {
  String selectedFileName = '';
  Map<String, dynamic> jsonData = {};

  setSelectedFileName(String cFile) => selectedFileName = cFile;
  getSelectedFileName() => selectedFileName;
  getJsonData() => jsonData;

  bool isValid(jsonString) {
    try {
      jsonData = json.decode(jsonString);
      // O JSON é válido, e você pode continuar usando jsonData.
      return true;
    } catch (e) {
      // O JSON é inválido.
      jsonData = {};
      print('JSON inválido: $e');
    }
    return false;
  }

  String format(String text) {
    try {
      var j = json.decode(text);
      JsonEncoder encoder = JsonEncoder.withIndent('  ');
      String formattedJson = encoder.convert(j);
      return formattedJson;
    } catch (e) {
      return text;
    }
  }

  String formatStepByStep(String text) {
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
    str = str.replaceAll('{ ', '{ \n');
    str = str.replaceAll('[ ', '[ \n');
    str = str.replaceAll(',[', ',\n[');
    str = str.replaceAll(', [', ',\n [');
    return str;
  }

  int calcularProfundidade(Map<String, dynamic> json, String chave,
      {int profundidade = 0}) {
    for (var key in json.keys) {
      if (key == chave) {
        return profundidade;
      }
      if (json[key] is Map) {
        final subProfundidade = calcularProfundidade(json[key], chave,
            profundidade: profundidade + 1);
        if (subProfundidade >= 0) {
          // Encontrada em algum lugar
          return subProfundidade;
        }
      }
    }
    // A chave não foi encontrada em nenhuma profundidade
    return -1;
  }
}

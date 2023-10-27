import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class JsonController extends GetxController {
  String selectedFileName = '';
  Map<String, dynamic> jsonData = {};
  List<String> fileContent = [];

  setFileContent(List<String> content) => fileContent = content;
  getFileContent() => fileContent;

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
      debugPrint('Iniciando formatação, decodificando');
      var j = json.decode(text);
      debugPrint('Preparando encoder, com espaçamento...');
      JsonEncoder encoder = JsonEncoder.withIndent('  ');
      debugPrint('Convertendo em json formatado...');
      String formattedJson = encoder.convert(j);
      debugPrint('Retornando resultado');
      return formattedJson;
    } catch (e) {
      debugPrint('Erro ao tentar formatar o arquivo');
      debugPrint(e.toString());
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

  skeleton() {
    //print(criarEsqueletoJSON(jsonData));
  }

  List<Map<String, dynamic>> criarEsqueletoJSON(
      Map<String, dynamic> jsonExistente) {
    // Crie uma lista de objetos Map<String, dynamic> para armazenar os elementos filhos.
    List<Map<String, dynamic>> elementosFilhos = [];

    log('$jsonExistente');
    // Itere sobre o objeto json.
    for (var chave in jsonExistente.keys) {
      // Verifique se o valor é um objeto.
      if ((jsonExistente[chave] is Map) || (jsonExistente[chave] is List)) {
        // Mpa, list recursive
        if (jsonExistente[chave] != null) {
          jsonExistente[chave].forEach((element) {
            if (element is List || element is Map) {
              elementosFilhos.add({chave: criarEsqueletoJSON(element)});
            } else {
              elementosFilhos.add({chave: element});
            }
          });
        }
      } else {
        // Adicione o valor à lista elementosFilhos.
        // Verifique se o valor é simples (string, booleano, data ou número).
        if (jsonExistente[chave] is String ||
            jsonExistente[chave] is bool ||
            jsonExistente[chave] is int ||
            jsonExistente[chave] is double) {
          elementosFilhos.add({chave: 'VALUE-HERE'});
          //elementosFilhos.add({chave: jsonExistente[chave]});
        } else {
          elementosFilhos.add({chave: null});
        }
      }
    }

    // Retorne a lista elementosFilhos.
    return elementosFilhos;
  }
}

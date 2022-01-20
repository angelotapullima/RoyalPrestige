import 'dart:convert';

import 'package:royal_prestige/core/sharedpreferences/storage_manager.dart';
import 'package:royal_prestige/database/document_database.dart';
import 'package:royal_prestige/src/model/document_model.dart';
import 'package:royal_prestige/src/utils/constants.dart';
import 'package:http/http.dart' as http;

class DocumentApi {
  final documentDatabase = DocumentDatabase();

  Future<Null> listarDocument() async {
    try {
      final url = Uri.parse('$apiBaseURL/api/Productos/listar_documentos');
      String? token = await StorageManager.readData('token');

      final resp = await http.post(url, body: {
        'tn': token,
        'app': 'true',
      });

      final decodedData = json.decode(resp.body);

      for (var i = 0; i < decodedData.length; i++) {
        DocumentModel documentModel = DocumentModel();
        documentModel.idDocument = decodedData[i]["id_documento"];
        documentModel.documentTitulo = decodedData[i]["documento_titulo"];
        documentModel.documentDescripcion = decodedData[i]["documento_descripcion"];
        documentModel.documentEstado = decodedData[i]["documento_estado"];
        documentModel.documentFile = decodedData[i]["documento_file"];

        await documentDatabase.insertDocument(documentModel);
      }
    } catch (e) {
      print(e);
    }
  }
}

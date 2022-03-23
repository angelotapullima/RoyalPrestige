import 'package:royal_prestige/database/databd_config.dart';
import 'package:royal_prestige/src/model/document_model.dart';

import 'package:sqflite/sqlite_api.dart';

class DocumentDatabase {
  final dbprovider = DatabaseHelper.instance;

  Future<void> insertDocument(DocumentModel producto) async {
    try {
      final Database db = await dbprovider.getDatabase();

      await db.insert(
        'Document',
        producto.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print("$e Error en la tabla Document");
    }
  }

  Future<List<DocumentModel>> getDocument() async {
    try {
      final Database db = await dbprovider.getDatabase();
      List<DocumentModel> list = [];
      List<Map> maps = await db.rawQuery("SELECT * FROM Document WHERE documentEstado = '1' ");

      if (maps.length > 0) list = DocumentModel.fromJsonList(maps);
      return list;
    } catch (e) {
      print(" $e Error en la  tabla Document");
      return [];
    }
  }

  Future<List<DocumentModel>> getDocumentForId(String id) async {
    try {
      final Database db = await dbprovider.getDatabase();
      List<DocumentModel> list = [];
      List<Map> maps = await db.rawQuery("SELECT * FROM Document WHERE idDocument ='$id' and documentEstado = '1' ");

      if (maps.length > 0) list = DocumentModel.fromJsonList(maps);
      return list;
    } catch (e) {
      print(" $e Error en la  tabla Document");
      return [];
    }
  }

  deleteDocument() async {
    final db = await dbprovider.database;

    final res = await db.rawDelete("DELETE FROM Document");

    return res;
  }
}

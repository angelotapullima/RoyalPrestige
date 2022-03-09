import 'package:royal_prestige/database/databd_config.dart';
import 'package:royal_prestige/src/model/galery_model.dart';

import 'package:sqflite/sqlite_api.dart';

class GaleryDatabase {
  final dbprovider = DatabaseHelper.instance;

  Future<void> insertGalery(GaleryModel galeryModel) async {
    try {
      final Database db = await dbprovider.getDatabase();

      await db.insert(
        'Galery',
        galeryModel.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print("$e Error en la tabla Galery");
    }
  }

  Future<List<GaleryModel>> getGalery() async {
    try {
      final Database db = await dbprovider.getDatabase();
      List<GaleryModel> list = [];
      List<Map> maps = await db.rawQuery("SELECT * FROM Galery WHERE status = '1' ");

      if (maps.length > 0) list = GaleryModel.fromJsonList(maps);
      return list;
    } catch (e) {
      print(" $e Error en la  tabla Galery");
      return [];
    }
  }
  Future<List<GaleryModel>> getGaleryForIdProduct(String idProduct) async {
    try {
      final Database db = await dbprovider.getDatabase();
      List<GaleryModel> list = [];
      List<Map> maps = await db.rawQuery("SELECT * FROM Galery WHERE status = '1' and idProduct = '$idProduct' ");

      if (maps.length > 0) list = GaleryModel.fromJsonList(maps);
      return list;
    } catch (e) {
      print(" $e Error en la  tabla Galery");
      return [];
    }
  }
  



  deleteGalery( ) async {
    final db = await dbprovider.database;

    final res = await db.rawDelete("DELETE FROM Galery");

    return res;
  }
}

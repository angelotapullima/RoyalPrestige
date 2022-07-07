import 'package:royal_prestige/database/databd_config.dart';
import 'package:royal_prestige/src/model/percent_calculate_model.dart';

import 'package:sqflite/sqlite_api.dart';

class PercentCalculateDatabase {
  final dbprovider = DatabaseHelper.instance;

  Future<void> insertarPercent(PercentCaculateModel percent) async {
    try {
      final Database db = await dbprovider.getDatabase();

      await db.insert(
        'Percent',
        percent.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print("$e Error en la tabla Percent");
    }
  }

  Future<List<PercentCaculateModel>> getPercentAll() async {
    try {
      final Database db = await dbprovider.getDatabase();
      List<PercentCaculateModel> list = [];
      List<Map> maps = await db.rawQuery("SELECT * FROM Percent WHERE estado='1' ");

      if (maps.length > 0) list = PercentCaculateModel.fromJsonList(maps);
      return list;
    } catch (e) {
      print(" $e Error en la  tabla Percent");
      return [];
    }
  }

  updatePercent(String id, String price) async {
    try {
      final db = await dbprovider.database;

      final res = await db.rawUpdate("UPDATE Percent SET monto='$price' WHERE id='$id'");
      print(' respuesta actualizacion $res');
      return res;
    } catch (exception) {
      print(exception);
    }
  }

  updateAllPercent() async {
    try {
      final db = await dbprovider.database;

      final res = await db.rawUpdate("UPDATE Percent SET monto='0.00'");
      return res;
    } catch (exception) {
      print(exception);
    }
  }

  deletePercent() async {
    final db = await dbprovider.database;

    final res = await db.rawDelete("DELETE FROM Percent");

    return res;
  }
}

import 'package:royal_prestige/database/databd_config.dart';
import 'package:royal_prestige/src/model/alert_model.dart';

import 'package:sqflite/sqlite_api.dart';

class AlertDatabase {
  final dbprovider = DatabaseHelper.instance;

  Future<void> insertAlert(AlertModel alertModel) async {
    try {
      final Database db = await dbprovider.getDatabase();

      await db.insert(
        'Alert',
        alertModel.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print("$e Error en la tabla alertModel");
    }
  }

  Future<List<AlertModel>> getAlert(String idUsuario) async {
    try {
      final Database db = await dbprovider.getDatabase();
      List<AlertModel> list = [];
      List<Map> maps = await db.rawQuery("SELECT * FROM Alert WHERE alertStatus = '1' and idUsuario = '$idUsuario' ORDER BY cast(idAlert as int) DESC");

      if (maps.length > 0) list = AlertModel.fromJsonList(maps);
      return list;
    } catch (e) {
      print(" $e Error en la  tabla Alert");
      return [];
    }
  }
}

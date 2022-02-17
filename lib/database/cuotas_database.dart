import 'package:royal_prestige/database/databd_config.dart';
import 'package:royal_prestige/src/model/cuota_model.dart';

import 'package:sqflite/sqlite_api.dart';

class CuotaDatabase {
  final dbprovider = DatabaseHelper.instance;

  Future<void> insertCuota(CuotaModel producto) async {
    try {
      final Database db = await dbprovider.getDatabase();

      await db.insert(
        'Cuotas',
        producto.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print("$e Error en la tabla Cuotas");
    }
  }

  Future<List<CuotaModel>> getCuotas() async {
    try {
      final Database db = await dbprovider.getDatabase();
      List<CuotaModel> list = [];
      List<Map> maps = await db.rawQuery("SELECT * FROM Cuotas WHERE cuotaEstado = '1' ");

      if (maps.length > 0) list = CuotaModel.fromJsonList(maps);
      return list;
    } catch (e) {
      print(" $e Error en la  tabla Cuotas");
      return [];
    }
  }

  Future<List<CuotaModel>> getCuotasMostar() async {
    try {
      final Database db = await dbprovider.getDatabase();
      List<CuotaModel> list = [];
      List<Map> maps = await db.rawQuery("SELECT * FROM Cuotas WHERE cuotaEstado = '1' and cuotaMostar='1' ");

      if (maps.length > 0) list = CuotaModel.fromJsonList(maps);
      return list;
    } catch (e) {
      print(" $e Error en la  tabla Cuotas");
      return [];
    }
  }
}

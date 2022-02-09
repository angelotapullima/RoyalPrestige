import 'package:royal_prestige/database/databd_config.dart';
import 'package:royal_prestige/src/model/promocion_model.dart';

import 'package:sqflite/sqlite_api.dart';

class PromocionDatabase {
  final dbprovider = DatabaseHelper.instance;

  Future<void> insertPromocion(PromocionModel promo) async {
    try {
      final Database db = await dbprovider.getDatabase();

      await db.insert(
        'Promocion',
        promo.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print("$e Error en la tabla Promocion");
    }
  }

  Future<List<PromocionModel>> getPromocion() async {
    try {
      final Database db = await dbprovider.getDatabase();
      List<PromocionModel> list = [];
      List<Map> maps = await db.rawQuery("SELECT * FROM Promocion WHERE estadoPromo = '1' ");

      if (maps.length > 0) list = PromocionModel.fromJsonList(maps);
      return list;
    } catch (e) {
      print(" $e Error en la  tabla Promocion");
      return [];
    }
  }
}

import 'package:royal_prestige/database/databd_config.dart';
import 'package:royal_prestige/src/model/compras_model.dart';

import 'package:sqflite/sqlite_api.dart';

class ComprasDatabase {
  final dbprovider = DatabaseHelper.instance;

  Future<void> insertCompra(ComprasModel compra) async {
    try {
      final Database db = await dbprovider.getDatabase();

      await db.insert(
        'Compras',
        compra.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print("$e Error en la tabla Compras");
    }
  }

  Future<List<ComprasModel>> getComprasByIdUsuario(String idUsuario) async {
    try {
      final Database db = await dbprovider.getDatabase();
      List<ComprasModel> list = [];
      List<Map> maps = await db.rawQuery("SELECT * FROM Compras WHERE estadoCompra = '1' and idUsuario = '$idUsuario'");

      if (maps.length > 0) list = ComprasModel.fromJsonList(maps);
      return list;
    } catch (e) {
      print(" $e Error en la  tabla Compras");
      return [];
    }
  }
}

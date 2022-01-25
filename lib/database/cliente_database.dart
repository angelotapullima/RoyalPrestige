import 'package:royal_prestige/database/databd_config.dart';
import 'package:royal_prestige/src/model/cliente_model.dart';

import 'package:sqflite/sqlite_api.dart';

class ClienteDatabase {
  final dbprovider = DatabaseHelper.instance;

  Future<void> insertCliente(ClienteModel producto) async {
    try {
      final Database db = await dbprovider.getDatabase();

      await db.insert(
        'Cliente',
        producto.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print("$e Error en la tabla Cliente");
    }
  }

  Future<List<ClienteModel>> getClient(String idUsuario) async {
    try {
      final Database db = await dbprovider.getDatabase();
      List<ClienteModel> list = [];
      List<Map> maps = await db.rawQuery("SELECT * FROM Cliente WHERE estadoCliente = '1' and idUsuario = '$idUsuario'");

      if (maps.length > 0) list = ClienteModel.fromJsonList(maps);
      return list;
    } catch (e) {
      print(" $e Error en la  tabla Cliente");
      return [];
    }
  }
}

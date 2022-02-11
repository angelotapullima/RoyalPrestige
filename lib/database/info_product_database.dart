import 'package:royal_prestige/database/databd_config.dart';
import 'package:royal_prestige/src/model/info_product_model.dart'; 

import 'package:sqflite/sqlite_api.dart';

class InfoProductoDatabase {
  final dbprovider = DatabaseHelper.instance;

  Future<void> insertarInfoProducto(InfoProductoModel infoProductoModel) async {
    try {
      final Database db = await dbprovider.getDatabase();

      await db.insert(
        'InfoProduct',
        infoProductoModel.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print("$e Error en la tabla InfoProduct");
    }
  } 
  Future<List<InfoProductoModel>> getInfoProForIdProduct(String idProducto) async {
    try {
      final Database db = await dbprovider.getDatabase();
      List<InfoProductoModel> list = [];
      List<Map> maps = await db.rawQuery("SELECT * FROM InfoProduct WHERE idProducto = '$idProducto' AND proEstado='1' ");

      if (maps.length > 0) list = InfoProductoModel.fromJsonList(maps);
      return list;
    } catch (e) {
      print(" $e Error en la  tabla Producto");
      return [];
    }
  } 

}

import 'package:royal_prestige/database/databd_config.dart';
import 'package:royal_prestige/src/model/producto_model.dart';

import 'package:sqflite/sqlite_api.dart';

class ProductoDatabase {
  final dbprovider = DatabaseHelper.instance;

  Future<void> insertarProducto(ProductoModel producto) async {
    try {
      final Database db = await dbprovider.getDatabase();

      await db.insert(
        'Producto',
        producto.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print("$e Error en la tabla Producto");
    }
  }

  Future<List<ProductoModel>> getProductos() async {
    try {
      final Database db = await dbprovider.getDatabase();
      List<ProductoModel> list = [];
      List<Map> maps = await db.rawQuery("SELECT * FROM Producto WHERE estadoProducto = '1' ");

      if (maps.length > 0) list = ProductoModel.fromJsonList(maps);
      return list;
    } catch (e) {
      print(" $e Error en la  tabla Producto");
      return [];
    }
  }

  Future<List<ProductoModel>> getProductosByIdCategoria(String idCategoria) async {
    try {
      final Database db = await dbprovider.getDatabase();
      List<ProductoModel> list = [];
      List<Map> maps = await db.rawQuery("SELECT * FROM Producto WHERE idCategoria = '$idCategoria' AND estadoProducto='1' ");

      if (maps.length > 0) list = ProductoModel.fromJsonList(maps);
      return list;
    } catch (e) {
      print(" $e Error en la  tabla Producto");
      return [];
    }
  }
}

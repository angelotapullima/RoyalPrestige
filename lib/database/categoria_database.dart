import 'package:royal_prestige/database/databd_config.dart';
import 'package:royal_prestige/src/model/categoria_model.dart';
import 'package:sqflite/sqlite_api.dart';

class CategoriaDatabase {
  final dbprovider = DatabaseHelper.instance;

  Future<void> insertarCategoria(CategoriaModel categoria) async {
    try {
      final Database db = await dbprovider.getDatabase();

      await db.insert(
        'Categoria',
        categoria.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print("$e Error en la tabla Categoria");
    }
  }

  Future<List<CategoriaModel>> getCategorias() async {
    try {
      final Database db = await dbprovider.getDatabase();
      List<CategoriaModel> list = [];
      List<Map> maps = await db.rawQuery("SELECT * FROM Categoria where estadoCategoria = '1' ");

      if (maps.length > 0) list = CategoriaModel.fromJsonList(maps);
      return list;
    } catch (e) {
      print(" $e Error en la  tabla Categoria");
      return [];
    }
  }

  Future<List<CategoriaModel>> getCategoriaById(String idCategoria) async {
    try {
      final Database db = await dbprovider.getDatabase();
      List<CategoriaModel> list = [];
      List<Map> maps = await db.rawQuery("SELECT * FROM Categoria WHERE idCategoria='$idCategoria' AND estadoCategoria = '1' ");

      if (maps.length > 0) list = CategoriaModel.fromJsonList(maps);
      return list;
    } catch (e) {
      print(" $e Error en la  tabla Categoria");
      return [];
    }
  }
}

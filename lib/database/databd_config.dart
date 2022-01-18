import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database ??= await getDatabase();

  Future<Database> getDatabase() async {
    final String path = join(await getDatabasesPath(), 'royalv1.db');
    return openDatabase(path, onCreate: (db, version) {
      db.execute(tableCategoriaSql);
      db.execute(tableProductoSql);
    }, version: 1, onDowngrade: onDatabaseDowngradeDelete);
  }

  static const String tableCategoriaSql = 'CREATE TABLE Categoria('
      ' idCategoria TEXT PRIMARY KEY,'
      ' nombreCategoria TEXT,'
      ' estadoCategoria TEXT)';

  static const String tableProductoSql = 'CREATE TABLE Producto('
      ' idProducto TEXT PRIMARY KEY,'
      ' idCategoria TEXT,'
      ' codigoProducto TEXT,'
      ' nombreProducto TEXT,'
      ' precioProducto TEXT,'
      ' regaloProducto TEXT,'
      ' precioRegaloProducto TEXT,'
      ' fotoProducto TEXT,'
      ' estadoProducto TEXT)';
}

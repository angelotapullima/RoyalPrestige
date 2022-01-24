import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database ??= await getDatabase();

  Future<Database> getDatabase() async {
    final String path = join(await getDatabasesPath(), 'royalv3.db');
    return openDatabase(path, onCreate: (db, version) {
      db.execute(tableCategoriaSql);
      db.execute(tableProductoSql);
      db.execute(tableDocumentSql);
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
      ' descripcionProducto TEXT,'
      ' precioProducto TEXT,'
      ' regaloProducto TEXT,'
      ' precioRegaloProducto TEXT,'
      ' fotoProducto TEXT,'
      ' estadoProducto TEXT)';


  static const String tableDocumentSql = 'CREATE TABLE Document('
      ' idDocument TEXT PRIMARY KEY,'
      ' documentTitulo TEXT,'
      ' documentDescripcion TEXT,'
      ' documentFile TEXT,' 
      ' documentEstado TEXT)';
}

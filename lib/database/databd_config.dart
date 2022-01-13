import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database ??= await getDatabase();

  Future<Database> getDatabase() async {
    final String path = join(await getDatabasesPath(), 'asistenciasamiriav1.db');
    return openDatabase(path, onCreate: (db, version) {
      // db.execute(tableEventoSql);
    }, version: 1, onDowngrade: onDatabaseDowngradeDelete);
  }

  static const String tableEventoSql = 'CREATE TABLE Asistencia('
      ' idAsistencia INTEGER PRIMARY KEY AUTOINCREMENT,'
      ' idPersona TEXT,'
      ' nombre TEXT,'
      ' cargo TEXT,'
      ' tipoAcceso TEXT,'
      ' dni TEXT,'
      ' fecha TEXT,'
      ' hora TEXT)';
}

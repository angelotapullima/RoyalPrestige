import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database ??= await getDatabase();

  Future<Database> getDatabase() async {
    final String path = join(await getDatabasesPath(), 'royalv4.db');
    return openDatabase(path, onCreate: (db, version) {
      db.execute(tableCategoriaSql);
      db.execute(tableProductoSql);
      db.execute(tableDocumentSql);
      db.execute(tableClientSql);
      db.execute(tableAlertSql);
      db.execute(tableCartSql);
      db.execute(tableGaleriaSql);
      db.execute(tablePromocionSql);
      db.execute(tableComprasSql);
      db.execute(tableInfoProductSql);
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

  static const String tableClientSql = 'CREATE TABLE Cliente('
      ' idCliente TEXT PRIMARY KEY,'
      ' idUsuario TEXT,'
      ' nombreCliente TEXT,'
      ' tipoDocCliente TEXT,'
      ' nroDocCliente TEXT,'
      ' sexoCliente TEXT,'
      ' nacimientoCLiente TEXT,'
      ' telefonoCliente TEXT,'
      ' estadoCliente TEXT,'
      ' observacionesCliente TEXT,'
      ' tipo TEXT,'
      ' direccionCliente TEXT)';

  static const String tableAlertSql = 'CREATE TABLE Alert('
      ' idAlert TEXT PRIMARY KEY,'
      ' idUsuario TEXT,'
      ' idClient TEXT,'
      ' alertTitle TEXT,'
      ' alertDetail TEXT,'
      ' alertDate TEXT,'
      ' alertHour TEXT,'
      ' alertStatus TEXT)';

  static const String tableCartSql = 'CREATE TABLE Cart('
      ' idProduct TEXT PRIMARY KEY,'
      ' amount TEXT,'
      ' subtotal TEXT)';

  static const String tableGaleriaSql = 'CREATE TABLE Galery('
      ' idGalery TEXT PRIMARY KEY,'
      ' idProduct TEXT,'
      ' name TEXT,'
      ' file TEXT,'
      ' status TEXT)';

  static const String tablePromocionSql = 'CREATE TABLE Promocion('
      ' idPromo TEXT PRIMARY KEY,'
      ' idProduct TEXT,'
      ' idCategoria TEXT,'
      ' precioPromo TEXT,'
      ' detallePromo TEXT,'
      ' fechaLimitePromo TEXT,'
      ' imagenPromo TEXT,'
      ' estadoPromo TEXT)';

  static const String tableComprasSql = 'CREATE TABLE Compras('
      ' idCompra TEXT PRIMARY KEY,'
      ' idUsuario TEXT,'
      ' idCliente TEXT,'
      ' idProducto TEXT,'
      ' montoCuotaCompra TEXT,'
      ' fechaPagoCompra TEXT,'
      ' fechaCompra TEXT,'
      ' observacionCompra TEXT,'
      ' estadoCompra TEXT)';

      static const String tableInfoProductSql = 'CREATE TABLE InfoProduct('
      ' idProDoc TEXT PRIMARY KEY,'
      ' idProducto TEXT,'
      ' proTipo TEXT,'
      ' proTitulo TEXT,'
      ' proDetalle TEXT,'
      ' proUrl TEXT,'
      ' proEstado TEXT)';
}

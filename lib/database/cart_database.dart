import 'package:royal_prestige/database/databd_config.dart';
import 'package:royal_prestige/src/model/cart_model.dart';

import 'package:sqflite/sqlite_api.dart';

class CartDatabase {
  final dbprovider = DatabaseHelper.instance;

/*
 final res = await db.rawInsert(
        'INSERT OR REPLACE INTO Adicionales (id_producto,id_producto_adicional,adicional_item,titulo,adicional_seleccionado) '
        'VALUES ( "${adicionalesModel.idProducto}" , "${adicionalesModel.idProductoAdicional}" ,  "${adicionalesModel.adicionalItem}" ,"${adicionalesModel.titulo}" ,"${adicionalesModel.adicionalSeleccionado}"  )');
    return res;
     */
  Future<void> insertCart(CartModel cart) async {
    try {
      final Database db = await dbprovider.getDatabase();
      await db.rawInsert('INSERT OR REPLACE INTO Cart (idProduct,amount,subtotal) '
          'VALUES ( "${cart.idProduct}" , "${cart.amount}" ,"${cart.subtotal}"  )');

   /*    await db.insert(
        'Cart',
        cart.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      ); */
    } catch (e) {
      print("$e Error en la tabla Cart");
    }
  }

  Future<List<CartModel>> getCart() async {
    try {
      final Database db = await dbprovider.getDatabase();
      List<CartModel> list = [];
      List<Map> maps = await db.rawQuery("SELECT * FROM Cart ");

      if (maps.length > 0) list = CartModel.fromJsonList(maps);
      return list;
    } catch (e) {
      print(" $e Error en la  tabla Cart");
      return [];
    }
  }

  Future<List<CartModel>> getCartForId(String idProduct) async {
    try {
      final Database db = await dbprovider.getDatabase();
      List<CartModel> list = [];
      List<Map> maps = await db.rawQuery("SELECT * FROM Cart WHERE idProduct='$idProduct'");

      if (maps.length > 0) list = CartModel.fromJsonList(maps);
      return list;
    } catch (e) {
      print(" $e Error en la  tabla Cart");
      return [];
    }
  }


  deleteCartForId(String idProduct) async {
    final db = await dbprovider.database;

    final res = await db.rawDelete("DELETE FROM Cart WHERE idProduct='$idProduct'");

    return res;
  }



  deleteCart() async {
    final db = await dbprovider.database;

    final res = await db.rawDelete("DELETE FROM Cart");

    return res;
  }
}

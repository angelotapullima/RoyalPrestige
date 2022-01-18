import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:royal_prestige/core/sharedpreferences/storage_manager.dart';
import 'package:royal_prestige/database/categoria_database.dart';
import 'package:royal_prestige/database/producto_database.dart';
import 'package:royal_prestige/src/model/categoria_model.dart';
import 'package:royal_prestige/src/model/producto_model.dart';
import 'package:royal_prestige/src/utils/constants.dart';

class ProductosApi {
  final productoDatabase = ProductoDatabase();
  final categoriaDatabase = CategoriaDatabase();
  Future<Null> listarProductos() async {
    try {
      final url = Uri.parse('$apiBaseURL/api/Productos/listar_productos');
      String? token = await StorageManager.readData('token');

      final resp = await http.post(url, body: {
        'tn': token,
        'app': 'true',
      });

      final decodedData = json.decode(resp.body);

      for (var i = 0; i < decodedData.length; i++) {
        CategoriaModel categoria = CategoriaModel();
        categoria.idCategoria = decodedData[i]["id_categoria"];
        categoria.nombreCategoria = decodedData[i]["categoria_nombre"];
        categoria.estadoCategoria = decodedData[i]["categoria_estado"];

        await categoriaDatabase.insertarCategoria(categoria);

        for (var x = 0; x < decodedData[i]["productos"].length; x++) {
          var productos = decodedData[i]["productos"][x];

          ProductoModel producto = ProductoModel();
          producto.idProducto = productos["id_producto"];
          producto.idCategoria = productos["id_categoria"];
          producto.codigoProducto = productos["producto_codigo"];
          producto.nombreProducto = productos["producto_nombre"];
          producto.precioProducto = productos["producto_precio"];
          producto.regaloProducto = productos["producto_regalo"];
          producto.precioRegaloProducto = productos["producto_regalo_precio"];
          producto.fotoProducto = productos["producto_foto"];
          producto.estadoProducto = productos["producto_estado"];

          await productoDatabase.insertarProducto(producto);
        }
      }
    } catch (e) {
      print(e);
    }
  }
}

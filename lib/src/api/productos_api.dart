import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:royal_prestige/core/sharedpreferences/storage_manager.dart';
import 'package:royal_prestige/database/categoria_database.dart';
import 'package:royal_prestige/database/galery_database.dart';
import 'package:royal_prestige/database/producto_database.dart';
import 'package:royal_prestige/src/model/categoria_model.dart';
import 'package:royal_prestige/src/model/galery_model.dart';
import 'package:royal_prestige/src/model/producto_model.dart';
import 'package:royal_prestige/src/utils/constants.dart';
import 'package:path/path.dart';

class ProductosApi {
  final productoDatabase = ProductoDatabase();
  final categoriaDatabase = CategoriaDatabase();
  final galeryDatabase = GaleryDatabase();
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
          producto.descripcionProducto = productos["producto_descripcion"];
          producto.estadoProducto = productos["producto_estado"];

          await productoDatabase.insertarProducto(producto);

          if (productos['galeria'].length > 0) {
            for (var y = 0; y < productos['galeria'].length; y++) {
              GaleryModel galeryModel = GaleryModel();
              galeryModel.idGalery = productos['galeria'][y]['id_galeria'];
              galeryModel.idProduct = productos['galeria'][y]['id_producto'];
              galeryModel.name = productos['galeria'][y]['galeria_nombre'];
              galeryModel.file = productos['galeria'][y]['galeria_file'];
              galeryModel.status = productos['galeria'][y]['galeria_estado'];
              await galeryDatabase.insertGalery(galeryModel);
            }
          }
        }
      }
    } catch (e) {
      print(e);
    }
  }

  Future<bool> agregarGaleria(File _image, String idProducto, String nombre) async {
    String progress;
    late Dio dio = new Dio();
    String? token = await StorageManager.readData('token');
    String uploadurl = "$apiBaseURL/api/Productos/guardar_galeria";
    //dont use http://localhost , because emulator don't get that address
    //insted use your local IP address or use live URL
    //hit "ipconfig" in windows or "ip a" in linux to get you local IP

    FormData formdata = FormData.fromMap({
      "galeria_file": await MultipartFile.fromFile(_image.path, filename: basename(_image.path)),
      "app": "true",
      "tn": "$token",
      "id_producto": "$idProducto",
      "galeria_nombre": "$nombre",
    });

    Response response = await dio.post(
      uploadurl,
      data: formdata,
      //cancelToken: cancelToken,
      onSendProgress: (int sent, int total) {
        String percentage = (sent / total * 100).toStringAsFixed(2);

        progress = "$sent" + " Bytes of " "$total Bytes - " + percentage + " % uploaded";
        print('progress $progress');
        /*  provider.changeSubidaImagen(
          double.parse(percentage),
        ); */
        //update the progress
      },
    );

    if (response.statusCode == 200) {
      print(response.toString());

      return true; /* 
      _cargando.value = false; */

      /*  final categoriasBloc = ProviderBloc.productos(context);

      categoriasBloc.obtenerProductosByIdCategoria(idCategoria);

      _nombreController.text = '';
      _precioController.text = '';
      _codigoController.text = '';
      _regaloPrecioController.text = '';
      _regaloController.text = '';
      _descripcionController.text = '';

      dropServicio3 = 'Seleccionar';
      _image = File('');
      idCategory = 'Seleccionar';
 */

    } else {
      print("Error during connection to server.");
      return false;
    }
  }

  Future<bool> disabledGalery(String idProducto) async {
    try {
      final url = Uri.parse('$apiBaseURL/api/Productos/desactivar_galeria');
      String? token = await StorageManager.readData('token');

      final resp = await http.post(url, body: {
        'tn': token,
        'app': 'true',
        'id_cliente': '4',
      });

      if (resp.statusCode == 200) {
        print(resp.toString());

        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }
}

import 'dart:convert';

import 'package:royal_prestige/core/sharedpreferences/storage_manager.dart';
import 'package:royal_prestige/database/promocion_database.dart';
import 'package:royal_prestige/src/model/promocion_model.dart';
import 'package:royal_prestige/src/utils/constants.dart';
import 'package:http/http.dart' as http;

class PromocionApi {
  final promoDatabase = PromocionDatabase();

  Future<Null> listarPromociones() async {
    try {
      final url = Uri.parse('$apiBaseURL/api/Productos/listar_promociones');
      String? token = await StorageManager.readData('token');

      final resp = await http.post(url, body: {
        'tn': token,
        'app': 'true',
      });

      final decodedData = json.decode(resp.body);

      for (var i = 0; i < decodedData.length; i++) {
        PromocionModel promo = PromocionModel();
        promo.idPromo = decodedData[i]["id_promocion"];
        promo.idProduct = decodedData[i]["id_producto"];
        promo.idCategoria = decodedData[i]["id_categoria"];
        promo.precioPromo = decodedData[i]["promocion_precio"];
        promo.detallePromo = decodedData[i]["promocion_detalle"];
        promo.fechaLimitePromo = decodedData[i]["promocion_fecha_limite"];
        promo.imagenPromo = decodedData[i]["promocion_imagen"];
        promo.estadoPromo = decodedData[i]["promocion_estado"];

        await promoDatabase.insertPromocion(promo);
      }
    } catch (e) {
      print(e);
    }
  }
}

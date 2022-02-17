import 'dart:convert';

import 'package:royal_prestige/core/sharedpreferences/storage_manager.dart';
import 'package:royal_prestige/database/cuotas_database.dart';
import 'package:royal_prestige/src/model/cuota_model.dart';
import 'package:royal_prestige/src/utils/constants.dart';
import 'package:http/http.dart' as http;

class CuotaApi {
  final cuotaDatabase = CuotaDatabase();

  Future<Null> getCuotas() async {
    try {
      final url = Uri.parse('$apiBaseURL/api/Login/listar_cuotas');

      final resp = await http.post(url, body: {
        //'tn': token,
        'app': 'true',
      });

      final decodedData = json.decode(resp.body);

      for (var i = 0; i < decodedData.length; i++) {
        CuotaModel cuotaModel = CuotaModel();
        cuotaModel.idCuota = decodedData[i]["id_cuota"];
        cuotaModel.cuotaNombre = decodedData[i]["cuota_texto"];
        cuotaModel.cuotaMultiplicador = (double.parse('${decodedData[i]["cuota_multiplicador"]}') / 100).toString();
        cuotaModel.cuotaEstado = decodedData[i]["cuota_estado"];
        cuotaModel.cuotaMostar = decodedData[i]["cuota_mostrar"];

        // if (decodedData[i]["cuota_texto"] == 'Cuota 12') {
        //   cuotaModel.cuotaMostar = '1';
        // } else if (decodedData[i]["cuota_texto"] == 'Cuota 14') {
        //   cuotaModel.cuotaMostar = '1';
        // } else if (decodedData[i]["cuota_texto"] == 'Cuota 16') {
        //   cuotaModel.cuotaMostar = '1';
        // } else if (decodedData[i]["cuota_texto"] == 'Cuota 24') {
        //   cuotaModel.cuotaMostar = '1';
        // } else {
        //   cuotaModel.cuotaMostar = '0';
        // }
        await cuotaDatabase.insertCuota(cuotaModel);
      }
    } catch (e) {
      print(e);
    }
  }
}

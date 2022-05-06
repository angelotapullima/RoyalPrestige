import 'dart:convert';

import 'package:royal_prestige/core/sharedpreferences/storage_manager.dart';
import 'package:royal_prestige/src/utils/constants.dart';
import 'package:http/http.dart' as http;

class LogoutApi {
  Future<bool> logoutUsuario() async {
    try {
      final url = Uri.parse('$apiBaseURL/api/Admin/cambiar_usuario_activo_ws');
      String? token = await StorageManager.readData('token');
      String? idUser = await StorageManager.readData('idUser');

      final resp = await http.post(url, body: {
        'app': 'true',
        'tn': token,
        'id_usuario': idUser,
      });

      final decodedData = json.decode(resp.body);
      //   print(decodedData);

      if (decodedData['result']['code'] == 1) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error Api Logout: $e');
      return false;
    }
  }
}

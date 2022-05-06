import 'dart:convert';

import 'package:royal_prestige/core/sharedpreferences/storage_manager.dart';
import 'package:royal_prestige/src/api/cuota_api.dart';
import 'package:royal_prestige/src/model/api_model.dart';
import 'package:royal_prestige/src/utils/constants.dart';
import 'package:http/http.dart' as http;

class LoginApi {
  Future<ApiModel> login(String user, String passwd) async {
    try {
      final url = Uri.parse('$apiBaseURL/api/Login/validar_sesion');

      final resp = await http.post(url, body: {
        'usuario_nickname': '$user',
        'usuario_contrasenha': '$passwd',
        'app': 'true',
      });

      final decodedData = json.decode(resp.body);
      //   print(decodedData);

      final int code = decodedData['result']['code'];
      ApiModel loginModel = ApiModel();
      loginModel.code = code.toString();
      loginModel.message = decodedData['result']['message'];

      if (code == 1) {
        final cuotaApi = CuotaApi();

        await cuotaApi.getCuotas();
        StorageManager.saveData('idUser', decodedData['data']['c_u']);
        StorageManager.saveData('idPerson', decodedData['data']['c_p']);
        StorageManager.saveData('userNickname', decodedData['data']['_n']);
        StorageManager.saveData('userEmail', decodedData['data']['u_e']);
        StorageManager.saveData('userImage', decodedData['data']['u_i']);
        StorageManager.saveData('personName', decodedData['data']['p_n']);
        StorageManager.saveData('personSurname', decodedData['data']['p_p']);
        StorageManager.saveData('personSecondSurname', decodedData['data']['p_m']);
        StorageManager.saveData('personDNI', decodedData['data']['dni']);
        StorageManager.saveData('idRoleUser', decodedData['data']['ru']);
        StorageManager.saveData('personCargo', decodedData['data']['u_c']);
        StorageManager.saveData('roleName', decodedData['data']['rn']);
        StorageManager.saveData('token', decodedData['data']['tn']);
        StorageManager.saveData('frase', decodedData['data']['frase']);

        return loginModel;
      } else {
        return loginModel;
      }
    } catch (e) {
      ApiModel api = ApiModel();
      api.code = '2';
      api.message = 'Ocurrió un error';
      print('Erro login: $e');
      return api;
    }
  }

  Future<ApiModel> consultarUsuario() async {
    try {
      final url = Uri.parse('$apiBaseURL/api/Admin/consultar_estado_usuario');
      String? token = await StorageManager.readData('token');

      final resp = await http.post(url, body: {
        'tn': token,
        'app': 'true',
      });

      final decodedData = json.decode(resp.body);
      print(decodedData);

      final int code = decodedData['result']['code'];
      ApiModel loginModel = ApiModel();
      loginModel.code = code.toString();
      loginModel.message = decodedData['result']['message'];
      return loginModel;
    } catch (e) {
      ApiModel api = ApiModel();
      api.code = '2';
      api.message = 'Ocurrió un error';
      print('Erro consultarUsuario: $e');
      print(e);
      return api;
    }
  }

  Future<ApiModel> getDataUsuario() async {
    try {
      final url = Uri.parse('$apiBaseURL/api/Productos/listar_datos_usuarios');
      String? token = await StorageManager.readData('token');
      String? idUser = await StorageManager.readData('idUser');

      final resp = await http.post(url, body: {
        'tn': token,
        'app': 'true',
        'id_usuario': idUser,
      });

      final decodedData = json.decode(resp.body);

      final int code = decodedData['respuesta']['code'];
      ApiModel loginModel = ApiModel();
      loginModel.code = code.toString();
      if (code == 1) {
        StorageManager.saveData('idUser', decodedData['respuesta']['datos_usuario']['id_usuario']);
        StorageManager.saveData('idPerson', decodedData['respuesta']['datos_usuario']['id_persona']);
        StorageManager.saveData('userNickname', decodedData['respuesta']['datos_usuario']['usuario_nickname']);
        StorageManager.saveData('userEmail', decodedData['respuesta']['datos_usuario']['usuario_email']);
        StorageManager.saveData('userImage', decodedData['respuesta']['datos_usuario']['usuario_imagen']);
        StorageManager.saveData('personName', decodedData['respuesta']['datos_usuario']['persona_nombre']);
        StorageManager.saveData('personSurname', decodedData['respuesta']['datos_usuario']['persona_apellido_paterno']);
        StorageManager.saveData('personSecondSurname', decodedData['respuesta']['datos_usuario']['persona_apellido_materno']);
        StorageManager.saveData('personDNI', decodedData['respuesta']['datos_usuario']['persona_dni']);
        StorageManager.saveData('idRoleUser', decodedData['respuesta']['datos_usuario']['id_rol']);
        StorageManager.saveData('personCargo', decodedData['respuesta']['datos_usuario']['usuario_cargo']);
        StorageManager.saveData('roleName', decodedData['respuesta']['datos_usuario']['rol_nombre']);
        StorageManager.saveData('userCodigo', decodedData['respuesta']['datos_usuario']['usuario_codigo']);
        StorageManager.saveData('frase', decodedData['respuesta']['frase']['configuracion_texto']);
      }
      return loginModel;
    } catch (e) {
      ApiModel api = ApiModel();
      api.code = '2';
      api.message = 'Ocurrió un error';
      print('Erro getDataUsuario: $e');
      print(e);
      return api;
    }
  }

  Future<ApiModel> editarFrase(String frase) async {
    try {
      final url = Uri.parse('$apiBaseURL/api/Admin/guardar_frase');
      String? token = await StorageManager.readData('token');

      final resp = await http.post(url, body: {
        'tn': token,
        'app': 'true',
        'id_configuracion': '1',
        'configuracion_texto': frase,
      });

      final decodedData = json.decode(resp.body);
      ////   print(decodedData);

      final int code = decodedData['result']['code'];
      ApiModel loginModel = ApiModel();
      loginModel.code = code.toString();
      loginModel.message = decodedData['result']['message'];
      return loginModel;
    } catch (e) {
      ApiModel api = ApiModel();
      api.code = '2';
      api.message = 'Ocurrió un error';
      print('Erro Api editarFrase: $e');
      print(e);
      return api;
    }
  }
}

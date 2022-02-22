import 'dart:convert';

import 'package:royal_prestige/core/sharedpreferences/storage_manager.dart';
import 'package:royal_prestige/database/alert_database.dart';
import 'package:royal_prestige/database/cliente_database.dart';
import 'package:royal_prestige/src/model/alert_model.dart';
import 'package:royal_prestige/src/model/cliente_model.dart';
import 'package:royal_prestige/src/utils/constants.dart';
import 'package:http/http.dart' as http;

class AlertApi {
  final alertDatabase = AlertDatabase();
  final clienteDatabase = ClienteDatabase();
  Future<bool> saveAlert(AlertModel alertModel) async {
    try {
      final url = Uri.parse('$apiBaseURL/api/Productos/guardar_alerta');
      String? token = await StorageManager.readData('token');
      String? idUsuario = await StorageManager.readData('idUser');

      final resp = await http.post(url, body: {
        'tn': token,
        'app': 'true',
        'alerta_titulo': '${alertModel.alertTitle}',
        'id_usuario': '$idUsuario',
        'id_cliente': '${alertModel.idClient}',
        'alerta_detalle': '${alertModel.alertDetail}',
        'alerta_fecha': '${alertModel.alertDate}',
        'alerta_hora': '${alertModel.alertHour}',
        'alerta_estado': '1',
      });

      if (resp.statusCode == 200) {
        print(resp.body.toString());

        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> editAlert(AlertModel alertModel) async {
    try {
      final url = Uri.parse('$apiBaseURL/api/Productos/guardar_alerta');
      String? token = await StorageManager.readData('token');
      String? idUsuario = await StorageManager.readData('idUser');

      final resp = await http.post(url, body: {
        'tn': token,
        'app': 'true',
        'id_alerta': '${alertModel.idAlert}',
        'alerta_titulo': '${alertModel.alertTitle}',
        'id_usuario': '$idUsuario',
        'id_cliente': '${alertModel.idClient}',
        'alerta_detalle': '${alertModel.alertDetail}',
        'alerta_fecha': '${alertModel.alertDate}',
        'alerta_hora': '${alertModel.alertHour}',
        'alerta_estado': '1',
      });

      final decodedData = json.decode(resp.body);

      print(decodedData);

      if (resp.statusCode == 200) {
        print(resp.body.toString());

        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  /* 
Future<bool> editCLient(ClienteModel clienteModel) async {
    try {
      final url = Uri.parse('$apiBaseURL/api/Productos/guardar_cliente');
      String? token = await StorageManager.readData('token');
      String? idUsuario = await StorageManager.readData('idUser');

      final resp = await http.post(url, body: {
        'tn': token,
        'app': 'true',
        'id_cliente': '${clienteModel.idCliente}',
        'cliente_nombre': '${clienteModel.nombreCliente}',
        'id_usuario': '$idUsuario',
        'cliente_nro_doc': '${clienteModel.nroDocCliente}',
        'cliente_tipo_doc': '${clienteModel.tipoDocCliente}',
        'cliente_nacimiento': '${clienteModel.nacimientoCLiente}',
        'cliente_sexo': 'M}',
        'cliente_direccion': '${clienteModel.direccionCliente}',
        'cliente_telefono': '${clienteModel.telefonoCliente}',
        'cliente_estado': '1',
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

   */

  Future<void> getAlertForUser() async {
    try {
      final url = Uri.parse('$apiBaseURL/api/Productos/listar_alertas_por_usuario');
      String? token = await StorageManager.readData('token');

      final resp = await http.post(url, body: {
        'tn': token,
        'app': 'true',
      });

      final decodedData = json.decode(resp.body);

      for (var i = 0; i < decodedData.length; i++) {
        AlertModel alertModel = AlertModel();

        alertModel.idAlert = decodedData[i]['id_alerta'];
        alertModel.idUsuario = decodedData[i]['id_usuario'];
        alertModel.idClient = decodedData[i]['id_cliente'];
        alertModel.alertTitle = decodedData[i]['alerta_titulo'];
        alertModel.alertDetail = decodedData[i]['alerta_detalle'];
        alertModel.alertDate = decodedData[i]['alerta_fecha'];
        alertModel.alertHour = decodedData[i]['alerta_hora'];
        alertModel.alertStatus = decodedData[i]['alerta_estado'];

        await alertDatabase.insertAlert(alertModel);

        if (alertModel.idClient != '0') {
          ClienteModel clienteModel = ClienteModel();

          clienteModel.idCliente = decodedData[i]['cliente']['id_cliente'];
          clienteModel.idUsuario = decodedData[i]['cliente']['id_usuario'];
          clienteModel.nombreCliente = decodedData[i]['cliente']['cliente_nombre'];
          clienteModel.tipoDocCliente = decodedData[i]['cliente']['cliente_tipo_doc'];
          clienteModel.nroDocCliente = decodedData[i]['cliente']['cliente_nro_doc'];
          clienteModel.nacimientoCLiente = decodedData[i]['cliente']['cliente_nacimiento'];
          clienteModel.sexoCliente = decodedData[i]['cliente']['cliente_sexo'];
          clienteModel.direccionCliente = decodedData[i]['cliente']['cliente_direccion'];
          clienteModel.telefonoCliente = decodedData[i]['cliente']['cliente_telefono'];
          clienteModel.estadoCliente = decodedData[i]['cliente']['cliente_estado'];

          await clienteDatabase.insertCliente(clienteModel);
        }
      }
    } catch (e) {
      print(e);
    }
  }
}

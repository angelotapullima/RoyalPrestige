import 'dart:convert';

import 'package:royal_prestige/core/sharedpreferences/storage_manager.dart';
import 'package:royal_prestige/database/cliente_database.dart';
import 'package:royal_prestige/src/model/cliente_model.dart';
import 'package:royal_prestige/src/utils/constants.dart';
import 'package:http/http.dart' as http;

class ClienteApi {
  final clienteDatabase = ClienteDatabase();
  Future<bool> saveClient(ClienteModel clienteModel) async {
    try {
      final url = Uri.parse('$apiBaseURL/api/Productos/guardar_cliente');
      String? token = await StorageManager.readData('token');
      String? idUsuario = await StorageManager.readData('idUser');

      final resp = await http.post(url, body: {
        'tn': token,
        'app': 'true',
        'cliente_nombre': '${clienteModel.nombreCliente}',
        'id_usuario': '$idUsuario',
        'cliente_nro_doc': '${clienteModel.nroDocCliente}',
        'cliente_tipo_doc': '${clienteModel.tipoDocCliente}',
        'cliente_nacimiento': '${clienteModel.nacimientoCLiente}',
        'cliente_sexo': '${clienteModel.sexoCliente}',
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

  
  Future<void> getClientForUser() async {
    try {
      final url = Uri.parse('$apiBaseURL/api/Productos/listar_clientes_por_usuario');
      String? token = await StorageManager.readData('token');

      final resp = await http.post(url, body: {
        'tn': token,
        'app': 'true',
      });

      final decodedData = json.decode(resp.body);

      for (var i = 0; i < decodedData.length; i++) {
        ClienteModel clienteModel = ClienteModel();

        clienteModel.idCliente = decodedData[i]['id_cliente'];
        clienteModel.idUsuario = decodedData[i]['id_usuario'];
        clienteModel.nombreCliente = decodedData[i]['cliente_nombre'];
        clienteModel.tipoDocCliente = decodedData[i]['cliente_tipo_doc'];
        clienteModel.nroDocCliente = decodedData[i]['cliente_nro_doc'];
        clienteModel.nacimientoCLiente = decodedData[i]['cliente_nacimiento'];
        clienteModel.sexoCliente = decodedData[i]['cliente_sexo'];
        clienteModel.direccionCliente = decodedData[i]['cliente_direccion'];
        clienteModel.telefonoCliente = decodedData[i]['cliente_telefono'];
        clienteModel.estadoCliente = decodedData[i]['cliente_estado'];

        await clienteDatabase.insertCliente(clienteModel);
      }
    } catch (e) {
      print(e);
    }
  }
}

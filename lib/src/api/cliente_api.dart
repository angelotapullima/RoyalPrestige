import 'dart:convert';

import 'package:royal_prestige/core/sharedpreferences/storage_manager.dart';
import 'package:royal_prestige/database/cliente_database.dart';
import 'package:royal_prestige/database/compras_database.dart';
import 'package:royal_prestige/src/model/api_model.dart';
import 'package:royal_prestige/src/model/cliente_model.dart';
import 'package:royal_prestige/src/model/compras_model.dart';
import 'package:royal_prestige/src/utils/constants.dart';
import 'package:http/http.dart' as http;

class ClienteApi {
  final clienteDatabase = ClienteDatabase();
  final comprasDatabase = ComprasDatabase();

  Future<ApiModel> saveClient(ClienteModel clienteModel) async {
    try {
      final url = Uri.parse('$apiBaseURL/api/Productos/guardar_cliente');
      String? token = await StorageManager.readData('token');
      //String? idUsuario = await StorageManager.readData('idUser');

      final resp = await http.post(url, body: {
        'tn': token,
        'app': 'true',
        'cliente_nombre': '${clienteModel.nombreCliente}',
        //'id_usuario': '$idUsuario',
        'cliente_nro_doc': '${clienteModel.nroDocCliente}',
        'cliente_codigo': '${clienteModel.codigoCliente}',
        'cliente_tipo_doc': '${clienteModel.tipoDocCliente}',
        'cliente_nacimiento': '${clienteModel.nacimientoCLiente}',
        'cliente_sexo': '${clienteModel.sexoCliente}',
        'cliente_direccion': '${clienteModel.direccionCliente}',
        'cliente_telefono': '${clienteModel.telefonoCliente}',
        'cliente_observaciones': '-',
        'cliente_estado': '1',
      });

      print('saveClient ${resp.body}');
      final decodedData = json.decode(resp.body);

      ApiModel api = ApiModel();

      api.code = decodedData['result']['code'].toString();

      if (decodedData['result']['code'] == 1) {
        api.message = decodedData['result']["mensaje"];
        return api;
      } else {
        api.message = decodedData['result']["mensaje"];
        return api;
      }
    } catch (e) {
      print('saveClient $e');
      ApiModel api = ApiModel();

      api.code = '2';
      api.message = 'Ocurrió un error';
      return api;
    }
  }

  Future<bool> editCLient(ClienteModel clienteModel) async {
    try {
      final url = Uri.parse('$apiBaseURL/api/Productos/guardar_cliente');
      String? token = await StorageManager.readData('token');
      //String? idUsuario = await StorageManager.readData('idUser');

      final resp = await http.post(url, body: {
        'tn': token,
        'app': 'true',
        'id_cliente': '${clienteModel.idCliente}',
        'cliente_nombre': '${clienteModel.nombreCliente}',
        //'id_usuario': '$idUsuario',
        'cliente_nro_doc': '${clienteModel.nroDocCliente}',
        'cliente_codigo': '${clienteModel.codigoCliente}',
        'cliente_tipo_doc': '${clienteModel.tipoDocCliente}',
        'cliente_nacimiento': '${clienteModel.nacimientoCLiente}',
        'cliente_sexo': '${clienteModel.sexoCliente}',
        'cliente_direccion': '${clienteModel.direccionCliente}',
        'cliente_telefono': '${clienteModel.telefonoCliente}',
        'cliente_observaciones': '-',
        'cliente_estado': '1',
      });

      if (resp.statusCode == 200) {
        print('editCLient ${resp.body}');

        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('editCLient $e');
      return false;
    }
  }

  Future<void> getClientForUser() async {
    try {
      final url = Uri.parse('$apiBaseURL/api/Productos/listar_clientes_usuario_nuevo');
      String? token = await StorageManager.readData('token');

      final resp = await http.post(url, body: {
        'tn': token,
        'app': 'true',
      });

      print('getClientForUser ${resp.body}');
      final decodedData = json.decode(resp.body);

      if (decodedData['result']['code'] == '1') {
        if (decodedData['data'].length > 0) {
          for (var i = 0; i < decodedData['data'].length; i++) {
            var datos = decodedData['data'][i];
            ClienteModel clienteModel = ClienteModel();
            clienteModel.idCliente = datos['id_cliente'];
            clienteModel.idUsuario = decodedData['data'][i]['id_usuario'];
            clienteModel.nombreCliente = decodedData['data'][i]['cliente_nombre'];
            clienteModel.tipoDocCliente = decodedData['data'][i]['cliente_tipo_doc'];
            clienteModel.nroDocCliente = decodedData['data'][i]['cliente_nro_doc'];
            clienteModel.nacimientoCLiente = decodedData['data'][i]['cliente_nacimiento'];
            clienteModel.sexoCliente = decodedData['data'][i]['cliente_sexo'];
            clienteModel.direccionCliente = decodedData['data'][i]['cliente_direccion'];
            clienteModel.telefonoCliente = decodedData['data'][i]['cliente_telefono'];
            clienteModel.observacionesCliente = decodedData['data'][i]['cliente_observaciones'];
            clienteModel.estadoCliente = decodedData['data'][i]['cliente_estado'];
            clienteModel.codigoCliente = decodedData['data'][i]['cliente_codigo'];

            if (decodedData['data'][i]['compras'].length > 0) {
              //Tipo 1, es Cliente
              clienteModel.tipo = '1';

              for (var x = 0; x < decodedData['data'][i]['compras'].length; x++) {
                var compras = decodedData['data'][i]['compras'][x];

                ComprasModel compra = ComprasModel();
                compra.idCompra = compras["id_compra"];
                compra.idUsuario = compras["id_usuario"];
                compra.idCliente = compras["id_cliente"];
                compra.idProducto = compras["id_producto"];
                compra.montoCuotaCompra = compras["compra_monto_cuota"];
                compra.fechaPagoCompra = compras["compra_fecha_pago"];
                compra.fechaCompra = compras["compra_fecha"];
                compra.observacionCompra = compras["compra_observacion"];
                compra.estadoCompra = compras["compra_estado"];

                await comprasDatabase.insertCompra(compra);
              }
            } else {
              //Tipo 2, es Prospecto
              clienteModel.tipo = '2';
            }

            await clienteDatabase.insertCliente(clienteModel);
          }
        }
      }
    } catch (e) {
      print('getClientForUser $e');
    }
  }

  Future<bool> guardarCompra(ComprasModel compra) async {
    try {
      final url = Uri.parse('$apiBaseURL/api/Productos/guardar_compra');
      String? token = await StorageManager.readData('token');
      print('${compra.idProducto}');

      final resp = await http.post(url, body: {
        'tn': token,
        'app': 'true',
        'id_cliente': '${compra.idCliente}',
        'id_producto': '${compra.idProducto}',
        'compra_monto_cuota': '${compra.montoCuotaCompra}',
        'compra_fecha_pago': '${compra.fechaPagoCompra}',
        'compra_fecha': '${compra.fechaCompra}',
        'compra_observacion': '${compra.observacionCompra}',
        'compra_estado': '1',
      });

      print('guardarCompra ${resp.body}');
      final decodedData = json.decode(resp.body);
      print(decodedData);

      if (resp.statusCode == 200) {
        if (decodedData["result"]["code"] == 1) {
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      print('guardarCompra $e');
      return false;
    }
  }

  Future<bool> eliminarCliente(String idCliente) async {
    try {
      final url = Uri.parse('$apiBaseURL/api/Productos/eliminar_cliente');
      String? token = await StorageManager.readData('token');
      print('$idCliente');

      final resp = await http.post(url, body: {
        'tn': token,
        'app': 'true',
        'id_cliente': '$idCliente',
      });

      print('eliminarCliente ${resp.body}');
      final decodedData = json.decode(resp.body);
      print(decodedData);

      if (resp.statusCode == 200) {
        if (decodedData["result"]["code"] == 1) {
          await clienteDatabase.deleteClienteById(idCliente);
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      print('eliminarCliente $e');
      return false;
    }
  }
}

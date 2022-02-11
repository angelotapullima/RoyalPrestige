import 'package:royal_prestige/core/sharedpreferences/storage_manager.dart';
import 'package:royal_prestige/src/api/cliente_api.dart';
import 'package:royal_prestige/src/model/cliente_model.dart';
import 'package:rxdart/rxdart.dart';

class ClientesBloc {
  final clienteApi = ClienteApi();

  final _clientesController = BehaviorSubject<List<ClienteModel>>();
  Stream<List<ClienteModel>> get clienteStream => _clientesController.stream;

  final _clienteIdController = BehaviorSubject<List<ClienteModel>>();
  Stream<List<ClienteModel>> get clienteIdStream => _clienteIdController.stream;

  dispose() {
    _clientesController.close();
    _clienteIdController.close();
  }

  void getClientForTipo(String type) async {
    String? idUsuario = await StorageManager.readData('idUser');
    _clientesController.sink.add(
      await clienteApi.clienteDatabase.getClientPorTipo(idUsuario!, type),
    );
    await clienteApi.getClientForUser();
    _clientesController.sink.add(
      await clienteApi.clienteDatabase.getClientPorTipo(idUsuario, type),
    );
  }

  void obtenerClienteById(String idCliente) async {
    _clienteIdController.sink.add(await clienteApi.clienteDatabase.getClientPorIdCliente(idCliente));
    await clienteApi.getClientForUser();
    _clienteIdController.sink.add(await clienteApi.clienteDatabase.getClientPorIdCliente(idCliente));
  }
}

import 'package:royal_prestige/core/sharedpreferences/storage_manager.dart';
import 'package:royal_prestige/src/api/cliente_api.dart';
import 'package:royal_prestige/src/model/cliente_model.dart';
import 'package:rxdart/rxdart.dart';

class ClientesBloc {
  final clienteApi = ClienteApi();

  final _clientesController = BehaviorSubject<List<ClienteModel>>();
  Stream<List<ClienteModel>> get clienteStream => _clientesController.stream;

  dispose() {
    _clientesController.close();
  }

  void getClient() async {
    String? idUsuario = await StorageManager.readData('idUser');
    _clientesController.sink.add(await clienteApi.clienteDatabase.getClient(idUsuario!));
    await clienteApi.getClientForUser();
    _clientesController.sink.add(await clienteApi.clienteDatabase.getClient(idUsuario));
  }
}

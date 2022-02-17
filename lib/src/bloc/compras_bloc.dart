import 'package:royal_prestige/src/api/cliente_api.dart';
import 'package:royal_prestige/src/model/compras_model.dart';
import 'package:rxdart/rxdart.dart';

class ComprasBloc {
  final clientesApi = ClienteApi();
  final _comprasClienteController = BehaviorSubject<List<ComprasModel>>();

  Stream<List<ComprasModel>> get comprasClienteStream => _comprasClienteController.stream;

  dispose() {
    _comprasClienteController.close();
  }

  void obtenerComprasByIdCliente(String idCliente) async {
    _comprasClienteController.sink.add(await getCompras(idCliente));
    await clientesApi.getClientForUser();
    _comprasClienteController.sink.add(await getCompras(idCliente));
  }

  Future<List<ComprasModel>> getCompras(String idCliente) async {
    final List<ComprasModel> listReturn = [];

    try {
      final listCompras = await clientesApi.comprasDatabase.getComprasByIdCliente(idCliente);

      if (listCompras.length > 0) {
        for (var i = 0; i < listCompras.length; i++) {
          if (listCompras[i].idProducto.toString().length > 2) {
            listReturn.add(listCompras[i]);
          }
        }
      }

      return listReturn;
    } catch (e) {
      return listReturn;
    }
  }
}

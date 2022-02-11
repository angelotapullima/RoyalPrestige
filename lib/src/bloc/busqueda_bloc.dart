import 'package:royal_prestige/core/sharedpreferences/storage_manager.dart';
import 'package:royal_prestige/database/cliente_database.dart';
import 'package:royal_prestige/src/model/cliente_model.dart';
import 'package:rxdart/rxdart.dart';

class BusquedaGeneralTab {
  final clienteDatabase = ClienteDatabase();

  //instancia que captura el ultimo elemento agregado al controlador
  final selectTab = BehaviorSubject<int>();
  final cantidadClientes = BehaviorSubject<int>();
  final cantidadProspectos = BehaviorSubject<int>();

  final _clientesLisController = new BehaviorSubject<List<ClienteModel>>();
  final __prospectosListController = new BehaviorSubject<List<ClienteModel>>();

  Stream<int> get selectPageStream => selectTab.stream;
  Stream<int> get cantidadClientesStream => cantidadClientes.stream;
  Stream<int> get cantidadProspectosStream => cantidadProspectos.stream;

  Stream<List<ClienteModel>> get productosQueryEnchiladasStream => _clientesLisController.stream;
  Stream<List<ClienteModel>> get productosQueryCafeStream => __prospectosListController.stream;

  Function(int) get changePage => selectTab.sink.add;
  Function(int) get changecantidadClientes => cantidadClientes.sink.add;
  Function(int) get changecantidadProspectos => cantidadProspectos.sink.add;

  int? get page => selectTab.value;

  dispose() {
    _clientesLisController.close();
    __prospectosListController.close();
    selectTab.close();
    cantidadClientes.close();
    cantidadProspectos.close();
  }

  void queryClientes(String query, bool inicial) async {
    if (query.length > 0) {
      final List<ClienteModel> listGeneral = [];
      String? idUser = await StorageManager.readData('idUser');

      var listProductos = await clienteDatabase.getClientQueryPorTipo(query, idUser!, '1');

      for (var x = 0; x < listProductos.length; x++) {
        ClienteModel clienteModel = ClienteModel();

        clienteModel.idCliente = listProductos[x].idCliente;
        clienteModel.idUsuario = listProductos[x].idUsuario;
        clienteModel.nombreCliente = listProductos[x].nombreCliente;
        clienteModel.tipoDocCliente = listProductos[x].tipoDocCliente;
        clienteModel.nroDocCliente = listProductos[x].nroDocCliente;
        clienteModel.nacimientoCLiente = listProductos[x].nacimientoCLiente;
        clienteModel.sexoCliente = listProductos[x].sexoCliente;
        clienteModel.direccionCliente = listProductos[x].direccionCliente;
        clienteModel.telefonoCliente = listProductos[x].telefonoCliente;
        clienteModel.observacionesCliente = listProductos[x].observacionesCliente;
        clienteModel.estadoCliente = listProductos[x].estadoCliente;
        clienteModel.tipo = listProductos[x].tipo;

        listGeneral.add(clienteModel);
      }

      cantidadClientes.sink.add(listGeneral.length);
      print('cantidad ${listGeneral.length}');
      _clientesLisController.sink.add(listGeneral);
    } else {
      cantidadClientes.sink.add(20000);
      _clientesLisController.sink.add([]);
    }
  }

  void queryProspectos(String query, bool inicial) async {
    if (query.length > 0) {
      final List<ClienteModel> listGeneral = [];
      String? idUser = await StorageManager.readData('idUser');

      var listProductos = await clienteDatabase.getClientQueryPorTipo(query, idUser!, '2');

      for (var x = 0; x < listProductos.length; x++) {
        ClienteModel clienteModel = ClienteModel();

        clienteModel.idCliente = listProductos[x].idCliente;
        clienteModel.idUsuario = listProductos[x].idUsuario;
        clienteModel.nombreCliente = listProductos[x].nombreCliente;
        clienteModel.tipoDocCliente = listProductos[x].tipoDocCliente;
        clienteModel.nroDocCliente = listProductos[x].nroDocCliente;
        clienteModel.nacimientoCLiente = listProductos[x].nacimientoCLiente;
        clienteModel.sexoCliente = listProductos[x].sexoCliente;
        clienteModel.direccionCliente = listProductos[x].direccionCliente;
        clienteModel.telefonoCliente = listProductos[x].telefonoCliente;
        clienteModel.observacionesCliente = listProductos[x].observacionesCliente;
        clienteModel.estadoCliente = listProductos[x].estadoCliente;
        clienteModel.tipo = listProductos[x].tipo;

        listGeneral.add(clienteModel);
      }

      cantidadProspectos.sink.add(listGeneral.length);
      print('cantidad ${listGeneral.length}');
      __prospectosListController.sink.add(listGeneral);
    } else {
      cantidadProspectos.sink.add(20000);
      __prospectosListController.sink.add([]);
    }
  }

  void resetearCantidades() async {
    cantidadClientes.sink.add(20000);
    cantidadProspectos.sink.add(20000);

    _clientesLisController.sink.add([]);
    __prospectosListController.sink.add([]);
  }
}

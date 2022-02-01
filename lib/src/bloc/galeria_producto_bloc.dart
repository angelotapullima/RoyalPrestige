

import 'package:royal_prestige/database/galery_database.dart';
import 'package:royal_prestige/src/api/productos_api.dart';
import 'package:royal_prestige/src/model/galery_model.dart';
import 'package:rxdart/rxdart.dart';

class GaleryBloc {
  final galeryDatabase = GaleryDatabase();
  final productosApi = ProductosApi();
  final _galeriaController = BehaviorSubject<List<GaleryModel>>();

  final _selectPageController = BehaviorSubject<int>();

  Stream<int> get selectPageStream => _selectPageController.stream;

  Function(int) get changePage => _selectPageController.sink.add;

  // Obtener el último valor ingresado a los streams
  int? get page => _selectPageController.value;

  Stream<List<GaleryModel>> get galeriaStream => _galeriaController.stream;

  dispose() {
    _galeriaController.close();
    _selectPageController.close();
  }

  void obtenerGalerias(String id) async {
    _galeriaController.sink.add(await galeryDatabase.getGaleryForIdProduct(id));
    await productosApi.listarProductos();
    _galeriaController.sink.add(await galeryDatabase.getGaleryForIdProduct(id));
  }
}

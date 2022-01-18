import 'package:royal_prestige/src/api/productos_api.dart';
import 'package:royal_prestige/src/model/categoria_model.dart';
import 'package:royal_prestige/src/model/producto_model.dart';
import 'package:rxdart/rxdart.dart';

class ProductosBloc {
  final productoApi = ProductosApi();

  final _productosController = BehaviorSubject<List<ProductoModel>>();
  Stream<List<ProductoModel>> get productosStream => _productosController.stream;

  final _categoriasController = BehaviorSubject<List<CategoriaModel>>();
  Stream<List<CategoriaModel>> get categoriaStream => _categoriasController.stream;

  dispose() {
    _productosController.close();
    _categoriasController.close();
  }

  void obtenerCategorias() async {
    _categoriasController.sink.add(await productoApi.categoriaDatabase.getCategorias());
    await productoApi.listarProductos();
    _categoriasController.sink.add(await productoApi.categoriaDatabase.getCategorias());
  }

  void obtenerProductosByIdCategoria(String idCategoria) async {
    _productosController.sink.add(await productoApi.productoDatabase.getProductosByIdCategoria(idCategoria));
  }
}

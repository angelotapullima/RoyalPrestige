import 'package:royal_prestige/database/producto_database.dart';
import 'package:royal_prestige/src/api/productos_api.dart';
import 'package:royal_prestige/src/model/categoria_model.dart';
import 'package:royal_prestige/src/model/producto_model.dart';
import 'package:rxdart/rxdart.dart';

class ProductosBloc {
  final productoApi = ProductosApi();
  final productoDatabase = ProductoDatabase();

  final _productosController = BehaviorSubject<List<ProductoModel>>();
  Stream<List<ProductoModel>> get productosStream => _productosController.stream;

  final _productosQueryController = BehaviorSubject<List<ProductoModel>>();
  Stream<List<ProductoModel>> get productosQueryStream => _productosQueryController.stream;

  final _productoidController = BehaviorSubject<List<ProductoModel>>();
  Stream<List<ProductoModel>> get productoIdStream => _productoidController.stream;

  final _categoriasController = BehaviorSubject<List<CategoriaModel>>();
  Stream<List<CategoriaModel>> get categoriaStream => _categoriasController.stream;

  dispose() {
    _productosController.close();
    _productosQueryController.close();
    _categoriasController.close();
    _productoidController.close();
  }

  void obtenerCategorias() async {
    _categoriasController.sink.add(await productoApi.categoriaDatabase.getCategorias());
    await productoApi.listarProductos();
    _categoriasController.sink.add(await productoApi.categoriaDatabase.getCategorias());
  }

  void obtenerProductosByIdCategoria(String idCategoria) async {
    _productosController.sink.add(await productoApi.productoDatabase.getProductosByIdCategoria(idCategoria));
  }

  void obtenerProductoByIdProducto(String idProducto) async {
    _productoidController.sink.add(await productoApi.productoDatabase.getProductosByIdProducto(idProducto));
  }

  void obtenerProductoPorQuery(String query) async {
    _productosQueryController.sink.add(await productoDatabase.getProductoQuery(query));
  }
}

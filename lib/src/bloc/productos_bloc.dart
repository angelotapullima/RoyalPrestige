import 'package:royal_prestige/database/galery_database.dart';
import 'package:royal_prestige/database/info_product_database.dart';
import 'package:royal_prestige/database/producto_database.dart';
import 'package:royal_prestige/src/api/productos_api.dart';
import 'package:royal_prestige/src/model/categoria_model.dart';
import 'package:royal_prestige/src/model/galery_model.dart';
import 'package:royal_prestige/src/model/info_product_model.dart';
import 'package:royal_prestige/src/model/producto_model.dart';
import 'package:rxdart/rxdart.dart';

class ProductosBloc {
  final productoApi = ProductosApi();
  final productoDatabase = ProductoDatabase();
  final galeryDatabase = GaleryDatabase();
  final infoProductoDatabase = InfoProductoDatabase();

  final _productosController = BehaviorSubject<List<ProductoModel>>();
  Stream<List<ProductoModel>> get productosStream => _productosController.stream;

  final _productosQueryController = BehaviorSubject<List<ProductoModel>>();
  Stream<List<ProductoModel>> get productosQueryStream => _productosQueryController.stream;

  final _productosQuery2Controller = BehaviorSubject<List<ProductoModel>>();
  Stream<List<ProductoModel>> get productosQuery2Stream => _productosQuery2Controller.stream;

  final _productoidController = BehaviorSubject<List<ProductoModel>>();
  Stream<List<ProductoModel>> get productoIdStream => _productoidController.stream;

  final _categoriasController = BehaviorSubject<List<CategoriaModel>>();
  Stream<List<CategoriaModel>> get categoriaStream => _categoriasController.stream;

  final _categoriaIdController = BehaviorSubject<List<CategoriaModel>>();
  Stream<List<CategoriaModel>> get categoriaIdStream => _categoriaIdController.stream;

  final _cantidadSubidaImagen = BehaviorSubject<double>();
  Stream<double> get subidaImagenStream => _cantidadSubidaImagen.stream;

  final _infoProductoIDDocController = BehaviorSubject<List<InfoProductoModel>>();
  Stream<List<InfoProductoModel>> get infoProductIDDocStream => _infoProductoIDDocController.stream;

  final _infoProductoIDUrlController = BehaviorSubject<List<InfoProductoModel>>();
  Stream<List<InfoProductoModel>> get infoProductIDUrlStream => _infoProductoIDUrlController.stream;

  Function(double) get changeSubidaImagen => _cantidadSubidaImagen.sink.add;

  dispose() {
    _productosController.close();
    _productosQueryController.close();
    _productosQuery2Controller.close();
    _categoriasController.close();
    _productoidController.close();
    _cantidadSubidaImagen.close();
    _categoriaIdController.close();
    _infoProductoIDDocController.close();
    _infoProductoIDUrlController.close();
  }

  void obtenerCategorias() async {
    _categoriasController.sink.add(await productoApi.categoriaDatabase.getCategorias());
    await productoApi.listarProductos();
    _categoriasController.sink.add(await productoApi.categoriaDatabase.getCategorias());
  }

  void obtenerCategoriasById(String idCategoria) async {
    _categoriaIdController.sink.add(await productoApi.categoriaDatabase.getCategoriaById(idCategoria));
  }

  void obtenerProductosByIdCategoria(String idCategoria) async {
    final List<ProductoModel> pro = [];

    final products = await productoApi.productoDatabase.getProductosByIdCategoria(idCategoria);

    if (products.length > 0) {
      for (var i = 0; i < products.length; i++) {
        final List<GaleryModel> galeryListFinal = [];
        ProductoModel productoModel = ProductoModel();

        productoModel.idProducto = products[i].idProducto;
        productoModel.idCategoria = products[i].idCategoria;
        productoModel.codigoProducto = products[i].codigoProducto;
        productoModel.nombreProducto = products[i].nombreProducto;
        productoModel.precioProducto = products[i].precioProducto;
        productoModel.regaloProducto = products[i].regaloProducto;
        productoModel.precioRegaloProducto = products[i].precioRegaloProducto;
        productoModel.fotoProducto = products[i].fotoProducto;
        productoModel.descripcionProducto = products[i].descripcionProducto;
        productoModel.estadoProducto = products[i].estadoProducto;

        final galeryOk = await galeryDatabase.getGaleryForIdProduct(products[i].idProducto.toString());

        if (galeryOk.length > 0) {
          for (var x = 0; x < galeryOk.length; x++) {
            GaleryModel galeryModel = GaleryModel();
            galeryModel.idGalery = galeryOk[x].idGalery;
            galeryModel.idProduct = galeryOk[x].idProduct;
            galeryModel.name = galeryOk[x].name;
            galeryModel.file = galeryOk[x].file;
            galeryModel.status = galeryOk[x].status;

            galeryListFinal.add(galeryModel);
          }
        }
        productoModel.galery = galeryListFinal;
        pro.add(productoModel);
      }
    }
    _productosController.sink.add(pro);
  }

  void obtenerProductoByIdProducto(String idProducto) async {
    final List<ProductoModel> listFinal = [];

    final productList = await productoApi.productoDatabase.getProductosByIdProducto(idProducto);

    if (productList.length > 0) {
      for (var i = 0; i < productList.length; i++) {
        final List<GaleryModel> galeryListFinal = [];
        ProductoModel productoModel = ProductoModel();

        productoModel.idProducto = productList[i].idProducto;
        productoModel.idCategoria = productList[i].idCategoria;
        productoModel.codigoProducto = productList[i].codigoProducto;
        productoModel.nombreProducto = productList[i].nombreProducto;
        productoModel.precioProducto = productList[i].precioProducto;
        productoModel.regaloProducto = productList[i].regaloProducto;
        productoModel.precioRegaloProducto = productList[i].precioRegaloProducto;
        productoModel.fotoProducto = productList[i].fotoProducto;
        productoModel.descripcionProducto = productList[i].descripcionProducto;
        productoModel.estadoProducto = productList[i].estadoProducto;

        final galeryOk = await galeryDatabase.getGaleryForIdProduct(productList[i].idProducto.toString());

        if (galeryOk.length > 0) {
          for (var x = 0; x < galeryOk.length; x++) {
            GaleryModel galeryModel = GaleryModel();
            galeryModel.idGalery = galeryOk[x].idGalery;
            galeryModel.idProduct = galeryOk[x].idProduct;
            galeryModel.name = galeryOk[x].name;
            galeryModel.file = galeryOk[x].file;
            galeryModel.status = galeryOk[x].status;

            galeryListFinal.add(galeryModel);
          }
        }
        productoModel.galery = galeryListFinal;

        listFinal.add(productoModel);
      }
    }
    _productoidController.sink.add(listFinal);
  }

  void obtenerProductoPorQuery(String query) async {
    _productosQueryController.sink.add(await productoDatabase.getProductoQuery(query));
  }

  void obtenerProductoPorQuery2(String query) async {
    _productosQuery2Controller.sink.add(await productoDatabase.getProductoQuery(query));
  }

  void getInfoProductByID(String id) async {
    final List<InfoProductoModel> docs = [];
    final List<InfoProductoModel> urls = [];
    final list = await infoProductoDatabase.getInfoProForIdProduct(id);

    if (list.length > 0) {
      for (var i = 0; i < list.length; i++) {
        if (list[i].proTipo == '0') {
          //url
          InfoProductoModel infoProductoModel = InfoProductoModel();
          infoProductoModel.idProDoc = list[i].idProDoc;
          infoProductoModel.idProducto = list[i].idProducto;
          infoProductoModel.proTipo = list[i].proTipo;
          infoProductoModel.proTitulo = list[i].proTitulo;
          infoProductoModel.proDetalle = list[i].proDetalle;
          infoProductoModel.proUrl = list[i].proUrl;
          infoProductoModel.proEstado = list[i].proEstado;
          urls.add(infoProductoModel);
        } else {
          //docu
          InfoProductoModel infoProductoModel = InfoProductoModel();
          infoProductoModel.idProDoc = list[i].idProDoc;
          infoProductoModel.idProducto = list[i].idProducto;
          infoProductoModel.proTipo = list[i].proTipo;
          infoProductoModel.proTitulo = list[i].proTitulo;
          infoProductoModel.proDetalle = list[i].proDetalle;
          infoProductoModel.proUrl = list[i].proUrl;
          infoProductoModel.proEstado = list[i].proEstado;
          docs.add(infoProductoModel);
        }
      }
    }

    _infoProductoIDDocController.sink.add(docs);
    _infoProductoIDUrlController.sink.add(urls);
  }
}

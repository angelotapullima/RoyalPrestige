import 'package:royal_prestige/database/galery_database.dart';
import 'package:royal_prestige/database/producto_database.dart';
import 'package:royal_prestige/src/api/cliente_api.dart';
import 'package:royal_prestige/src/model/compras_model.dart';
import 'package:royal_prestige/src/model/galery_model.dart';
import 'package:royal_prestige/src/model/producto_model.dart';
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
        final productoDatabase = ProductoDatabase();
        final galeryDatabase = GaleryDatabase();
        for (var i = 0; i < listCompras.length; i++) {
          final listProducto = await productoDatabase.getProductosByIdProducto(listCompras[i].idProducto.toString());

          if (listProducto.length > 0) {
            ComprasModel compra = ComprasModel();
            compra.idCompra = listCompras[i].idCompra;
            compra.idUsuario = listCompras[i].idUsuario;
            compra.idCliente = listCompras[i].idCliente;
            compra.idProducto = listCompras[i].idProducto;
            compra.montoCuotaCompra = listCompras[i].montoCuotaCompra;
            compra.fechaPagoCompra = listCompras[i].fechaPagoCompra;
            compra.fechaCompra = listCompras[i].fechaCompra;
            compra.observacionCompra = listCompras[i].observacionCompra;
            compra.estadoCompra = listCompras[i].estadoCompra;

            final List<GaleryModel> galeryListFinal = [];
            ProductoModel productoModel = ProductoModel();

            productoModel.idProducto = listProducto[0].idProducto;
            productoModel.idCategoria = listProducto[0].idCategoria;
            productoModel.codigoProducto = listProducto[0].codigoProducto;
            productoModel.nombreProducto = listProducto[0].nombreProducto;
            productoModel.precioProducto = listProducto[0].precioProducto;
            productoModel.regaloProducto = listProducto[0].regaloProducto;
            productoModel.precioRegaloProducto = listProducto[0].precioRegaloProducto;
            productoModel.fotoProducto = listProducto[0].fotoProducto;
            productoModel.descripcionProducto = listProducto[0].descripcionProducto;
            productoModel.estadoProducto = listProducto[0].estadoProducto;

            final galeryOk = await galeryDatabase.getGaleryForIdProduct(listProducto[0].idProducto.toString());

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

            compra.producto = productoModel;

            listReturn.add(compra);
          }
        }
      }
      return listReturn;
    } catch (e) {
      return listReturn;
    }
  }
}

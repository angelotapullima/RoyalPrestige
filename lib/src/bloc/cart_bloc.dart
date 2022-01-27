import 'package:royal_prestige/database/cart_database.dart';
import 'package:royal_prestige/database/producto_database.dart';
import 'package:royal_prestige/src/model/producto_model.dart';
import 'package:rxdart/rxdart.dart';

class CartBloc {
  final cartDatabase = CartDatabase();
  final productoDatabase = ProductoDatabase();

  final _cartController = BehaviorSubject<List<ProductoModel>>();
  Stream<List<ProductoModel>> get cartStream => _cartController.stream;

  dispose() {
    _cartController.close();
  }

  void getCart() async {
    final List<ProductoModel> productList = [];

    final listProduct = await cartDatabase.getCart();

    if (listProduct.length > 0) {
      for (var i = 0; i < listProduct.length; i++) {
        final pro = await productoDatabase.getProductosByIdProducto(listProduct[i].idProduct.toString());
        if (pro.length > 0) {
          ProductoModel producto = ProductoModel();
          producto.idProducto = listProduct[i].idProduct;
          producto.idCategoria = pro[0].idCategoria;
          producto.codigoProducto = pro[0].codigoProducto;
          producto.nombreProducto = pro[0].nombreProducto;
          producto.precioProducto = pro[0].precioProducto;
          producto.regaloProducto = pro[0].regaloProducto;
          producto.precioRegaloProducto = pro[0].precioRegaloProducto;
          producto.fotoProducto = pro[0].fotoProducto;
          producto.descripcionProducto = pro[0].descripcionProducto;
          producto.estadoProducto = pro[0].estadoProducto;
          producto.cantidad = listProduct[i].amount;
          producto.subtotal = listProduct[i].subtotal;

          productList.add(producto);
        }
      }
    }
    _cartController.sink.add(productList);
  }
}

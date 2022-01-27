import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:royal_prestige/database/cart_database.dart';
import 'package:royal_prestige/src/bloc/provider_bloc.dart';
import 'package:royal_prestige/src/model/cart_model.dart';
import 'package:royal_prestige/src/model/producto_model.dart';
import 'package:royal_prestige/src/utils/colors.dart';
import 'package:royal_prestige/src/utils/responsive.dart';
import 'package:royal_prestige/src/utils/utils.dart';
import 'package:royal_prestige/src/widget/show_loading.dart';

class DetalleProducto extends StatefulWidget {
  const DetalleProducto({Key? key, required this.idProducto}) : super(key: key);
  final String idProducto;

  @override
  State<DetalleProducto> createState() => _DetalleProductoState();
}

class _DetalleProductoState extends State<DetalleProducto> {
  final _controller = Controller();
  @override
  Widget build(BuildContext context) {
    final productoBloc = ProviderBloc.productos(context);
    productoBloc.obtenerProductoByIdProducto(widget.idProducto);

    final responsive = Responsive.of(context);
    return Scaffold(
      body: StreamBuilder(
        stream: productoBloc.productoIdStream,
        builder: (context, AsyncSnapshot<List<ProductoModel>> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.length > 0) {
              return AnimatedBuilder(
                  animation: _controller,
                  builder: (_, t) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: ScreenUtil().setHeight(330),
                          child: Stack(
                            children: [
                              Container(
                                height: ScreenUtil().setHeight(290),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: colorPrimary,
                                  borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(30),
                                    bottomLeft: Radius.circular(30),
                                  ),
                                ),
                                child: Image.asset('assets/img/picture2.jpg'),
                              ),
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Container(
                                  margin: EdgeInsets.symmetric(
                                    horizontal: ScreenUtil().setWidth(20),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: ScreenUtil().setWidth(23),
                                    vertical: ScreenUtil().setHeight(18),
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.3),
                                        spreadRadius: 1,
                                        blurRadius: 3,
                                        offset: const Offset(1, 0), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: Container(
                                    height: ScreenUtil().setHeight(50),
                                    child: ListView.builder(
                                      itemCount: 5,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (_, index) {
                                        return Container(
                                          margin: EdgeInsets.only(
                                            right: ScreenUtil().setWidth(24),
                                          ),
                                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
                                          child: Image.asset('assets/img/picture2.jpg'),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              SafeArea(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: colorPrimary,
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(color: Colors.white),
                                  ),
                                  margin: EdgeInsets.only(
                                    left: ScreenUtil().setWidth(20),
                                  ),
                                  child: BackButton(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: ScreenUtil().setHeight(24),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: ScreenUtil().setWidth(24),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  '${snapshot.data![0].nombreProducto}',
                                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(24)),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  _controller.changeExpanded2(!_controller.expanded2);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(color: colorPrimary),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  padding: EdgeInsets.all(2),
                                  child: Icon(
                                    Icons.keyboard_arrow_down,
                                    color: colorPrimary,
                                    size: ScreenUtil().setHeight(20),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: ScreenUtil().setHeight(12),
                        ),
                        (_controller.expanded2)
                            ? Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: ScreenUtil().setWidth(24),
                                ),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: ScreenUtil().setWidth(23),
                                    vertical: ScreenUtil().setHeight(18),
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.3),
                                        spreadRadius: 1,
                                        blurRadius: 3,
                                        offset: const Offset(1, 0), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: Text(
                                    '${snapshot.data![0].regaloProducto} \n S/.${snapshot.data![0].precioRegaloProducto}',
                                    style: TextStyle(fontWeight: FontWeight.w300, fontSize: ScreenUtil().setSp(11)),
                                  ),
                                ),
                              )
                            : Container(),
                        SizedBox(
                          height: ScreenUtil().setHeight(12),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: ScreenUtil().setWidth(24),
                          ),
                          child: Text(
                            'Descripción',
                            style: TextStyle(fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(13)),
                          ),
                        ),
                        SizedBox(
                          height: ScreenUtil().setHeight(6),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: ScreenUtil().setWidth(24),
                          ),
                          child: Text(
                            '${snapshot.data![0].descripcionProducto}',
                            style: TextStyle(fontWeight: FontWeight.w300, fontSize: ScreenUtil().setSp(11)),
                          ),
                        ),
                        SizedBox(
                          height: ScreenUtil().setHeight(24),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: ScreenUtil().setWidth(24),
                          ),
                          child: _expandedContainer('Precio S/. ${snapshot.data![0].precioProducto}', _controller.expanded, _contenido()),
                        ),
                        Spacer(),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: ScreenUtil().setHeight(20),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: ScreenUtil().setWidth(20),
                                ),
                                width: ScreenUtil().setWidth(160),
                                decoration: BoxDecoration(
                                  border: Border.all(color: colorPrimary),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        _controller.changeCantidad(-1);
                                      },
                                      child: Text(
                                        '-',
                                        style: TextStyle(
                                          fontSize: ScreenUtil().setSp(40),
                                          color: colorPrimary,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      '${_controller.cantidad}',
                                      style: TextStyle(fontSize: ScreenUtil().setSp(24)),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        _controller.changeCantidad(1);
                                      },
                                      child: Text(
                                        '+',
                                        style: TextStyle(
                                          fontSize: ScreenUtil().setSp(30),
                                          color: colorPrimary,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: ScreenUtil().setWidth(50),
                              ),
                              InkWell(
                                onTap: () {
                                  dialiogCart(
                                    context,
                                    responsive,
                                    snapshot.data![0],
                                    '${_controller.cantidad}',
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: colorPrimary,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  padding: EdgeInsets.all(5),
                                  child: Icon(
                                    Icons.shopping_cart,
                                    color: Colors.white,
                                    size: ScreenUtil().setHeight(30),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  });
            } else {
              return Center(
                child: Text('Cargar nuevamente'),
              );
            }
          } else {
            return ShowLoadding(
              active: true,
              h: double.infinity,
              w: double.infinity,
              fondo: Colors.transparent,
              colorText: Colors.black,
            );
          }
        },
      ),
    );
  }

  Future<dynamic> dialiogCart(BuildContext context, Responsive responsive, ProductoModel productoModel, String cantidad) {
    return showDialog(
      barrierDismissible: true,
      context: context,
      builder: (_) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
          contentPadding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
          content: Container(
            width: responsive.wp(90),
            height: responsive.hp(28),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: responsive.wp(2)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Elige una opción',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: ScreenUtil().setSp(20),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Divider(),
                  InkWell(
                    onTap: () async {
                      /*
  String? ;
  String? ;
  String? ;
  String? ;
  String? ;
  String? ;
   */
                      final cartDatabase = CartDatabase();

                      final list = await cartDatabase.getCartForId(productoModel.idProducto.toString());
                      if (list.length > 0) {
                        var subtotalex = (double.parse(cantidad) + double.parse(list[0].amount.toString())) *
                            double.parse(productoModel.precioProducto.toString());
                        CartModel cartModel = CartModel();
                        cartModel.idProduct = productoModel.idProducto;
                        /* cartModel.descripcionProducto = productoModel.descripcionProducto;
                        cartModel.nombreProducto = productoModel.nombreProducto;
                        cartModel.precioProducto = productoModel.precioProducto;
                        cartModel.regaloProducto = productoModel.regaloProducto;
                        cartModel.precioRegaloProducto = productoModel.precioRegaloProducto;
                        cartModel.fotoProducto = productoModel.fotoProducto; */
                        cartModel.amount = (double.parse(cantidad) + double.parse(list[0].amount.toString())).toString();
                        cartModel.subtotal = subtotalex.toString();
                        cartModel.status = productoModel.estadoProducto;

                        await cartDatabase.insertCart(cartModel);
                      } else {
                        var subtotalex = double.parse(cantidad) * double.parse(productoModel.precioProducto.toString());
                        CartModel cartModel = CartModel();
                        cartModel.idProduct = productoModel.idProducto;
                        cartModel.amount = cantidad;
                        cartModel.descripcionProducto = productoModel.descripcionProducto;
                        /*  cartModel.nombreProducto = productoModel.nombreProducto;
                        cartModel.precioProducto = productoModel.precioProducto;
                        cartModel.regaloProducto = productoModel.regaloProducto;
                        cartModel.precioRegaloProducto = productoModel.precioRegaloProducto;
                        cartModel.fotoProducto = productoModel.fotoProducto; */
                        cartModel.subtotal = subtotalex.toString();
                        cartModel.status = productoModel.estadoProducto;

                        await cartDatabase.insertCart(cartModel);
                      }

                      showToast2('Producto agregado correctamente', Colors.green);
                      final carritoBloc = ProviderBloc.cart(context);
                      carritoBloc.getCart();
                      Navigator.pop(context);
                    },
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: colorPrimary,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          padding: EdgeInsets.all(5),
                          child: Icon(
                            Icons.shopping_cart,
                            color: Colors.white,
                            size: ScreenUtil().setHeight(30),
                          ),
                        ),
                        SizedBox(
                          width: ScreenUtil().setWidth(20),
                        ),
                        Expanded(
                          child: Text('Agregar al carrito'),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(5),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          padding: EdgeInsets.all(5),
                          child: Icon(
                            Icons.search,
                            color: Colors.white,
                            size: ScreenUtil().setHeight(30),
                          ),
                        ),
                        SizedBox(
                          width: ScreenUtil().setWidth(20),
                        ),
                        Expanded(
                          child: Text('Seguir buscando'),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(5),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          padding: EdgeInsets.all(5),
                          child: Icon(
                            Icons.shopping_bag,
                            color: Colors.white,
                            size: ScreenUtil().setHeight(30),
                          ),
                        ),
                        SizedBox(
                          width: ScreenUtil().setWidth(20),
                        ),
                        Expanded(
                          child: Text('Ir al carrito'),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _expandedContainer(String titulo, bool expanded, Widget contenido) {
    return Container(
      child: Stack(
        children: [
          (expanded)
              ? Container(
                  padding: EdgeInsets.only(
                    left: ScreenUtil().setWidth(24),
                    right: ScreenUtil().setWidth(24),
                    top: ScreenUtil().setHeight(50),
                    bottom: ScreenUtil().setHeight(8),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: const Offset(1, 0), // changes position of shadow
                      ),
                    ],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: contenido,
                )
              : Container(),
          InkWell(
            onTap: () {
              _controller.changeExpanded(!expanded);
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: ScreenUtil().setWidth(24),
                vertical: ScreenUtil().setHeight(8),
              ),
              decoration: BoxDecoration(
                color: colorPrimary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    titulo,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: ScreenUtil().setSp(14),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.white,
                    size: ScreenUtil().setHeight(20),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _contenido() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Compra:',
              style: TextStyle(
                fontSize: ScreenUtil().setSp(14),
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              'S/. 12 250.80',
              style: TextStyle(
                fontSize: ScreenUtil().setSp(14),
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'IGV:',
              style: TextStyle(
                fontSize: ScreenUtil().setSp(14),
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              'S/. 2 689.20',
              style: TextStyle(
                fontSize: ScreenUtil().setSp(14),
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        Divider(),
      ],
    );
  }
}

class Controller extends ChangeNotifier {
  bool expanded = true, expanded2 = false;
  int cantidad = 1;

  void changeExpanded(bool e) {
    expanded = e;
    notifyListeners();
  }

  void changeExpanded2(bool e) {
    expanded2 = e;
    notifyListeners();
  }

  void changeCantidad(int c) {
    if (cantidad > 0) {
      cantidad = cantidad + c;
    } else {
      cantidad = 1;
    }
    notifyListeners();
  }
}

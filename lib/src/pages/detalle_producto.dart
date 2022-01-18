import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:royal_prestige/src/utils/colors.dart';

class DetalleProducto extends StatefulWidget {
  const DetalleProducto({Key? key}) : super(key: key);

  @override
  State<DetalleProducto> createState() => _DetalleProductoState();
}

class _DetalleProductoState extends State<DetalleProducto> {
  final _controller = Controller();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
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
                      Text(
                        'SET DE 15 C4672',
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(24)),
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
                            'REGALO: SARTEN GOURMET DE 20CM + TAPA MEDIANA +4 CUCHILLOS DE CARNE + HACHA (S/. 3.870,00)',
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
                    'Set de juego de 15 piezas Sistema de cocna profesional El sistema de cocina mas completa que Royal Prestigue ofrece ideal para pérfeccionar tu coleccion y complacer los gustos mas variados',
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
                  child: _expandedContainer('Precio S/. 14 940.00', _controller.expanded, _contenido()),
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
                      Container(
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
                    ],
                  ),
                ),
              ],
            );
          }),
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

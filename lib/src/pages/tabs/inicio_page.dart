import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:royal_prestige/src/bloc/productos_bloc.dart';
import 'package:royal_prestige/src/bloc/provider_bloc.dart';
import 'package:royal_prestige/src/model/categoria_model.dart';
import 'package:royal_prestige/src/model/producto_model.dart';
import 'package:royal_prestige/src/pages/busqueda_de_producto.dart';
import 'package:royal_prestige/src/pages/detalle_producto.dart';
import 'package:royal_prestige/src/utils/colors.dart';
import 'package:royal_prestige/src/utils/constants.dart';
import 'package:royal_prestige/src/widget/show_loading.dart';
import 'dart:math' as math;

class InicioPage extends StatefulWidget {
  const InicioPage({Key? key}) : super(key: key);

  @override
  State<InicioPage> createState() => _InicioPageState();
}

class _InicioPageState extends State<InicioPage> {
  final _controller = Controller();
  @override
  Widget build(BuildContext context) {
    final categoriasBloc = ProviderBloc.productos(context);
    categoriasBloc.obtenerCategorias();
    return Scaffold(
      body: Column(
        children: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) {
                    return BusquedaProducto();
                  },
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    var begin = Offset(0.0, 1.0);
                    var end = Offset.zero;
                    var curve = Curves.ease;

                    var tween = Tween(begin: begin, end: end).chain(
                      CurveTween(curve: curve),
                    );

                    return SlideTransition(
                      position: animation.drive(tween),
                      child: child,
                    );
                  },
                ),
              );
            },
            child: Container(
              height: ScreenUtil().setHeight(60),
              margin: EdgeInsets.only(
                top: ScreenUtil().setHeight(10),
                left: ScreenUtil().setWidth(21),
                right: ScreenUtil().setWidth(21),
              ),
              decoration: BoxDecoration(
                border: Border.all(color: colorPrimary),
                borderRadius: BorderRadius.circular(20),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: ScreenUtil().setWidth(30),
                vertical: ScreenUtil().setHeight(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Buscar...',
                    style: TextStyle(
                      color: colorOffText,
                      fontWeight: FontWeight.w300,
                      fontSize: ScreenUtil().setSp(15),
                    ),
                  ),
                  Icon(
                    Icons.search,
                    color: colorPrimary,
                    size: ScreenUtil().setHeight(20),
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: ScreenUtil().setHeight(24),
          ),
          StreamBuilder(
              stream: categoriasBloc.categoriaStream,
              builder: (context, AsyncSnapshot<List<CategoriaModel>> snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!.length > 0) {
                    var categorias = snapshot.data!;
                    categoriasBloc.obtenerProductosByIdCategoria(categorias[0].idCategoria.toString());
                    return Container(
                      height: ScreenUtil().setHeight(60),
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: categorias.length,
                        itemBuilder: (_, index) {
                          return itemChoice(
                            categorias[index],
                            index,
                            categoriasBloc,
                          );
                        },
                      ),
                    );
                  } else {
                    return Center(
                      child: Text('Sin categorías'),
                    );
                  }
                } else {
                  return ShowLoadding(
                    active: true,
                    h: ScreenUtil().setHeight(100),
                    w: ScreenUtil().setWidth(100),
                    fondo: Colors.transparent,
                    colorText: Colors.black,
                  );
                }
              }),
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(
                horizontal: ScreenUtil().setWidth(21),
              ),
              child: StreamBuilder(
                stream: categoriasBloc.productosStream,
                builder: (context, AsyncSnapshot<List<ProductoModel>> snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.length > 0) {
                      var producto = snapshot.data!;
                      return ListView.builder(
                        itemCount: producto.length,
                        itemBuilder: (_, index) {
                          var valorHero = math.Random().nextDouble() * index;
                          return itemProduct(producto[index], valorHero);
                        },
                      );
                    } else {
                      return Center(
                        child: Text('Sin productos para esta categoría'),
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
            ),
          ),
        ],
      ),
    );
  }

  Widget itemChoice(CategoriaModel categoria, int index, ProductosBloc bloc) {
    return AnimatedBuilder(
        animation: _controller,
        builder: (_, s) {
          return InkWell(
            onTap: () {
              bloc.obtenerProductosByIdCategoria(categoria.idCategoria.toString());
              _controller.changeIndex(index);
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: colorPrimary),
                borderRadius: BorderRadius.circular(10),
                color: (_controller.index == index) ? colorPrimary : Colors.transparent,
              ),
              margin: EdgeInsets.symmetric(
                horizontal: ScreenUtil().setWidth(8),
                vertical: ScreenUtil().setHeight(12),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: ScreenUtil().setWidth(8),
                vertical: ScreenUtil().setHeight(10),
              ),
              child: Text(
                '${categoria.nombreCategoria}',
                style: TextStyle(
                  color: (_controller.index == index) ? Colors.white : Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: ScreenUtil().setSp(11),
                ),
              ),
            ),
          );
        });
  }

  Widget itemProduct(ProductoModel producto, var valorHero) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) {
              return DetalleProducto(
                idProducto: producto.idProducto.toString(),
              );
            },
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              var begin = Offset(0.0, 1.0);
              var end = Offset.zero;
              var curve = Curves.ease;

              var tween = Tween(begin: begin, end: end).chain(
                CurveTween(curve: curve),
              );

              return SlideTransition(
                position: animation.drive(tween),
                child: child,
              );
            },
          ),
        );
      },
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: ScreenUtil().setHeight(10),
          horizontal: ScreenUtil().setWidth(4),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: ScreenUtil().setWidth(16),
            vertical: ScreenUtil().setHeight(16),
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(1, 0), // changes position of shadow
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: ScreenUtil().setHeight(125),
                child: (producto.galery!.length > 0)
                    ? CarouselSlider.builder(
                        itemCount: producto.galery!.length,
                        itemBuilder: (context, x, y) {
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (context, animation, secondaryAnimation) {
                                    return DetalleProducto(
                                      idProducto: producto.idProducto.toString(),
                                    );
                                  },
                                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                    var begin = Offset(0.0, 1.0);
                                    var end = Offset.zero;
                                    var curve = Curves.ease;

                                    var tween = Tween(begin: begin, end: end).chain(
                                      CurveTween(curve: curve),
                                    );

                                    return SlideTransition(
                                      position: animation.drive(tween),
                                      child: child,
                                    );
                                  },
                                ),
                              );
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                horizontal: ScreenUtil().setWidth(0),
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: Stack(
                                  children: [
                                    CachedNetworkImage(
                                      placeholder: (context, url) =>
                                          Container(width: double.infinity, height: double.infinity, child: CupertinoActivityIndicator()),
                                      errorWidget: (context, url, error) => Container(
                                        width: double.infinity,
                                        height: double.infinity,
                                        child: Center(
                                          child: Icon(Icons.error),
                                        ),
                                      ),
                                      imageUrl: '$apiBaseURL/${producto.galery![x].file}',
                                      imageBuilder: (context, imageProvider) => Container(
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        options: CarouselOptions(
                            height: ScreenUtil().setHeight(552),
                            onPageChanged: (index, page) {},
                            enlargeCenterPage: true,
                            autoPlay: true,
                            autoPlayCurve: Curves.fastOutSlowIn,
                            autoPlayInterval: Duration(seconds: 6),
                            autoPlayAnimationDuration: Duration(milliseconds: 2000),
                            viewportFraction: 1),
                      )
                    : Container(
                        width: double.infinity,
                        height: double.infinity,
                        child: Center(
                          child: Icon(Icons.error),
                        ),
                      ),
                 
              ),
              SizedBox(
                height: ScreenUtil().setHeight(10),
              ),
              Text(
                '${producto.nombreProducto}',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: ScreenUtil().setSp(15),
                ),
              ),
              Text(
                '${producto.regaloProducto}',
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: ScreenUtil().setSp(11),
                ),
              ),
              SizedBox(
                height: ScreenUtil().setHeight(5),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: colorPrimary,
                    ),
                    padding: EdgeInsets.all(8),
                    child: Text(
                      'S/ ${producto.precioProducto}',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: ScreenUtil().setSp(11),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class Controller extends ChangeNotifier {
  int index = 0;

  void changeIndex(int i) {
    index = i;
    notifyListeners();
  }
}

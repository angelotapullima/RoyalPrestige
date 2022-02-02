import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_options.dart';
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
import 'package:royal_prestige/src/utils/responsive.dart';
import 'package:royal_prestige/src/utils/sliver_header_delegate.dart';
import 'package:royal_prestige/src/widget/show_loading.dart';
import 'dart:math' as math;

class PruebaInicio extends StatelessWidget {
  const PruebaInicio({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _controller = Controller();
    final categoriasBloc = ProviderBloc.productos(context);
    categoriasBloc.obtenerCategorias();

    final responsive = Responsive.of(context);
    return Scaffold(
      body: StreamBuilder(
        stream: categoriasBloc.categoriaStream,
        builder: (context, AsyncSnapshot<List<CategoriaModel>> cats) {
          if (cats.hasData) {
            if (cats.data!.length > 0) {
              categoriasBloc.obtenerProductosByIdCategoria(cats.data![0].idCategoria.toString());
              return CustomScrollView(
                slivers: [
                  CustomHeaderPrincipal(),
                  SliverToBoxAdapter(
                    child: Container(
                        height: ScreenUtil().setHeight(150),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            //horizontal: ScreenUtil().setWidth(10),
                            vertical: ScreenUtil().setHeight(10),
                          ),
                          height: ScreenUtil().setHeight(150),
                          child: CarouselSlider.builder(
                            itemCount: 4,
                            itemBuilder: (context, x, y) {
                              return InkWell(
                                onTap: () {
                                  
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: Stack(
                                      children: [
                                        CachedNetworkImage(
                                          placeholder: (context, url) => Container(
                                            width: double.infinity,
                                            height: double.infinity,
                                            child: CupertinoActivityIndicator(),
                                          ),
                                          errorWidget: (context, url, error) => Container(
                                            width: double.infinity,
                                            height: double.infinity,
                                            child: Center(
                                              child: Icon(Icons.error),
                                            ),
                                          ),
                                          imageUrl: 'https://cdn2.hubspot.net/hubfs/3815039/Imagen_Blog_BIT_1600x478px_240119.jpg',
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
                                viewportFraction: .8),
                          ),
                        )),
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                      height: ScreenUtil().setHeight(60),
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: cats.data!.length,
                        itemBuilder: (_, index) {
                          return itemChoice(cats.data![index], index, categoriasBloc, _controller);
                        },
                      ),
                    ),
                  ),
                  StreamBuilder(
                    stream: categoriasBloc.productosStream,
                    builder: (context, AsyncSnapshot<List<ProductoModel>> snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data!.length > 0) {
                          return SliverPadding(
                            padding: EdgeInsets.only(
                              left: 0,
                              right: 0,
                            ),
                            sliver: SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (BuildContext context, int index) {
                                  return GridView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: ScreenUtil().setWidth(5),
                                    ),
                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                      childAspectRatio: .75,
                                      crossAxisCount: 2,
                                      mainAxisSpacing: responsive.hp(2),
                                      crossAxisSpacing: responsive.wp(3),
                                    ),
                                    itemCount: snapshot.data!.length,
                                    itemBuilder: (context, i) {
                                      var valorHero = math.Random().nextDouble() * i;
                                      return LayoutBuilder(builder: (context, constrain) {
                                        return itemProduct(context, snapshot.data![i], valorHero, constrain.maxHeight);
                                      });
                                    },
                                  );
                                },
                                childCount: 1,
                              ),
                            ),
                          );
                        } else {
                          return SliverToBoxAdapter(
                            child: Container(
                              height: ScreenUtil().setHeight(60),
                              child: Text('No existen productos'),
                            ),
                          );
                        }
                      } else {
                        return SliverToBoxAdapter(
                          child: Container(
                            height: ScreenUtil().setHeight(60),
                            child: CupertinoActivityIndicator(),
                          ),
                        );
                      }
                    },
                  )
                ],
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
    );
  }

  Widget itemChoice(CategoriaModel categoria, int index, ProductosBloc bloc, Controller _controller) {
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

  Widget itemProduct(BuildContext context, ProductoModel producto, var valorHero, double height) {
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
      child: Stack(
        children: [
          Container(
            height: height,
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
                  height: height * .55,
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
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: Stack(
                                    children: [
                                      CachedNetworkImage(
                                        placeholder: (context, url) => Container(
                                          width: double.infinity,
                                          height: double.infinity,
                                          child: CupertinoActivityIndicator(),
                                        ),
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
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: ScreenUtil().setSp(15),
                  ),
                ),
                Text(
                  '${producto.regaloProducto}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: ScreenUtil().setSp(11),
                  ),
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(5),
                ),
              ],
            ),
          ),
          Positioned(
              top: ScreenUtil().setWidth(5),
              right: 0,
              child: Row(
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
              ))
        ],
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

class CustomHeaderPrincipal extends StatefulWidget {
  const CustomHeaderPrincipal({
    Key? key,
  }) : super(key: key);

  @override
  _CustomHeaderPrincipalState createState() => _CustomHeaderPrincipalState();
}

class _CustomHeaderPrincipalState extends State<CustomHeaderPrincipal> {
  //String saldoActual, comisionActual;

  TextEditingController inputfieldDateController = new TextEditingController();

  Widget getAlias(String nombre, Responsive responsive) {
    final List<String> tmp = nombre.split(" ");

    String alias = "";
    if (tmp.length > 0) {
      alias = tmp[0][0];
      if (tmp.length == 2) {
        alias += tmp[1][0];
      }
    }

    return Center(
      child: Text(
        alias,
        style: TextStyle(
          fontSize: responsive.ip(7),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    inputfieldDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    final carritoBloc = ProviderBloc.cart(context);
    carritoBloc.getCart();

    //canchasBloc.obtenerSaldo();
    return SliverPersistentHeader(
      floating: true,
      delegate: SliverCustomHeaderDelegate(
        maxHeight: responsive.ip(14) + kToolbarHeight,
        minHeight: responsive.ip(14) + kToolbarHeight,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
          ),
          // color: Colors.red,
          child: SafeArea(
            bottom: false,
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 23,
                  ),
                  height: responsive.hp(8),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          /*  final bottomBloc = ProviderBloc.bottom(context);

                                    bottomBloc.changePage(4); */
                        },
                        child: CircleAvatar(
                          radius: responsive.ip(2),
                          child: ClipOval(
                            child: Image.network(
                              'prefs.foto',
                              width: responsive.ip(4),
                              height: responsive.ip(4),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: responsive.wp(2),
                      ),
                      Text(
                        'alias',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: responsive.ip(2.4),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Spacer(),
                      StreamBuilder(
                        stream: carritoBloc.cartStream,
                        builder: (BuildContext context, AsyncSnapshot<List<ProductoModel>> snapshot) {
                          int cantidad = 0;

                          if (snapshot.hasData) {
                            if (snapshot.data!.length > 0) {
                              for (int i = 0; i < snapshot.data!.length; i++) {
                                cantidad++;
                              }
                            } else {
                              cantidad = 0;
                            }
                          } else {
                            cantidad = 0;
                          }
                          return InkWell(
                            onTap: () {
                              /* final bottomBloc = ProviderBloc.bottom(context);

                                bottomBloc.changePage(3); */
                            },
                            child: Stack(
                              children: [
                                (cantidad != 0)
                                    ? Stack(
                                        children: <Widget>[
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Color(0x30F3EFE8),
                                              borderRadius: BorderRadius.circular(5),
                                            ),
                                            padding: EdgeInsets.symmetric(
                                              horizontal: responsive.wp(2),
                                              vertical: responsive.hp(.5),
                                            ),
                                            child: Icon(
                                              Icons.shopping_bag_sharp,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Positioned(
                                            top: 0,
                                            right: 0,
                                            child: Container(
                                              child: Text(
                                                cantidad.toString(),
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: responsive.ip(1),
                                                ),
                                              ),
                                              alignment: Alignment.center,
                                              width: responsive.ip(1.6),
                                              height: responsive.ip(1.6),
                                              decoration: BoxDecoration(color: Colors.green, shape: BoxShape.circle),
                                            ),
                                            //child: Icon(Icons.brightness_1, size: 8,color: Colors.redAccent,  )
                                          )
                                        ],
                                      )
                                    : Container(
                                        decoration: BoxDecoration(
                                          color: Color(0x30F3EFE8),
                                          borderRadius: BorderRadius.circular(5),
                                        ),
                                        padding: EdgeInsets.symmetric(
                                          horizontal: responsive.wp(2),
                                          vertical: responsive.hp(.5),
                                        ),
                                        child: Icon(
                                          Icons.shopping_bag_sharp,
                                          color: Colors.white,
                                        ),
                                      )
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(
                    left: responsive.wp(6),
                    right: responsive.wp(10),
                  ),
                  child: Row(
                    children: [
                      Text(
                        '" Siempre firmes "',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: responsive.ip(2.1),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: responsive.hp(1),
                ),
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
                    margin: EdgeInsets.symmetric(
                      horizontal: responsive.wp(6),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    height: responsive.hp(4),
                    width: double.infinity,
                    child: Row(
                      children: [
                        SizedBox(
                          width: responsive.wp(3),
                        ),
                        Icon(
                          Icons.search,
                          color: Colors.grey,
                        ),
                        Expanded(
                          child: Text(
                            '¿Qué está buscando?',
                            style: TextStyle(color: Colors.grey),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

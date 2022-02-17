import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:royal_prestige/src/bloc/data_user.dart';
import 'package:royal_prestige/src/bloc/productos_bloc.dart';
import 'package:royal_prestige/src/bloc/provider_bloc.dart';
import 'package:royal_prestige/src/model/alert_model.dart';
import 'package:royal_prestige/src/model/categoria_model.dart';
import 'package:royal_prestige/src/model/producto_model.dart';
import 'package:royal_prestige/src/model/promocion_model.dart';
import 'package:royal_prestige/src/pages/Alertas/detail_alerta.dart';
import 'package:royal_prestige/src/pages/busqueda_de_producto.dart';
import 'package:royal_prestige/src/pages/detail_promocion_vista.dart';
import 'package:royal_prestige/src/pages/detalle_producto.dart';
import 'package:royal_prestige/src/pages/info_user.dart';
import 'package:royal_prestige/src/pages/promo_categoria_page.dart';
import 'package:royal_prestige/src/utils/colors.dart';
import 'package:royal_prestige/src/utils/constants.dart';
import 'package:royal_prestige/src/utils/responsive.dart';
import 'package:royal_prestige/src/utils/sliver_header_delegate.dart';
import 'package:royal_prestige/src/widget/carrito.dart';
import 'package:royal_prestige/src/widget/show_loading.dart';
import 'dart:math' as math;

class PruebaInicio extends StatelessWidget {
  const PruebaInicio({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _controller = Controller();
    final categoriasBloc = ProviderBloc.productos(context);
    categoriasBloc.obtenerCategorias();
    final promoBloc = ProviderBloc.promocion(context);
    promoBloc.obtenerPromos();

    final dataBloc = ProviderBloc.data(context);

    final alertasBloc = ProviderBloc.alert(context);
    alertasBloc.getAlertsForDay();
    final responsive = Responsive.of(context);

    final provider = Provider.of<PrincipalChangeBloc>(context, listen: false);

    return Scaffold(
      body: StreamBuilder(
          stream: alertasBloc.alertsDayStream,
          builder: (context, AsyncSnapshot<List<AlertModel>> snapshot) {
            if (snapshot.hasData) {
              provider.setIndex(true);
              return Stack(
                children: [
                  StreamBuilder(
                    stream: dataBloc.userStream,
                    builder: (context, AsyncSnapshot<UserModel> user) {
                      if (user.hasData) {
                        return StreamBuilder(
                          stream: categoriasBloc.categoriaStream,
                          builder: (context, AsyncSnapshot<List<CategoriaModel>> cats) {
                            if (cats.hasData) {
                              if (cats.data!.length > 0) {
                                categoriasBloc.obtenerProductosByIdCategoria(cats.data![0].idCategoria.toString());
                                return CustomScrollView(
                                  slivers: [
                                    CustomHeaderPrincipal(user: user.data!),
                                    StreamBuilder(
                                        stream: promoBloc.promocionStream,
                                        builder: (context, AsyncSnapshot<List<PromocionModel>> promo) {
                                          if (promo.hasData) {
                                            if (promo.data!.length > 0) {
                                              var promos = promo.data!;
                                              return SliverToBoxAdapter(
                                                child: Container(
                                                    height: ScreenUtil().setHeight(150),
                                                    child: Container(
                                                      padding: EdgeInsets.symmetric(
                                                        vertical: ScreenUtil().setHeight(10),
                                                      ),
                                                      height: ScreenUtil().setHeight(150),
                                                      child: CarouselSlider.builder(
                                                        itemCount: promos.length,
                                                        itemBuilder: (context, x, y) {
                                                          return InkWell(
                                                            onTap: () {
                                                              _onTapPromo(context, promos[x]);
                                                            },
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
                                                                    imageUrl: '$apiBaseURL/${promos[x].imagenPromo}',
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
                                              );
                                            } else {
                                              return SliverToBoxAdapter(
                                                child: Container(
                                                  height: ScreenUtil().setHeight(60),
                                                  child: Center(child: Text('No existen promociones')),
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
                                        }),
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
                                                        childAspectRatio: .7,
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
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),
                  ValueListenableBuilder(
                      valueListenable: provider.cargando,
                      builder: (BuildContext context, bool data, Widget? child) {
                        return (data)
                            ? Container(
                                color: Colors.black.withOpacity(.4),
                                padding: EdgeInsets.symmetric(
                                  horizontal: responsive.wp(5),
                                  vertical: responsive.hp(7),
                                ),
                                height: double.infinity,
                                width: double.infinity,
                                child: Stack(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: responsive.wp(5),
                                        vertical: responsive.hp(7),
                                      ),
                                      height: double.infinity,
                                      width: double.infinity,
                                      child: StreamBuilder(
                                        stream: alertasBloc.alertsDayStream,
                                        builder: (context, AsyncSnapshot<List<AlertModel>> alerts) {
                                          if (alerts.hasData) {
                                            if (alerts.data!.length > 0) {
                                              return Container(
                                                child: ListView.builder(
                                                  padding: EdgeInsets.only(
                                                    bottom: responsive.hp(3),
                                                  ),
                                                  shrinkWrap: true,
                                                  physics: ClampingScrollPhysics(),
                                                  itemCount: 2,
                                                  itemBuilder: (context, x) {
                                                    if (x == 0) {
                                                      return Padding(
                                                        padding: EdgeInsets.symmetric(
                                                          horizontal: responsive.wp(3),
                                                          vertical: responsive.hp(2),
                                                        ),
                                                        child: Text(
                                                          'Pendientes para el dia de hoy ${alerts.data![x].alertDate}',
                                                          style: GoogleFonts.poppins(
                                                            fontSize: ScreenUtil().setSp(16),
                                                            color: Colors.black,
                                                            fontWeight: FontWeight.w400,
                                                            letterSpacing: ScreenUtil().setSp(0.016),
                                                          ),
                                                        ),
                                                      );
                                                    }

                                                    return Container(
                                                      child: ListView.builder(
                                                        padding: EdgeInsets.all(0),
                                                        shrinkWrap: true,
                                                        physics: ClampingScrollPhysics(),
                                                        itemCount: alerts.data!.length,
                                                        itemBuilder: (context, i) {
                                                          return _itemAlerta(context, alerts.data![i], responsive);
                                                        },
                                                      ),
                                                    );
                                                    //return _cardCanchas(responsive, canchasDeporte[i], negocio);
                                                  },
                                                ),
                                              );
                                            } else {
                                              return Column(
                                                children: [
                                                  Container(
                                                    height: responsive.hp(30),
                                                    child: Lottie.asset('assets/Json/lion.json'),
                                                  ),
                                                  Text(
                                                    'No tiene pendientes hoy',
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: ScreenUtil().setSp(18),
                                                    ),
                                                  )
                                                ],
                                              );
                                            }
                                          } else {
                                            return Column(
                                              children: [
                                                Container(
                                                  height: responsive.hp(30),
                                                  child: Lottie.asset('assets/Json/lion.json'),
                                                ),
                                                Text(
                                                  'No tiene pendientes hoy',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: ScreenUtil().setSp(18),
                                                  ),
                                                )
                                              ],
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                    Positioned(
                                      right: 0,
                                      top: 0,
                                      child: GestureDetector(
                                        onTap: () {
                                          provider.setIndex(false);
                                        },
                                        child: Container(
                                          transform: Matrix4.translationValues(responsive.ip(1), -responsive.ip(1.3), 0),
                                          child: CircleAvatar(
                                            radius: responsive.ip(2),
                                            child: Icon(Icons.close),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Container();
                      })
                ],
              );
            } else {
              return Container();
            }
          }),
    );
  }

  Widget _itemAlerta(BuildContext context, AlertModel alerta, Responsive responsive) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) {
              return DetalleAlerta(
                idAlert: alerta.idAlert,
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
        padding: EdgeInsets.symmetric(
          horizontal: responsive.wp(2),
        ),
        margin: EdgeInsets.only(
          right: responsive.wp(2),
          bottom: responsive.hp(.5),
          top: responsive.hp(.5),
        ),
        decoration: BoxDecoration(
          color: Colors.blueGrey.shade100.withOpacity(.2),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${alerta.nombreCLiente}  ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              children: [
                Text(
                  'Telefono: ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text('${alerta.telefonoCliente}'),
                Spacer(),
                Text(
                  'Hora: ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text('${alerta.alertHour}'),
              ],
            ),
            Text(
              '${alerta.alertTitle}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text('${alerta.alertDetail}'),
            Text(''),
          ],
        ),
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

  _onTapPromo(BuildContext context, PromocionModel promo) {
    if (promo.promoTipo == '1') {
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return DetalleProducto(
              idProducto: promo.idProduct.toString(),
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
    } else if (promo.promoTipo == '2') {
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return PromoCategoriaPage(
              promoCategoria: promo,
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
    } else {
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return DetailPromoVista(
              foto: promo.imagenPromo.toString(),
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
      //DetailPromoVista
    }
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
                      ? (producto.galery!.length != 1)
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
                                      imageUrl: '$apiBaseURL/${producto.galery![0].file}',
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
  final UserModel user;
  const CustomHeaderPrincipal({
    Key? key,
    required this.user,
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
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (context, animation, secondaryAnimation) {
                                return InfoUser(
                                  user: widget.user,
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
                        child: CircleAvatar(
                          radius: responsive.ip(2),
                          child: ClipOval(
                            child: Image.network(
                              '${widget.user.userImage}',
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
                        '${widget.user.personName}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: responsive.ip(2.4),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Spacer(),
                      CarritoWidget(color: Colors.white),
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
                        '" Caminando firme "',
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

class PrincipalChangeBloc extends ChangeNotifier {
  ValueNotifier<bool> _cargando = ValueNotifier(false);
  ValueNotifier<bool> get cargando => this._cargando;

  void setIndex(bool value) => this._cargando.value = value;
}

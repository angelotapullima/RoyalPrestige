import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:royal_prestige/src/bloc/provider_bloc.dart';
import 'package:royal_prestige/src/model/categoria_model.dart';
import 'package:royal_prestige/src/model/producto_model.dart';
import 'package:royal_prestige/src/model/promocion_model.dart';
import 'package:royal_prestige/src/pages/detalle_producto.dart';
import 'package:royal_prestige/src/utils/colors.dart';
import 'package:royal_prestige/src/utils/constants.dart';
import 'package:royal_prestige/src/utils/responsive.dart';
import 'package:royal_prestige/src/widget/show_loading.dart';
import 'dart:math' as math;

class PromoCategoriaPage extends StatefulWidget {
  const PromoCategoriaPage({Key? key, required this.promoCategoria}) : super(key: key);
  final PromocionModel promoCategoria;

  @override
  State<PromoCategoriaPage> createState() => _PromoCategoriaPageState();
}

class _PromoCategoriaPageState extends State<PromoCategoriaPage> {
  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    final categoriaBloc = ProviderBloc.productos(context);
    categoriaBloc.obtenerCategoriasById(widget.promoCategoria.idCategoria.toString());
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder(
            stream: categoriaBloc.categoriaIdStream,
            builder: (context, AsyncSnapshot<List<CategoriaModel>> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.length > 0) {
                  categoriaBloc.obtenerProductosByIdCategoria(snapshot.data![0].idCategoria.toString());
                  return Column(
                    children: [
                      Container(
                        height: ScreenUtil().setHeight(60),
                        padding: EdgeInsets.symmetric(
                          horizontal: ScreenUtil().setWidth(10),
                          vertical: ScreenUtil().setHeight(5),
                        ),
                        child: Row(
                          children: [
                            BackButton(),
                            Text(
                              '${snapshot.data![0].nombreCategoria}',
                              style: TextStyle(
                                fontSize: ScreenUtil().setSp(24),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: StreamBuilder(
                          stream: categoriaBloc.productosStream,
                          builder: (context, AsyncSnapshot<List<ProductoModel>> snapshot) {
                            if (snapshot.hasData) {
                              if (snapshot.data!.length > 0) {
                                return GridView.builder(
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
                              } else {
                                return Container(
                                  height: ScreenUtil().setHeight(60),
                                  child: Text('No existen productos'),
                                );
                              }
                            } else {
                              return Container(
                                height: ScreenUtil().setHeight(60),
                                child: CupertinoActivityIndicator(),
                              );
                            }
                          },
                        ),
                      )
                    ],
                  );
                } else {
                  return Center(
                    child: Text('No se encontró promoción para la categoría'),
                  );
                }
              } else {
                return ShowLoadding(
                  active: true,
                  colorText: Colors.black,
                  fondo: Colors.transparent,
                  w: double.infinity,
                  h: double.infinity,
                );
              }
            }),
      ),
    );
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

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:royal_prestige/database/cart_database.dart';
import 'package:royal_prestige/src/bloc/provider_bloc.dart';
import 'package:royal_prestige/src/model/producto_model.dart';
import 'package:royal_prestige/src/pages/calculadora_page.dart';
import 'package:royal_prestige/src/utils/colors.dart';

class CarritoTab extends StatelessWidget {
  const CarritoTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final carritoBloc = ProviderBloc.cart(context);
    carritoBloc.getCart();

    return Scaffold(
      body: Column(
        children: [
          Container(
            height: ScreenUtil().setHeight(60),
            padding: EdgeInsets.symmetric(
              horizontal: ScreenUtil().setWidth(10),
              vertical: ScreenUtil().setHeight(5),
            ),
            child: Row(
              children: [
                Text(
                  'Carrito',
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(24),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Spacer(),
                /*  InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (context, animation, secondaryAnimation) {
                              return AddAlertas();
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
                          color: Colors.blue[600],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(10), vertical: ScreenUtil().setHeight(5)),
                        child: Text(
                          'Agregar',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                   */
              ],
            ),
          ),
          StreamBuilder(
            stream: carritoBloc.cartStream,
            builder: (BuildContext context, AsyncSnapshot<List<ProductoModel>> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.length > 0) {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data!.length + 1,
                      itemBuilder: (context, index) {
                        if (index == snapshot.data!.length) {
                          var montex = 0.0;
                          for (var i = 0; i < snapshot.data!.length; i++) {
                            montex = (montex + double.parse('${snapshot.data![i].subtotal}'));
                          }
                          return Column(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: ScreenUtil().setWidth(16),
                                  vertical: ScreenUtil().setHeight(5),
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      'Total',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: ScreenUtil().setSp(18),
                                      ),
                                    ),
                                    Spacer(),
                                    Text(
                                      'S/.$montex',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: ScreenUtil().setSp(18),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: ScreenUtil().setHeight(10),
                              ),
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(
                                  horizontal: ScreenUtil().setWidth(10),
                                ),
                                child: MaterialButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                        pageBuilder: (context, animation, secondaryAnimation) {
                                          return CalculaDoraPage(monto: montex);
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
                                  child: Text(
                                    'Calcular',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  color: colorPrimary,
                                ),
                              ),
                            ],
                          );
                        }
                        return Column(
                          children: [
                            Slidable(
                              key: ValueKey(index),
                              startActionPane: ActionPane(
                                // A motion is a widget used to control how the pane animates.
                                motion: const ScrollMotion(),

                                // A pane can dismiss the Slidable.
                                dismissible: DismissiblePane(
                                  onDismissed: () async {
                                    final cartDatabase = CartDatabase();
                                    await cartDatabase.deleteCartForId(
                                      '${snapshot.data![index].idProducto}',
                                    );
                                    final carritoBloc = ProviderBloc.cart(context);
                                    carritoBloc.getCart();
                                  },
                                ),

                                // All actions are defined in the children parameter.
                                children: const [
                                  // A SlidableAction can have an icon and/or a label.
                                  SlidableAction(
                                    onPressed: doNothing,
                                    backgroundColor: Color(0xFFFE4A49),
                                    foregroundColor: Colors.white,
                                    icon: Icons.delete,
                                    label: 'Delete',
                                  ),
                                ],
                              ),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: ScreenUtil().setWidth(8),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: ScreenUtil().setWidth(80),
                                      height: ScreenUtil().setHeight(80),
                                      child: ClipRRect(
                                          borderRadius: BorderRadius.circular(10.0),
                                          child: CachedNetworkImage(
                                            progressIndicatorBuilder: (_, url, downloadProgress) {
                                              return Container(
                                                width: double.infinity,
                                                height: double.infinity,
                                                child: Stack(
                                                  children: [
                                                    Center(
                                                      child: CircularProgressIndicator(
                                                        value: downloadProgress.progress,
                                                        backgroundColor: Colors.green,
                                                        valueColor: new AlwaysStoppedAnimation<Color>(Colors.red),
                                                      ),
                                                    ),
                                                    Center(
                                                      child: (downloadProgress.progress != null)
                                                          ? Text(
                                                              '${(downloadProgress.progress! * 100).toInt().toString()}%',
                                                            )
                                                          : Container(),
                                                    )
                                                  ],
                                                ),
                                              );
                                            },
                                            errorWidget: (context, url, error) => Icon(Icons.error),
                                            imageUrl: '${snapshot.data![index].fotoProducto}',
                                            imageBuilder: (context, imageProvider) => Container(
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  image: imageProvider,
                                                  fit: BoxFit.fill,
                                                ),
                                              ),
                                            ),
                                          )),
                                    ),
                                    SizedBox(
                                      width: ScreenUtil().setWidth(10),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  '${snapshot.data![index].nombreProducto}',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: ScreenUtil().setWidth(5),
                                                  vertical: ScreenUtil().setHeight(2),
                                                ),
                                                decoration: BoxDecoration(
                                                  color: Colors.red,
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
                                                child: Text(
                                                  'S/. ${snapshot.data![index].subtotal}',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Text('${snapshot.data![index].descripcionProducto}'),
                                          Row(
                                            children: [
                                              Text(
                                                '${snapshot.data![index].cantidad}  ',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text('x'),
                                              Text(
                                                '  ${snapshot.data![index].precioProducto}',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Divider()
                          ],
                        );
                      },
                    ),
                  );
                } else {
                  return Center(
                    child: Text('No hay productos en el carrito'),
                  );
                }
              } else {
                return CupertinoActivityIndicator();
              }
            },
          ),
        ],
      ),
    );
  }
}

void doNothing(BuildContext context) {}

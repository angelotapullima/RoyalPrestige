
import 'package:flutter/material.dart';
import 'package:royal_prestige/src/bloc/provider_bloc.dart';
import 'package:royal_prestige/src/model/producto_model.dart';
import 'package:royal_prestige/src/pages/carrito_tab.dart';
import 'package:royal_prestige/src/utils/responsive.dart';

class CarritoWidget extends StatelessWidget {
  const CarritoWidget({
    Key? key,required this.color,
   
  }) : super(key: key);

  final Color color;
 

  @override
  Widget build(BuildContext context) {

    final responsive=Responsive.of(context); final carritoBloc = ProviderBloc.cart(context);
    carritoBloc.getCart();
    return StreamBuilder(
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
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) {
                  return CarritoTab();
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
                            color: color,
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
                        color: color,
                      ),
                    )
            ],
          ),
        );
      },
    );
  }
}

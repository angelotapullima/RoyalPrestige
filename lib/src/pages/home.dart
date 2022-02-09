import 'package:flutter/material.dart';
import 'package:royal_prestige/src/bloc/inicio_bloc.dart';
import 'package:royal_prestige/src/bloc/provider_bloc.dart';
import 'package:royal_prestige/src/pages/tabs/agenda_page.dart';
import 'package:royal_prestige/src/pages/tabs/inicio_page.dart';
import 'package:royal_prestige/src/pages/tabs/calcular_page.dart';
import 'package:royal_prestige/src/pages/tabs/cliente_y_prospectos_page.dart';
import 'package:royal_prestige/src/pages/tabs/prueba_inicio.dart';
import 'package:royal_prestige/src/utils/responsive.dart';

import 'tabs/documentosPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Widget> pageList = [];

  @override
  void initState() {
    pageList.add(const PruebaInicio());
    pageList.add(const DocumentosPage());
    pageList.add(const ClientesyProspectosPage());
    pageList.add(const AgendaPage());
    pageList.add(const CalcularPage());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bottomBloc = ProviderBloc.botton(context);

    final responsive = Responsive.of(context);

    final carritoBloc = ProviderBloc.cart(context);
    carritoBloc.getCart();

    bottomBloc.changePage(4);
    final dataBloc = ProviderBloc.data(context);
    dataBloc.obtenerUser();
    return Scaffold(
      body: StreamBuilder(
        stream: bottomBloc.selectPageStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return Stack(
            children: [
              Container(
                padding: EdgeInsets.only(
                  bottom: kBottomNavigationBarHeight * responsive.hp(.21),
                ),
                child: IndexedStack(
                  index: snapshot.data,
                  children: pageList,
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: kBottomNavigationBarHeight * responsive.hp(.21),
                  padding: EdgeInsets.only(
                    bottom: responsive.hp(2),
                    left: responsive.wp(2),
                    right: responsive.wp(2),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadiusDirectional.only(
                      topStart: Radius.circular(20),
                      topEnd: Radius.circular(20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: StreamBuilder(
                    stream: bottomBloc.selectPageStream,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      return Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: responsive.wp(2),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                bottomBloc.changePage(0);
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: responsive.hp(1),
                                  ),
                                  Icon(
                                    Icons.home,
                                    size: responsive.ip(3),
                                    color: (bottomBloc.page == 0) ? Colors.red : Colors.grey,
                                  ),
                                  Text(
                                    'Inicio\n',
                                    style: TextStyle(
                                      fontSize: responsive.ip(1.5),
                                      color: (bottomBloc.page == 0) ? Colors.red : Colors.grey,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                bottomBloc.changePage(1);
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: responsive.hp(1),
                                  ),
                                  Icon(
                                    Icons.file_copy,
                                    size: responsive.ip(3),
                                    color: (bottomBloc.page == 1) ? Colors.red : Colors.grey,
                                  ),
                                  Text(
                                    'Documentos\n',
                                    style: TextStyle(
                                      fontSize: responsive.ip(1.5),
                                      color: (bottomBloc.page == 1) ? Colors.red : Colors.grey,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                bottomBloc.changePage(2);
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: responsive.hp(1),
                                  ),
                                  Icon(
                                    Icons.person,
                                    size: responsive.ip(3.5),
                                    color: (bottomBloc.page == 2) ? Colors.red : Colors.grey,
                                  ),
                                  Text(
                                    'Clientes y\nprospectos',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: responsive.ip(1.6),
                                      color: (bottomBloc.page == 2) ? Colors.red : Colors.grey,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                bottomBloc.changePage(3);
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: responsive.hp(1),
                                  ),
                                  Icon(
                                    Icons.view_agenda,
                                    size: responsive.ip(3),
                                    color: (bottomBloc.page == 3) ? Colors.red : Colors.grey,
                                  ),
                                  Text(
                                    'Agenda\n',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: responsive.ip(1.6),
                                      color: (bottomBloc.page == 3) ? Colors.red : Colors.grey,
                                    ),
                                  )
                                  /*  StreamBuilder(
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
                                        return Stack(
                                          children: [
                                            (cantidad != 0)
                                                ? Stack(
                                                    children: <Widget>[
                                                      Icon(
                                                        Icons.shopping_bag_rounded,
                                                        size: responsive.ip(3),
                                                        color: (bottomBloc.page == 3) ? Colors.red : Colors.grey,
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
                                                : Icon(
                                                    Icons.shopping_bag_rounded,
                                                    size: responsive.ip(3),
                                                    color: (bottomBloc.page == 3) ? Colors.red : Colors.grey,
                                                  ),
                                          ],
                                        );
                                      }),
                                  Text(
                                    'Carrito\n',
                                    style: TextStyle(
                                      fontSize: responsive.ip(1.6),
                                      color: (bottomBloc.page == 3) ? Colors.red : Colors.grey,
                                    ),
                                  ) */
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                bottomBloc.changePage(4);
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: responsive.hp(1),
                                  ),
                                  Icon(
                                    Icons.calculate,
                                    size: responsive.ip(3),
                                    color: (bottomBloc.page == 4) ? Colors.red : Colors.grey,
                                  ),
                                  Text(
                                    'Calculadora\n',
                                    style: TextStyle(
                                      fontSize: responsive.ip(1.6),
                                      color: (bottomBloc.page == 4) ? Colors.red : Colors.grey,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

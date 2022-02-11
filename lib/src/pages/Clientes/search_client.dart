import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:royal_prestige/src/bloc/provider_bloc.dart';
import 'package:royal_prestige/src/model/cliente_model.dart';
import 'package:royal_prestige/src/pages/Clientes/detalle_cliente.dart';
import 'package:royal_prestige/src/utils/responsive.dart';

class SearchClientePage extends StatefulWidget {
  const SearchClientePage({Key? key}) : super(key: key);

  @override
  _SearchClientePageState createState() => _SearchClientePageState();
}

class _SearchClientePageState extends State<SearchClientePage> with TickerProviderStateMixin {
  late TabController _controller = new TabController(vsync: this, length: 2);

  TextEditingController _controllerBusquedaProducto = TextEditingController();
  final _currentPageNotifier = ValueNotifier<bool>(false);
  int igual = 0;
  int csmare = 0;

  @override
  void dispose() {
    _controllerBusquedaProducto.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _controller.addListener(() {
        csmare = _controller.index;
        print('dentro ${_controller.index}');
        setState(() {});
      });
      final productosBloc = ProviderBloc.busCliente(context);

      productosBloc.queryClientes('prueba', true);
      productosBloc.queryProspectos('prueba', true);
    });
    print('initState');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    final productosBloc = ProviderBloc.busCliente(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
        toolbarHeight: responsive.hp(8),
        centerTitle: false,
        backgroundColor: Color(0xFFF0EFEF),
        flexibleSpace: SafeArea(
          child: Container(
            margin: EdgeInsets.only(
              left: responsive.wp(10),
              bottom: responsive.hp(1),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                      toolbarOptions: ToolbarOptions(paste: true, cut: true, copy: true, selectAll: true),
                      controller: _controllerBusquedaProducto,
                      keyboardType: TextInputType.text,
                      textAlign: TextAlign.start,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        labelStyle: TextStyle(color: Colors.white),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        hintText: '¿Qué está buscando?',
                        hintStyle: TextStyle(color: Colors.black45),
                      ),
                      /*  decoration: InputDecoration(
                      hintText: '¿Qué esta buscando?',
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: Colors.black45),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: responsive.hp(.2),
                      ),
                    ), */
                      onChanged: (value) {
                        print('valor de tal coaa $value');
                        if (value.length >= 0 && value != ' ' && value != '') {
                          final productosBloc = ProviderBloc.busCliente(context);

                          productosBloc.queryClientes('$value', false);
                          productosBloc.queryProspectos('$value', false);

                          igual++;
                          _currentPageNotifier.value = true;
                          //agregarHistorial(context, value, 'pro');
                        } else {
                          productosBloc.resetearCantidades();
                        }
                      },
                      onSubmitted: (value) {
                        if (value.length >= 0 && value != ' ' && value != '') {
                          igual++;
                          _currentPageNotifier.value = true;

                          final productosBloc = ProviderBloc.busCliente(context);

                          productosBloc.queryClientes('$value', false);
                          productosBloc.queryProspectos('$value', false);

                          //agregarHistorial(context, value, 'pro');
                        } else {
                          productosBloc.resetearCantidades();
                        }
                      }),
                ),
                SizedBox(
                  width: responsive.wp(1),
                ),
                ValueListenableBuilder(
                  valueListenable: _currentPageNotifier,
                  builder: (BuildContext context, bool data, Widget? child) {
                    return (data)
                        ? InkWell(
                            onTap: () {
                              igual++;

                              productosBloc.resetearCantidades();
                              _controllerBusquedaProducto.text = '';
                              //setState(() {});
                            },
                            child: CircleAvatar(
                              backgroundColor: Colors.grey,
                              radius: responsive.ip(1.5),
                              child: Icon(
                                Icons.close,
                                color: Colors.white,
                                size: responsive.ip(2),
                              ),
                            ),
                          )
                        : Container();
                  },
                ),
                SizedBox(
                  width: responsive.wp(1),
                ),
              ],
            ),
          ),
        ),
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            SizedBox(
              height: responsive.hp(1),
            ),
            ButtonsTabBar(
              duration: 0,
              height: responsive.hp(8),
              controller: _controller,
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border(
                  bottom: BorderSide(
                    color: Colors.red,
                    width: 1.5,
                  ),
                ),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: responsive.wp(3),
              ),
              onTap: (valor) {
                _controller.index = valor;
                //setState(() {_controller.index = valor;});
              },
              unselectedBackgroundColor: Colors.transparent,
              unselectedLabelStyle: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontFamily: 'MADE-TOMMY',
                fontSize: responsive.ip(1.6),
              ),
              labelStyle: TextStyle(
                color: Colors.red,
                fontFamily: 'MADE-TOMMY',
                fontWeight: FontWeight.bold,
                fontSize: responsive.ip(1.6),
              ),
              tabs: [
                //Restaurant
                Tab(
                  child: StreamBuilder(
                      stream: productosBloc.cantidadClientes,
                      builder: (context, AsyncSnapshot<int> snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.data == 20000) {
                            return (csmare == 0)
                                ? Text(
                                    'Clientes',
                                    style: TextStyle(color: Colors.red),
                                  )
                                : Text('Clientes', style: TextStyle(color: Colors.black));
                          } else {
                            return Row(
                              children: [
                                (csmare == 0)
                                    ? Text('Clientes',
                                        style: TextStyle(
                                          color: Colors.red,
                                        ))
                                    : Text('Clientes', style: TextStyle(color: Colors.black)),
                                SizedBox(width: responsive.wp(2)),
                                CircleAvatar(
                                  radius: responsive.ip(1.23),
                                  backgroundColor: Colors.red,
                                  child: Text(
                                    '${snapshot.data}',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: responsive.ip(1.1),
                                    ),
                                  ),
                                )
                              ],
                            );
                          }
                        } else {
                          return (csmare == 0)
                              ? Text(
                                  'Clientes',
                                  style: TextStyle(color: Colors.red),
                                )
                              : Text('Clientes', style: TextStyle(color: Colors.black));
                        }
                      }),
                ),
                //Restaurant \n Delivery
                Tab(
                  child: StreamBuilder(
                      stream: productosBloc.cantidadProspectos,
                      builder: (context, AsyncSnapshot<int> snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.data == 20000) {
                            return (csmare == 2)
                                ? Text(
                                    'Prospectos',
                                    style: TextStyle(color: Colors.red),
                                  )
                                : Text('Prospectos', style: TextStyle(color: Colors.black));
                          } else {
                            return Row(
                              children: [
                                (csmare == 2)
                                    ? Text(
                                        'Prospectos',
                                        style: TextStyle(color: Colors.red),
                                      )
                                    : Text('Prospectos', style: TextStyle(color: Colors.black)),
                                SizedBox(width: responsive.wp(2)),
                                CircleAvatar(
                                  radius: responsive.ip(1.23),
                                  backgroundColor: Colors.red,
                                  child: Text(
                                    '${snapshot.data}',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: responsive.ip(1.1),
                                    ),
                                  ),
                                )
                              ],
                            );
                          }
                        } else {
                          return (csmare == 2)
                              ? Text(
                                  'Prospectos',
                                  style: TextStyle(color: Colors.red),
                                )
                              : Text('Prospectos', style: TextStyle(color: Colors.black));
                        }
                      }),
                ),
              ],
            ),
            Expanded(
              child: TabBarView(controller: _controller, children: <Widget>[
                ClientesWidget(responsive: responsive),
                //RestaurantDeliveryWidget(responsive: responsive),
                ProspectosCliente(responsive: responsive),
                /* CafeDeliveryWidget(responsive: responsive),
                            VarWidget(responsive: responsive),
                            VarDeliveryWidget(responsive: responsive), */
              ]),
            )
          ],
        ),
      ),
    );
  }
}

class ClientesWidget extends StatelessWidget {
  const ClientesWidget({
    Key? key,
    required this.responsive,
  }) : super(key: key);

  final Responsive responsive;

  @override
  Widget build(BuildContext context) {
    final productosBloc = ProviderBloc.busCliente(context);
    return StreamBuilder(
      stream: productosBloc.productosQueryEnchiladasStream,
      builder: (BuildContext context, AsyncSnapshot<List<ClienteModel>> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.length > 0) {
            return ListView.builder(
              padding: EdgeInsets.only(top: responsive.hp(1)),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, i) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) {
                          return DetalleCliente(
                            clienteModel: snapshot.data![i],
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
                    child: Column(
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: responsive.wp(3),
                            ),
                            Expanded(
                              child: Text(
                                '${snapshot.data![i].nombreCliente}',
                                style: TextStyle(
                                  fontSize: responsive.ip(1.6),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Divider()
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return Column(
              children: [
                CircleAvatar(
                  radius: responsive.ip(5),
                  backgroundColor: Colors.grey,
                  child: Icon(
                    Icons.search,
                    color: Colors.yellow,
                    size: responsive.ip(4),
                  ),
                ),
                Center(
                  child: Text(
                    'Producto no encontrado',
                    style: TextStyle(
                      fontSize: responsive.ip(2),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    'Intente búscar otro producto',
                    style: TextStyle(
                      fontSize: responsive.ip(1.8),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                SizedBox(height: responsive.hp(5)),
              ],
            );
          }
        } else {
          return Container();
        }
      },
    );
  }
}

class ProspectosCliente extends StatelessWidget {
  const ProspectosCliente({
    Key? key,
    required this.responsive,
  }) : super(key: key);

  final Responsive responsive;

  @override
  Widget build(BuildContext context) {
    final productosBloc = ProviderBloc.busCliente(context);
    return StreamBuilder(
      stream: productosBloc.productosQueryCafeStream,
      builder: (BuildContext context, AsyncSnapshot<List<ClienteModel>> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.length > 0) {
            return ListView.builder(
              padding: EdgeInsets.only(top: responsive.hp(1)),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, i) {
                return InkWell(
                  onTap: () {
                    /* Navigator.push(
                      context,
                      PageRouteBuilder(
                        transitionDuration: const Duration(milliseconds: 400),
                        pageBuilder: (context, animation, secondaryAnimation) {
                          return DetalleProductitoss2(
                            productosData: snapshot.data[i],
                            mostrarback: true,
                          );
                        },
                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                          return FadeTransition(
                            opacity: animation,
                            child: child,
                          );
                        },
                      ),
                    ); */
                  },
                  child: Container(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: responsive.wp(3),
                            ),
                            Expanded(
                              child: Text(
                                '${snapshot.data![i].nombreCliente}',
                                style: TextStyle(
                                  fontSize: responsive.ip(1.6),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Divider()
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return Column(
              children: [
                CircleAvatar(
                  radius: responsive.ip(5),
                  backgroundColor: Colors.grey,
                  child: Icon(
                    Icons.search,
                    color: Colors.yellow,
                    size: responsive.ip(4),
                  ),
                ),
                Center(
                  child: Text(
                    'Producto no encontrado',
                    style: TextStyle(
                      fontSize: responsive.ip(2),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    'Intente búscar otro producto',
                    style: TextStyle(
                      fontSize: responsive.ip(1.8),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                SizedBox(height: responsive.hp(5)),
              ],
            );
          }
        } else {
          return Container();
        }
      },
    );
  }
}

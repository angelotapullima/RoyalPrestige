import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:provider/provider.dart';
import 'package:royal_prestige/src/bloc/provider_bloc.dart';
import 'package:royal_prestige/src/model/cliente_model.dart';
import 'package:royal_prestige/src/pages/Clientes/agregar_cliente.dart';
import 'package:royal_prestige/src/utils/responsive.dart';

class SearchCliente2Page extends StatefulWidget {
  const SearchCliente2Page({Key? key}) : super(key: key);

  @override
  _SearchCliente2PageState createState() => _SearchCliente2PageState();
}

class _SearchCliente2PageState extends State<SearchCliente2Page> with TickerProviderStateMixin {
  late TabController _controller = new TabController(vsync: this, length: 2);

  TextEditingController _controllerBusquedaCliente = TextEditingController();
  final _currentPageNotifier = ValueNotifier<bool>(false);
  int igual = 0;
  int csmare = 0;

  FocusNode _focusSearch = FocusNode();

  @override
  void dispose() {
    _controllerBusquedaCliente.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.addListener(() {
        csmare = _controller.index;
        setState(() {});
      });
      final productosBloc = ProviderBloc.busCliente(context);

      productosBloc.queryClientes('', true);
      productosBloc.queryProspectos('', true);
    });
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
          child: KeyboardActions(
            config: KeyboardActionsConfig(
              keyboardSeparatorColor: Colors.white,
              keyboardBarColor: Colors.white,
              actions: [
                KeyboardActionsItem(
                  focusNode: _focusSearch,
                  toolbarButtons: [
                    (node) {
                      return GestureDetector(
                        onTap: () => node.unfocus(),
                        child: Container(
                          color: Colors.white,
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "Cerrar",
                          ),
                        ),
                      );
                    }
                  ],
                ),
              ],
            ),
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
                        controller: _controllerBusquedaCliente,
                        keyboardType: TextInputType.text,
                        focusNode: _focusSearch,
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
                        onChanged: (value) {
                          if (value.length >= 0 && value != ' ' && value != '') {
                            final productosBloc = ProviderBloc.busCliente(context);

                            productosBloc.queryClientes('$value', false);
                            productosBloc.queryProspectos('$value', false);

                            igual++;
                            _currentPageNotifier.value = true;
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
                                _controllerBusquedaCliente.text = '';
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) {
                return AgregarCliente();
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
        child: Icon(
          Icons.add,
        ),
        backgroundColor: Colors.red,
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
                ProspectosCliente(responsive: responsive),
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
                    final provider = Provider.of<BusquedaClienteController>(context, listen: false);
                    provider.changeCliente('${snapshot.data![i].idCliente}', '${snapshot.data![i].nombreCliente}');
                    Navigator.pop(context);
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
                    'Cliente no encontrado',
                    style: TextStyle(
                      fontSize: responsive.ip(2),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    'Intente búscar otro cliente',
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
                    final provider = Provider.of<BusquedaClienteController>(context, listen: false);
                    provider.changeCliente('${snapshot.data![i].idCliente}', '${snapshot.data![i].nombreCliente}');
                    Navigator.pop(context);
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
                    'Prospecto no encontrado',
                    style: TextStyle(
                      fontSize: responsive.ip(2),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    'Intente búscar otro prospecto',
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

class BusquedaClienteController with ChangeNotifier {
  ValueNotifier<String> _idCliente = ValueNotifier('');
  ValueNotifier<String> get idCliente => this._idCliente;

  ValueNotifier<String> _nombreCliente = ValueNotifier('');
  ValueNotifier<String> get nombreCliente => this._nombreCliente;

  void changeCliente(String id, String nombre) {
    _idCliente.value = id;
    _nombreCliente.value = nombre;
  }
}

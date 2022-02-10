import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:royal_prestige/src/bloc/provider_bloc.dart';
import 'package:royal_prestige/src/model/cliente_model.dart';
import 'package:royal_prestige/src/pages/Clientes/agregar_cliente.dart';
import 'package:royal_prestige/src/pages/Clientes/editar_cliente.dart';

class ClientesyProspectosPage extends StatefulWidget {
  const ClientesyProspectosPage({Key? key}) : super(key: key);

  @override
  State<ClientesyProspectosPage> createState() => _ClientesyProspectosPageState();
}

class _ClientesyProspectosPageState extends State<ClientesyProspectosPage> {
  final _controller = Controller();
  TextEditingController _busquedaController = TextEditingController();
  final _currentPageNotifier = ValueNotifier<bool>(false);
  @override
  Widget build(BuildContext context) {
    final clienteBloc = ProviderBloc.cliente(context);
    clienteBloc.getClient();
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
        toolbarHeight: ScreenUtil().setHeight(130),
        centerTitle: false,
        backgroundColor: Colors.transparent,
        flexibleSpace: SafeArea(
          child: Container(
            margin: EdgeInsets.only(
              left: ScreenUtil().setWidth(10),
              bottom: ScreenUtil().setHeight(1),
            ),
            child: Column(
              children: [
                Container(
                  height: ScreenUtil().setHeight(60),
                  padding: EdgeInsets.symmetric(
                    horizontal: ScreenUtil().setWidth(10),
                    vertical: ScreenUtil().setHeight(5),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        ' Clientes',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(24),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Spacer(),
                      InkWell(
                        onTap: () {
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
                    ],
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                          toolbarOptions: ToolbarOptions(paste: true, cut: true, copy: true, selectAll: true),
                          controller: _busquedaController,
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
                            hintText: 'Buscar...',
                            hintStyle: TextStyle(color: Colors.black45),
                          ),
                          onChanged: (value) {
                            if (value.length >= 0 && value != ' ' && value != '') {
                              // final productosBloc = ProviderBloc.busquedaAngelo(context);
                              // if (preferences.tipoCategoriaNumero == '3') {
                              //   productosBloc.queryCafe('$value', '3', false);
                              // } else if (preferences.tipoCategoriaNumero == '4') {
                              //   productosBloc.queryVar('$value', '4', false);
                              // } else if (preferences.tipoCategoriaNumero == '1') {
                              //   productosBloc.queryCafe('$value', '3', false);
                              //   productosBloc.queryEnchiladas('$value', '1', false);
                              // } else {
                              //   productosBloc.queryEnchiladasDelivery('$value', '5', false);
                              //   productosBloc.queryCafeDelivery('$value', '6', false);
                              //   productosBloc.queryVarDelivery('$value', '7', false);
                              // }

                              // igual++;
                              _currentPageNotifier.value = true;
                              //agregarHistorial(context, value, 'pro');
                            } else {
                              //productosBloc.resetearCantidades();
                            }
                          },
                          onSubmitted: (value) {
                            if (value.length >= 0 && value != ' ' && value != '') {
                              //igual++;
                              _currentPageNotifier.value = true;
                              // final productosBloc = ProviderBloc.busquedaAngelo(context);
                              // if (preferences.tipoCategoriaNumero == '3') {
                              //   productosBloc.queryCafe('$value', '3', false);
                              // } else if (preferences.tipoCategoriaNumero == '4') {
                              //   productosBloc.queryVar('$value', '4', false);
                              // } else if (preferences.tipoCategoriaNumero == '1') {
                              //   productosBloc.queryCafe('$value', '3', false);
                              //   productosBloc.queryEnchiladas('$value', '1', false);
                              // } else {
                              //   productosBloc.queryEnchiladasDelivery('$value', '5', false);
                              //   productosBloc.queryCafeDelivery('$value', '6', false);
                              //   productosBloc.queryVarDelivery('$value', '7', false);
                              // }

                              //agregarHistorial(context, value, 'pro');
                            } else {
                              //productosBloc.resetearCantidades();
                            }
                          }),
                    ),
                    SizedBox(
                      width: ScreenUtil().setWidth(10),
                    ),
                    ValueListenableBuilder(
                      valueListenable: _currentPageNotifier,
                      builder: (BuildContext context, bool data, Widget? child) {
                        return (data)
                            ? InkWell(
                                onTap: () {
                                  // igual++;

                                  // productosBloc.resetearCantidades();
                                  _busquedaController.text = '';
                                },
                                child: CircleAvatar(
                                  backgroundColor: Colors.grey,
                                  radius: ScreenUtil().radius(10),
                                  child: Icon(
                                    Icons.close,
                                    color: Colors.white,
                                    size: ScreenUtil().setSp(15),
                                  ),
                                ),
                              )
                            : Container();
                      },
                    ),
                    SizedBox(
                      width: ScreenUtil().setWidth(10),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                AnimatedBuilder(
                    animation: _controller,
                    builder: (_, t) {
                      return tabAnimated();
                    }),
                SizedBox(
                  height: ScreenUtil().setHeight(10),
                ),
                Expanded(
                  child: StreamBuilder(
                    stream: clienteBloc.clienteStream,
                    builder: (BuildContext context, AsyncSnapshot<List<ClienteModel>> snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data!.length > 0) {
                          return ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              return focusGeneral(
                                  context,
                                  Column(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: ScreenUtil().setWidth(10),
                                          vertical: ScreenUtil().setHeight(5),
                                        ),
                                        child: Row(
                                          children: [
                                            Text(
                                              '${index + 1}.',
                                              style: TextStyle(
                                                fontSize: ScreenUtil().setSp(20),
                                              ),
                                            ),
                                            SizedBox(
                                              width: ScreenUtil().setWidth(10),
                                            ),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '${snapshot.data![index].nombreCliente}',
                                                  style: TextStyle(
                                                    fontSize: ScreenUtil().setSp(18),
                                                  ),
                                                ),
                                                Text(
                                                  '${snapshot.data![index].nroDocCliente}',
                                                  style: TextStyle(fontSize: ScreenUtil().setSp(16), fontWeight: FontWeight.bold),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                      Divider(),
                                    ],
                                  ),
                                  snapshot.data![index]);
                            },
                          );
                        } else {
                          return Center(
                            child: Text('No hay clientes registrados'),
                          );
                        }
                      } else {
                        return CupertinoActivityIndicator();
                      }
                    },
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  FocusedMenuHolder focusGeneral(BuildContext context, Widget childs, ClienteModel cliente) {
    return FocusedMenuHolder(
        blurBackgroundColor: Colors.black.withOpacity(0.2),
        blurSize: 0,
        animateMenuItems: true,
        onPressed: () {},
        openWithTap: true,
        menuWidth: ScreenUtil().setWidth(210),
        menuItems: [
          FocusedMenuItem(
            title: Expanded(
              child: Text(
                "Editar",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w400,
                  fontSize: ScreenUtil().setSp(18),
                  letterSpacing: ScreenUtil().setSp(0.016),
                  color: Colors.black,
                ),
              ),
            ),
            trailingIcon: Icon(
              Icons.edit_outlined,
              color: Colors.grey,
              size: ScreenUtil().setHeight(20),
            ),
            onPressed: () {
              //DetailProveedor

              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) {
                    return EditarCliente(
                      clienteModel: cliente,
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
              //DocumentosProveedor
            },
          ),
          FocusedMenuItem(
            title: Expanded(
              child: Text(
                "Eliminar",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w400,
                  fontSize: ScreenUtil().setSp(18),
                  letterSpacing: ScreenUtil().setSp(0.016),
                  color: Colors.black,
                ),
              ),
            ),
            trailingIcon: Icon(
              Icons.delete,
              color: Colors.grey,
              size: ScreenUtil().setHeight(20),
            ),
            onPressed: () async {
              /*  Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) {
                    return DetailProveedor(
                      proveedor: proveedores[index],
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
             */
            },
          ),
        ],
        child: childs);
  }

  Container tabAnimated() {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: ScreenUtil().setWidth(20),
      ),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 8,
            offset: Offset(0, 2), // changes position of shadow
          ),
        ],
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0XFFECF4FF),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () {
                _controller.changeValueBoton(1);

                //ticketBloc.getTicketsForUser('0');
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: ScreenUtil().setHeight(7),
                  horizontal: ScreenUtil().setWidth(2),
                ),
                decoration: BoxDecoration(
                  color: (_controller.valueBoton == 1) ? Colors.red : Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                  ),
                ),
                child: Center(
                  child: Text(
                    'Clientes',
                    style: GoogleFonts.poppins(
                      color: (_controller.valueBoton == 1) ? Colors.white : Colors.black.withOpacity(0.6),
                      fontWeight: FontWeight.w500,
                      fontSize: ScreenUtil().setSp(15),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () {
                _controller.changeValueBoton(2);
                //ticketBloc.getTicketsForUser('2');
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: ScreenUtil().setHeight(7),
                  horizontal: ScreenUtil().setWidth(2),
                ),
                decoration: BoxDecoration(
                  color: (_controller.valueBoton == 2) ? Colors.red : Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Center(
                  child: Text(
                    'Prospectos',
                    style: GoogleFonts.poppins(
                      color: (_controller.valueBoton == 2) ? Colors.white : Colors.black.withOpacity(0.6),
                      fontWeight: FontWeight.w500,
                      fontSize: ScreenUtil().setSp(15),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Controller extends ChangeNotifier {
  int valueBoton = 1;

  void changeValueBoton(int v) {
    valueBoton = v;
    notifyListeners();
  }
}

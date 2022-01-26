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

class ClientePage extends StatelessWidget {
  const ClientePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final clienteBloc = ProviderBloc.cliente(context);
    clienteBloc.getClient();
    return Scaffold(
      body: Stack(
        children: [
          Column(
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
}

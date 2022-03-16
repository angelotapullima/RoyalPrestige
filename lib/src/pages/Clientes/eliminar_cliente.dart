import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:royal_prestige/src/api/cliente_api.dart';
import 'package:royal_prestige/src/bloc/provider_bloc.dart';
import 'package:royal_prestige/src/model/cliente_model.dart';
import 'package:royal_prestige/src/utils/utils.dart';
import 'package:royal_prestige/src/widget/show_loading.dart';

class EliminarCliente extends StatefulWidget {
  const EliminarCliente({Key? key, required this.cliente}) : super(key: key);
  final ClienteModel cliente;

  @override
  State<EliminarCliente> createState() => _EliminarClienteState();
}

class _EliminarClienteState extends State<EliminarCliente> {
  final _controller = EliminarClienteController();
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withOpacity(.5),
      child: Stack(
        fit: StackFit.expand,
        children: [
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              height: double.infinity,
              width: double.infinity,
              color: Color.fromRGBO(0, 0, 0, 0.5),
            ),
          ),
          Container(
            height: double.infinity,
            width: double.infinity,
            margin: EdgeInsets.symmetric(
              vertical: ScreenUtil().setHeight(300),
              horizontal: ScreenUtil().setWidth(30),
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                SizedBox(
                  height: ScreenUtil().setHeight(25),
                ),
                Center(
                  child: Container(
                    child: Image.asset(
                      'assets/img/logo-royal.png',
                      fit: BoxFit.cover,
                      height: ScreenUtil().setHeight(50),
                    ),
                  ),
                ),
                Text(
                  '¿Desea eliminar al cliente ${widget.cliente.nombreCliente}?',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: ScreenUtil().setSp(16),
                  ),
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(20),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: ScreenUtil().setWidth(130),
                      child: MaterialButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        color: NewColors.card,
                        textColor: Colors.white,
                        child: Text('No'),
                      ),
                    ),
                    SizedBox(
                      width: ScreenUtil().setWidth(20),
                    ),
                    SizedBox(
                      width: ScreenUtil().setWidth(130),
                      child: MaterialButton(
                        onPressed: () async {
                          _controller.changeAtive(true);
                          final clienteApi = ClienteApi();
                          final res = await clienteApi.eliminarCliente(widget.cliente.idCliente.toString());

                          if (res) {
                            final clienteBloc = ProviderBloc.cliente(context);
                            clienteBloc.getClientForTipo(widget.cliente.tipo.toString());
                            Navigator.pop(context);
                            Navigator.pop(context);
                          } else {
                            showToast2('Ocurrió un error, inténtelo nuevamente', Colors.red);
                          }
                          _controller.changeAtive(false);
                        },
                        color: Colors.red,
                        textColor: Colors.white,
                        child: Text('Si'),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          AnimatedBuilder(
              animation: _controller,
              builder: (_, t) {
                return ShowLoadding(
                  active: _controller.active,
                  h: double.infinity,
                  w: double.infinity,
                  colorText: Colors.transparent,
                  fondo: Colors.black.withOpacity(0.5),
                );
              }),
        ],
      ),
    );
  }
}

class EliminarClienteController extends ChangeNotifier {
  bool active = false;

  void changeAtive(bool a) {
    active = a;
    notifyListeners();
  }
}

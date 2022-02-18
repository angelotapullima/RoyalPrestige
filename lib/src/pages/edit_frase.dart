import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:royal_prestige/src/api/login_api.dart';
import 'package:royal_prestige/src/bloc/provider_bloc.dart';
import 'package:royal_prestige/src/utils/colors.dart';
import 'package:royal_prestige/src/utils/responsive.dart';
import 'package:royal_prestige/src/utils/utils.dart';

class EditFrase extends StatefulWidget {
  const EditFrase({Key? key, required this.frase}) : super(key: key);
  final String frase;

  @override
  State<EditFrase> createState() => _EditFraseState();
}

class _EditFraseState extends State<EditFrase> {
  ValueNotifier<bool> _cargando = ValueNotifier(false);
  TextEditingController _fraseController = TextEditingController();

  @override
  void dispose() {
    _fraseController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _fraseController.text = widget.frase;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          'Editar frase',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: ValueListenableBuilder(
        valueListenable: _cargando,
        builder: (BuildContext context, bool data, Widget? child) {
          return Stack(
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: ScreenUtil().setWidth(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: ScreenUtil().setHeight(25),
                      ),
                      Center(
                        child: Container(
                          height: ScreenUtil().setHeight(150),
                          child: Image.asset('assets/img/sethi_logo.png'),
                        ),
                      ),
                      SizedBox(
                        height: ScreenUtil().setHeight(20),
                      ),
                      Text(
                        ' Frase',
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(16),
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(
                        height: ScreenUtil().setHeight(6),
                      ),
                      TextField(
                        controller: _fraseController,
                        maxLines: 2,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Frase',
                          hintStyle: TextStyle(
                            fontSize: ScreenUtil().setSp(14),
                            color: Colors.grey[600],
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Colors.grey.shade300,
                              width: 1.0,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Colors.grey.shade300,
                              width: 2.0,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey.shade300,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(
                              ScreenUtil().setWidth(10),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: ScreenUtil().setHeight(20),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: MaterialButton(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          color: colorPrimary,
                          onPressed: () async {
                            if (_fraseController.text.isNotEmpty) {
                              if (_fraseController.text != widget.frase) {
                                _cargando.value = true;

                                final loginApi = LoginApi();

                                final res = await loginApi.editarFrase(_fraseController.text);

                                if (res.code == '1') {
                                  _cargando.value = false;
                                  final dataBloc = ProviderBloc.data(context);
                                  dataBloc.obtenerDatosUser();
                                  Navigator.pop(context);
                                  showToast2('Frase editada correctamente', Colors.green);
                                } else {
                                  _cargando.value = false;
                                  showToast2('${res.message}', Colors.red);
                                }
                              } else {
                                Navigator.pop(context);
                              }
                            } else {
                              showToast2('Por favor ingrese una frase', Colors.red);
                            }
                          },
                          child: Text(
                            'Guardar',
                            style: TextStyle(color: Colors.white, fontSize: ScreenUtil().setSp(17)),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: ScreenUtil().setHeight(50),
                      ),
                    ],
                  ),
                ),
              ),
              (data) ? _mostrarAlert(responsive) : Container()
            ],
          );
        },
      ),
    );
  }

  Widget _mostrarAlert(Responsive responsive) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: Colors.white.withOpacity(.5),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: CupertinoActivityIndicator(),
            ),
            Text(
              'Enviando',
              //'${snapshot.data}.toInt()%',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: responsive.ip(2.4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

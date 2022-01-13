import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:royal_prestige/src/utils/colors.dart';
import 'package:royal_prestige/src/utils/utils.dart';
import 'package:royal_prestige/src/widget/show_loading.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _usuarioController = TextEditingController();
  final TextEditingController _cargoController = TextEditingController();
  final TextEditingController _passwdController = TextEditingController();

  final _controller = ControllerLogin();

  @override
  void dispose() {
    _usuarioController.dispose();
    _passwdController.dispose();
    _cargoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: ScreenUtil().setHeight(61),
                    ),
                    Container(
                      child: Image.asset('assets/img/logo-royal.png'),
                    ),
                    Text(
                      'Bienvenido a Royal Prestige',
                      style: GoogleFonts.rambla(
                        fontWeight: FontWeight.w600,
                        fontSize: ScreenUtil().setSp(24),
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(40),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(24)),
                      child: TextField(
                        maxLines: 1,
                        controller: _usuarioController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: 'Usuario',
                          labelStyle: TextStyle(
                            color: colorgray,
                            fontWeight: FontWeight.w400,
                            fontSize: ScreenUtil().setSp(15),
                          ),
                          prefixIcon: Icon(
                            Icons.person_outline_rounded,
                            color: colorPrimary,
                          ),
                          filled: true,
                          fillColor: Color(0XFFEEEEEE),
                          contentPadding:
                              EdgeInsets.only(left: ScreenUtil().setWidth(10), top: ScreenUtil().setHeight(5), bottom: ScreenUtil().setHeight(1)),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(color: Color(0XFFEEEEEE), width: ScreenUtil().setWidth(1)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(color: Color(0XFFEEEEEE), width: ScreenUtil().setWidth(1)),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(color: Color(0XFFEEEEEE), width: ScreenUtil().setWidth(1)),
                          ),
                        ),
                        style: TextStyle(
                          color: colorPrimary,
                          fontWeight: FontWeight.w700,
                          fontSize: ScreenUtil().setSp(15),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(16),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(24)),
                      child: TextField(
                        maxLines: 1,
                        controller: _cargoController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: 'Cargo',
                          prefixIcon: Icon(
                            Icons.settings_outlined,
                            color: colorPrimary,
                          ),
                          labelStyle: TextStyle(
                            color: colorgray,
                            fontWeight: FontWeight.w400,
                            fontSize: ScreenUtil().setSp(15),
                          ),
                          filled: true,
                          fillColor: Color(0XFFEEEEEE),
                          contentPadding:
                              EdgeInsets.only(left: ScreenUtil().setWidth(10), top: ScreenUtil().setHeight(5), bottom: ScreenUtil().setHeight(1)),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(color: Color(0XFFEEEEEE), width: ScreenUtil().setWidth(1)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(color: Color(0XFFEEEEEE), width: ScreenUtil().setWidth(1)),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(color: Color(0XFFEEEEEE), width: ScreenUtil().setWidth(1)),
                          ),
                        ),
                        style: TextStyle(
                          color: colorPrimary,
                          fontWeight: FontWeight.w700,
                          fontSize: ScreenUtil().setSp(15),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(16),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(24)),
                      child: TextField(
                        maxLines: 1,
                        controller: _passwdController,
                        keyboardType: TextInputType.text,
                        obscureText: true,
                        decoration: InputDecoration(
                          filled: true,
                          prefixIcon: Icon(
                            Icons.lock_outline,
                            color: colorPrimary,
                          ),
                          labelText: 'Contraseña',
                          labelStyle: TextStyle(
                            color: colorgray,
                            fontWeight: FontWeight.w400,
                            fontSize: ScreenUtil().setSp(15),
                          ),
                          fillColor: Color(0XFFEEEEEE),
                          contentPadding:
                              EdgeInsets.only(left: ScreenUtil().setWidth(10), top: ScreenUtil().setHeight(5), bottom: ScreenUtil().setHeight(1)),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(color: Color(0XFFEEEEEE), width: ScreenUtil().setWidth(1)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(color: Color(0XFFEEEEEE), width: ScreenUtil().setWidth(1)),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(color: Color(0XFFEEEEEE), width: ScreenUtil().setWidth(1)),
                          ),
                        ),
                        style: TextStyle(
                          color: colorPrimary,
                          fontWeight: FontWeight.w700,
                          fontSize: ScreenUtil().setSp(15),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(50),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(24)),
                      width: double.infinity,
                      child: MaterialButton(
                        height: ScreenUtil().setHeight(48),
                        color: colorPrimary,
                        textColor: Colors.white,
                        elevation: 0,
                        onPressed: () async {
                          if (_usuarioController.text.length > 0) {
                            if (_cargoController.text.length > 0) {
                              if (_passwdController.text.length > 0) {
                                _controller.changeLoadding(true);
                                // final _login = LoginApi();
                                // final res = await _login.login(_usuarioController.text, _passwdController.text);

                                // if (res.code == 1) {
                                //   Navigator.pushNamed(context, HOME_ROUTE);
                                // } else {
                                //   showToast2(res.message, Colors.black);
                                // }
                                _controller.changeLoadding(false);
                              } else {
                                showToast2('Ingrese su contraseña', Colors.black);
                              }
                            } else {
                              showToast2('Ingrese su cargo', Colors.black);
                            }
                          } else {
                            showToast2('Ingrese su usuario', Colors.black);
                          }
                          //
                        },
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(100),
                          ),
                        ),
                        child: Text(
                          'Ingresar',
                          style: Theme.of(context).textTheme.button!.copyWith(
                                color: Colors.white,
                                fontSize: ScreenUtil().setSp(16),
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            AnimatedBuilder(
                animation: _controller,
                builder: (context, snapshot) {
                  return ShowLoadding(
                    active: _controller.loadding,
                    h: double.infinity,
                    w: double.infinity,
                    fondo: Colors.black.withOpacity(.3),
                    colorText: Colors.black,
                  );
                }),
          ],
        ),
      ),
    );
  }
}

class ControllerLogin extends ChangeNotifier {
  bool loadding = false;
  void changeLoadding(bool v) {
    loadding = v;
    notifyListeners();
  }
}

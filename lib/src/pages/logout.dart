import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:royal_prestige/core/sharedpreferences/storage_manager.dart';
import 'package:royal_prestige/src/utils/utils.dart';

class Logout extends StatelessWidget {
  const Logout({Key? key}) : super(key: key);

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
                  '¿Desea Cerrar Sesión?',
                  style: GoogleFonts.poppins(
                    fontSize: ScreenUtil().setSp(18),
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
                          await StorageManager.deleteAllData();
                          Navigator.of(context).pushNamedAndRemoveUntil('login', (Route<dynamic> route) => true);
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
          )
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:royal_prestige/core/sharedpreferences/storage_manager.dart';

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
              color: Colors.white,
              margin: EdgeInsets.symmetric(
                vertical: ScreenUtil().setHeight(300),
                horizontal: ScreenUtil().setWidth(30),
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: ScreenUtil().setHeight(50),
                  ),
                  Text(
                    'Desea Cerrar Sesión?',
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(22),
                    ),
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(40),
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
                          color: Colors.red,
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
                          color: Colors.green,
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

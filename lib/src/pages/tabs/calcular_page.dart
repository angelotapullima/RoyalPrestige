import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:royal_prestige/src/utils/colors.dart';

class CalcularPage extends StatefulWidget {
  const CalcularPage({Key? key}) : super(key: key);

  @override
  State<CalcularPage> createState() => _CalcularPageState();
}

class _CalcularPageState extends State<CalcularPage> {
  final TextEditingController _precioProductoController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(
          top: kBottomNavigationBarHeight + ScreenUtil().setHeight(10),
          left: ScreenUtil().setWidth(21),
          right: ScreenUtil().setWidth(21),
        ),
        child: Column(
          children: [
            Container(
              child: TextField(
                maxLines: 1,
                controller: _precioProductoController,
                keyboardType: TextInputType.number,
                obscureText: true,
                decoration: InputDecoration(
                  filled: true,
                  labelText: 'Precio producto',
                  labelStyle: TextStyle(
                    color: colorgray,
                    fontWeight: FontWeight.w400,
                    fontSize: ScreenUtil().setSp(12),
                  ),
                  fillColor: Colors.white,
                  contentPadding: EdgeInsets.only(left: ScreenUtil().setWidth(10), top: ScreenUtil().setHeight(5), bottom: ScreenUtil().setHeight(1)),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: colorPrimary, width: ScreenUtil().setWidth(1)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: colorPrimary, width: ScreenUtil().setWidth(1)),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: colorPrimary, width: ScreenUtil().setWidth(1)),
                  ),
                ),
                style: TextStyle(
                  color: colorPrimary,
                  fontWeight: FontWeight.w700,
                  fontSize: ScreenUtil().setSp(15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ControllerCalculo extends ChangeNotifier {
  double fivepercent = 0, tenpercent = 0, fifteenpercent = 0;
}

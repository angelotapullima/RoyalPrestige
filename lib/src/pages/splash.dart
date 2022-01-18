import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:royal_prestige/core/sharedpreferences/storage_manager.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 2), () async {
      String? token = await StorageManager.readData('token');
      if (token == null || token.isEmpty) {
        Navigator.pushNamedAndRemoveUntil(context, 'login', (route) => false);
      } else {
        Navigator.pushNamedAndRemoveUntil(context, 'home', (route) => false);
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const SizedBox.expand(),
          Center(
            child: SizedBox(
              width: ScreenUtil().setWidth(350),
              height: ScreenUtil().setHeight(350),
              child: const Image(
                image: AssetImage('assets/img/logo-royal.png'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

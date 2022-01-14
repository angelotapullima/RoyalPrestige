import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:royal_prestige/src/bloc/provider_bloc.dart';
import 'package:royal_prestige/src/pages/home.dart';
import 'package:royal_prestige/src/pages/login.dart';
import 'package:royal_prestige/src/pages/splash.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ProviderBloc(
        child: ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: () => MaterialApp(
        title: 'Asistencia Samiria',
        theme: ThemeData(
          primarySwatch: Colors.blueGrey,
        ),
        debugShowCheckedModeBanner: false,
        builder: (BuildContext context, Widget? child) {
          final MediaQueryData data = MediaQuery.of(context);
          return MediaQuery(
            data: data.copyWith(textScaleFactor: data.textScaleFactor > 2.0 ? 1.2 : data.textScaleFactor),
            child: child!,
          );
        },
        // localizationsDelegates: const [
        //   GlobalMaterialLocalizations.delegate,
        //   GlobalWidgetsLocalizations.delegate,
        //   GlobalCupertinoLocalizations.delegate,
        // ],
        // supportedLocales: const [
        //   Locale('es'),
        //   Locale('es', 'ES'),
        // ],
        // localeResolutionCallback: (Locale? locale, Iterable<Locale> supportedLocales) {
        //   return locale;
        // },
        initialRoute: 'splash',
        routes: {
          'splash': (BuildContext context) => const Splash(),
          'login': (BuildContext context) => const Login(),
          'home': (BuildContext context) => const HomePage(),
        },
      ),
    ));
  }
}

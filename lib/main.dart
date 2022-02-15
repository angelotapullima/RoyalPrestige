import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:royal_prestige/bloc_provider/calculator_bloc.dart';
import 'package:royal_prestige/src/bloc/provider_bloc.dart';
import 'package:royal_prestige/src/pages/Alertas/search_cliente.dart';
import 'package:royal_prestige/src/pages/Compras/search_product.dart';
import 'package:royal_prestige/src/pages/busqueda_de_producto.dart';
import 'package:royal_prestige/src/pages/documento/nuevo_documento.dart';
import 'package:royal_prestige/src/pages/home.dart';
import 'package:royal_prestige/src/pages/login.dart';
import 'package:royal_prestige/src/pages/splash.dart';
import 'package:royal_prestige/src/pages/tabs/documentosPage.dart';
import 'package:royal_prestige/src/pages/tabs/prueba_inicio.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // @override
  // void initState() {
  //   super.initState();
  //   LocalNotificationApi.init(initScheluded: true);
  //   listenNotification();
  // }

  // void listenNotification() {
  //   LocalNotificationApi.onNotifications.stream.listen(onClickNotifications);
  // }

  // void onClickNotifications(String? playLoad) async => await Navigator.of(context).push(
  //       MaterialPageRoute<void>(
  //         builder: (context) => DetalleAlerta(
  //           idAlert: playLoad,
  //         ),
  //       ),
  //     );

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<BusquedaClienteController>(
          create: (_) => BusquedaClienteController(),
        ),
        ChangeNotifierProvider<EstadoController>(
          create: (_) => EstadoController(),
        ),
        ChangeNotifierProvider<EstadoListener>(
          create: (_) => EstadoListener(),
        ),
        ChangeNotifierProvider<UploapBloc>(
          create: (_) => UploapBloc(),
        ),
        ChangeNotifierProvider<DocumentsBloc>(
          create: (_) => DocumentsBloc(),
        ),
        ChangeNotifierProvider<ControllerCalculo>(
          create: (_) => ControllerCalculo(),
        ),
        ChangeNotifierProvider<PrincipalChangeBloc>(
          create: (_) => PrincipalChangeBloc(),
        ),
      ],
      child: ProviderBloc(
          child: ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: () => MaterialApp(
          title: 'Royal Prestige',
          theme: ThemeData(
            primarySwatch: Colors.blueGrey,
            textTheme: GoogleFonts.latoTextTheme(),
          ),
          debugShowCheckedModeBanner: false,
          builder: (BuildContext context, Widget? child) {
            final MediaQueryData data = MediaQuery.of(context);
            return MediaQuery(
              data: data.copyWith(textScaleFactor: data.textScaleFactor > 2.0 ? 1.2 : data.textScaleFactor),
              child: child!,
            );
          },
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('es'),
            Locale('es', 'ES'),
          ],
          localeResolutionCallback: (Locale? locale, Iterable<Locale> supportedLocales) {
            return locale;
          },
          initialRoute: 'splash',
          routes: {
            'splash': (BuildContext context) => const Splash(),
            'login': (BuildContext context) => const Login(),
            'home': (BuildContext context) => const HomePage(),
          },
        ),
      )),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:royal_prestige/src/bloc/bottom_navigation_bloc.dart';
import 'package:royal_prestige/src/bloc/productos_bloc.dart';

class ProviderBloc extends InheritedWidget {
  final bottonBloc = BottomNaviBloc();
  final productosBloc = ProductosBloc();
  ProviderBloc({Key? key, required Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(ProviderBloc oldWidget) => true;

  static BottomNaviBloc botton(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<ProviderBloc>())!.bottonBloc;
  }

  static ProductosBloc productos(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<ProviderBloc>())!.productosBloc;
  }
}

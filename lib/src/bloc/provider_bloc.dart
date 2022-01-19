import 'package:flutter/material.dart';
import 'package:royal_prestige/src/bloc/bottom_navigation_bloc.dart';
import 'package:royal_prestige/src/bloc/data_user.dart';
import 'package:royal_prestige/src/bloc/productos_bloc.dart';

class ProviderBloc extends InheritedWidget {
  final bottonBloc = BottomNaviBloc();
  final productosBloc = ProductosBloc();
  final dataUserBloc = DataUserBloc();
  ProviderBloc({Key? key, required Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(ProviderBloc oldWidget) => true;

  static BottomNaviBloc botton(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<ProviderBloc>())!.bottonBloc;
  }

  static ProductosBloc productos(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<ProviderBloc>())!.productosBloc;
  }


  static DataUserBloc data(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<ProviderBloc>())!.dataUserBloc;
  }

}

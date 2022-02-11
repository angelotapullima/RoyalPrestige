import 'package:flutter/material.dart';
import 'package:royal_prestige/src/bloc/alert_bloc.dart';
import 'package:royal_prestige/src/bloc/bottom_navigation_bloc.dart';
import 'package:royal_prestige/src/bloc/busqueda_bloc.dart';
import 'package:royal_prestige/src/bloc/cart_bloc.dart';
import 'package:royal_prestige/src/bloc/clientes_bloc.dart';
import 'package:royal_prestige/src/bloc/data_user.dart';
import 'package:royal_prestige/src/bloc/document_bloc.dart';
import 'package:royal_prestige/src/bloc/galeria_producto_bloc.dart';
import 'package:royal_prestige/src/bloc/productos_bloc.dart';
import 'package:royal_prestige/src/bloc/promocion_bloc.dart';

class ProviderBloc extends InheritedWidget {
  final bottonBloc = BottomNaviBloc();
  final productosBloc = ProductosBloc();
  final dataUserBloc = DataUserBloc();
  final documentBloc = DocumentBloc();
  final clientesBloc = ClientesBloc();
  final alertBloc = AlertBloc();
  final cartBloc = CartBloc();
  final galeryBloc = GaleryBloc();
  final promoBloc = PromocionBloc();
  final busquedaGeneralTab = BusquedaGeneralTab();
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

  static DocumentBloc document(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<ProviderBloc>())!.documentBloc;
  }

  static ClientesBloc cliente(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<ProviderBloc>())!.clientesBloc;
  }

  static AlertBloc alert(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<ProviderBloc>())!.alertBloc;
  }

  static CartBloc cart(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<ProviderBloc>())!.cartBloc;
  }

  static GaleryBloc galery(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<ProviderBloc>())!.galeryBloc;
  }

  static PromocionBloc promocion(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<ProviderBloc>())!.promoBloc;
  }


  static BusquedaGeneralTab busCliente(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<ProviderBloc>())!.busquedaGeneralTab;
  }
}

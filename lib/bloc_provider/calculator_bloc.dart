import 'package:flutter/material.dart';

class ControllerCalculo extends ChangeNotifier {
  int twentyPercent = 0, tenpercent = 0, fifteenpercent = 0;
  int cuota12 = 0, cuota14 = 0, cuota16 = 0, cuota19 = 0;
  /*  int cuota2 = 0, cuota3 = 0, cuota4 = 0, cuota5 = 0, cuota6 = 0;
  int cuota7 = 0, cuota8 = 0, cuota9 = 0, cuota10 = 0, cuota11 = 0, cuota12 = 0;
  int cuota13 = 0, cuota14 = 0, cuota15 = 0, cuota16 = 0, cuota17 = 0, cuota18 = 0;
  int cuota19 = 0, cuota20 = 0, cuota21 = 0, cuota22 = 0, cuota23 = 0, cuota24 = 0; */
  bool expanded1 = true, expanded2 = true, expanded3 = true, expanded4 = false;
  double precioCompra = 0, igv = 0, total = 0, saldoFinancio = 0;
  String despacho = '0.00';

  void changeExpanded(bool e, int lugar) {
    if (lugar == 1) {
      expanded1 = e;
    } else if (lugar == 2) {
      expanded2 = e;
    } else if (lugar == 3) {
      expanded3 = e;
    } else if (lugar == 4) {
      expanded4 = e;
    }

    notifyListeners();
  }

  void calcularProducto(String precio) {
    double precioProduct = double.parse(precio);

    twentyPercent = (precioProduct * .2).round();
    tenpercent = (precioProduct * .1).round();
    fifteenpercent = (precioProduct * .15).round();

    precioCompra = precioProduct / 1.18;
    igv = precioCompra * 0.18;
    total = precioCompra + igv;
    despacho = '-';

    notifyListeners();
  }

  void calcularCuotas(String precioProducto, String pagoIncial) {
    double saldofinanciar = double.parse(precioProducto) - double.parse(pagoIncial);

    /*  cuota2 = (saldofinanciar * .5223).round();
    cuota3 = (saldofinanciar * .3533).round();
    cuota4 = (saldofinanciar * .2688).round();
    cuota5 = (saldofinanciar * .2181).round();
    cuota6 = (saldofinanciar * .1844).round();
    cuota7 = (saldofinanciar * .1603).round();
    cuota8 = (saldofinanciar * .1423).round();
    cuota9 = (saldofinanciar * .1282).round();
    cuota10 = (saldofinanciar * .1170).round();
    cuota11 = (saldofinanciar * .1079).round();
   
    cuota13 = (saldofinanciar * (9.38 / 100)).round();
    cuota17 = (saldofinanciar * (7.57 / 100)).round();
    cuota18 = (saldofinanciar * (7.25 / 100)).round();
    cuota19 = (saldofinanciar * (6.96 / 100)).round();
    cuota20 = (saldofinanciar * (6.70 / 100)).round();
    cuota21 = (saldofinanciar * (6.47 / 100)).round();
    cuota22 = (saldofinanciar * (6.25 / 100)).round();
    cuota23 = (saldofinanciar * (6.06 / 100)).round();
    cuota24 = (saldofinanciar * (5.88 / 100)).round(); */
    cuota12 = (saldofinanciar * .1003).round();
    cuota14 = (saldofinanciar * (8.83 / 100)).round();
    cuota16 = (saldofinanciar * (7.94 / 100)).round();
    cuota19 = (saldofinanciar * (6.96 / 100)).round();
    saldoFinancio = saldofinanciar;

    notifyListeners();
  }

  void limpiar() {
    /**
   * 
   
  int  cuota2 = 0, cuota3 = 0, cuota4 = 0, cuota5 = 0, cuota6 = 0;
  int cuota7 = 0, cuota8 = 0, cuota9 = 0, cuota10 = 0, cuota11 = 0, cuota12 = 0;
  int cuota13 = 0, cuota14 = 0, cuota15 = 0, cuota16 = 0, cuota17 = 0, cuota18 = 0;
  int cuota19 = 0, cuota20 = 0, cuota21 = 0, cuota22 = 0, cuota23 = 0, cuota24 = 0;
  bool expanded1 = true, expanded2 = true, expanded3 = true;
  double precioCompra = 0, igv = 0, total = 0, saldoFinancio = 0;
  String despacho = '0.00';


   */
    twentyPercent = 0;
    tenpercent = 0;
    fifteenpercent = 0;
    igv = 0;
    precioCompra = 0;
    total = 0;
    despacho = '0.00';
    expanded4 = false;
/* 
    cuota2 = 0;
    cuota3 = 0;
    cuota4 = 0;
    cuota5 = 0;
    cuota6 = 0;
    cuota7 = 0;
    cuota8 = 0;
    cuota9 = 0;
    cuota10 = 0;
    cuota11 = 0;
    cuota12 = 0;
    cuota13 = 0;
    cuota14 = 0;
    cuota15 = 0;
    cuota16 = 0;
    cuota17 = 0;
    cuota18 = 0;
    cuota19 = 0;
    cuota20 = 0;
    cuota21 = 0;
    cuota22 = 0;
    cuota23 = 0;
    cuota24 = 0; */
    saldoFinancio = 0;
    notifyListeners();
  }
}

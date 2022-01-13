import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

void showToast2(String texto, Color color) {
  Fluttertoast.showToast(msg: texto, toastLength: Toast.LENGTH_SHORT, timeInSecForIosWeb: 3, backgroundColor: color, textColor: Colors.white);
}

obtenerFecha() {
  var fecha = DateTime.now();
  final DateFormat fech = DateFormat('yyyy-MM-dd');
  return fech.format(fecha);
}

obtenerFechaMostrar(String date) {
  var fecha = DateTime.parse(date);

  final DateFormat fech = DateFormat('dd MMMM, yyyy', 'es');
  return fech.format(fecha);
}

obtenerHora() {
  var fecha = DateTime.now();
  final DateFormat fech = DateFormat('HH:mm:ss');
  return fech.format(fecha);
}

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

void showToast2(String texto, Color color) {
  Fluttertoast.showToast(msg: texto, toastLength: Toast.LENGTH_SHORT, timeInSecForIosWeb: 3, backgroundColor: color, textColor: Colors.white);
}

obtenerFecha(String date) {
  if (date == 'null' || date == '') {
    return '';
  }

  var fecha = DateTime.parse(date);

  final DateFormat fech = new DateFormat('dd MMM yyyy', 'es');

  return fech.format(fecha);
}

obtenerHora(String date) {
  var fecha = DateTime.parse('$date');
  final DateFormat fech = DateFormat('hh:mm a');
  return fech.format(fecha);
}
/* 
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


obtenerFechaString(String date) {
  if (date == 'null' || date == '') {
    return '';
  }

  var fecha = DateTime.parse(date);

  final DateFormat fech = new DateFormat('dd MMM yyyy', 'es');

  return fech.format(fecha);
}

 */

class NewColors {
  static final Color black = Color(0xFF5A5A5A);
  static final Color orangeLight = Color(0xFFFF9700);
  static final Color grayBackSpace = Color(0xFFC4C4C4);
  static final Color green = Color(0xFF4CB050);
  static final Color grayBIcon = Color(0xFF808080);
  static final Color white = Color(0xFFF7F7F7);
  static final Color gayText = Color(0xFF8D9597);
  static final Color blackLogout = Color(0xFF353535);
  static final Color backGroundCarnet = Color(0xFF343434);
  static final Color grayCarnet = Color(0xFF808080);
  static final Color blue = Color(0xFF2186D0);
  static final Color purple = Color(0xFF9E00FF);
  static final Color plin = Color(0xFF00C7FE);
  static final Color card = Color(0xFF003663);
  static final Color barrasOff = Color(0XFFADADAD);
}

//bool isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;


import 'package:flutter/material.dart';

class DetalleAlerta extends StatelessWidget {
  const DetalleAlerta({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: Text('Alerta'),
      ),
    );
  }
}

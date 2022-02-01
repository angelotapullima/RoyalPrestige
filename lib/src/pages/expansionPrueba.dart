import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:royal_prestige/src/utils/responsive.dart';

class ExpansionPrueba extends StatefulWidget {
  final int cuotas;
  final String title;
  final String precio;
  const ExpansionPrueba({Key? key, required this.cuotas, required this.title, required this.precio}) : super(key: key);

  @override
  State<ExpansionPrueba> createState() => _ExpansionPruebaState();
}

class _ExpansionPruebaState extends State<ExpansionPrueba> {
  bool change = false;
  List<Widget> chilo = [];
  @override
  Widget build(BuildContext context) {
    chilo.clear();
    int ii = widget.cuotas;
    for (var i = 0; i < widget.cuotas; i++) {
      ii--;
      chilo.add(
        Container(
          padding: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(5)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Cuota  N°${ii + 1}',
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(14),
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                'S/.${widget.precio}',
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(14),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      child: ExpansionTile(
          tilePadding: EdgeInsets.zero,
          onExpansionChanged: (valor) {
            print(valor);
            setState(() {
              change = valor;
            });
          },
          /* trailing: Container(
            //margin: EdgeInsets.symmetric(vertical: responsive.hp(.5)),
            child: CircleAvatar(
              radius: responsive.ip(1.5),
              backgroundColor: Color(0xfff7f7f7),
              child: Icon(
                change ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                color: Colors.grey,
              ),
            ),
          ), */
          title: Text(
            widget.title,
            style: TextStyle(
                fontSize: ScreenUtil().setSp(14),
                fontWeight: FontWeight.w400,
              ),
          ),
          children: chilo),
    );
  }
}

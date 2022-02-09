import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:royal_prestige/bloc_provider/calculator_bloc.dart';

class ExpansionPrueba extends StatefulWidget {
  final String title;
  const ExpansionPrueba({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  State<ExpansionPrueba> createState() => _ExpansionPruebaState();
}

class _ExpansionPruebaState extends State<ExpansionPrueba> {
  //final _controller = ControllerCalculo();
  late ControllerCalculo _controller;
  @override
  void initState() {
    _controller = Provider.of<ControllerCalculo>(context, listen: false);
    super.initState();
  }

  bool change = false;
  String cuota34 = '';
  List<Widget> chilo = [];
  @override
  Widget build(BuildContext context) {
    chilo.clear();
    int ii = 0;
    /* for (var i = 0; i < widget.cuotas; i++) {
      ii++;
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
                'S/._controller.cuota11}',
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(14),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      );
    } */

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
          children: [
            item('Cuota  N°2', '${_controller.cuota2}'),
            item('Cuota  N°3', '${_controller.cuota3}'),
            item('Cuota  N°4', '${_controller.cuota4}'),
            item('Cuota  N°5', '${_controller.cuota5}'),
            item('Cuota  N°6', '${_controller.cuota6}'),
            item('Cuota  N°7', '${_controller.cuota7}'),
            item('Cuota  N°8', '${_controller.cuota8}'),
            item('Cuota  N°9', '${_controller.cuota9}'),
            item('Cuota  N°10', '${_controller.cuota10}'),
            item('Cuota  N°11', '${_controller.cuota11}'),
            item('Cuota  N°12', '${_controller.cuota12}'),
            item('Cuota  N°13', '${_controller.cuota13}'),
            item('Cuota  N°14', '${_controller.cuota14}'),
            item('Cuota  N°15', '${_controller.cuota15}'),
            item('Cuota  N°16', '${_controller.cuota16}'),
            item('Cuota  N°17', '${_controller.cuota17}'),
            item('Cuota  N°18', '${_controller.cuota18}'),
            item('Cuota  N°19', '${_controller.cuota19}'),
            item('Cuota  N°20', '${_controller.cuota20}'),
            item('Cuota  N°21', '${_controller.cuota21}'),
            item('Cuota  N°22', '${_controller.cuota22}'),
            item('Cuota  N°23', '${_controller.cuota23}'),
            item('Cuota  N°24', '${_controller.cuota24}'),
          ]),
    );
  }

  Container item(String title, String cuota) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(8)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: ScreenUtil().setSp(14),
              fontWeight: FontWeight.w400,
            ),
          ),
          Text(
            'S/.$cuota.00',
            style: TextStyle(
              fontSize: ScreenUtil().setSp(15),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

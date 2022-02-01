import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:royal_prestige/src/pages/expansionPrueba.dart';
import 'package:royal_prestige/src/utils/colors.dart';
import 'package:royal_prestige/src/utils/responsive.dart';

class CalculaDoraPage extends StatefulWidget {
  final double monto;
  const CalculaDoraPage({Key? key, required this.monto}) : super(key: key);

  @override
  State<CalculaDoraPage> createState() => _CalculaDoraPageState();
}

class _CalculaDoraPageState extends State<CalculaDoraPage> {
  final TextEditingController _depositoController = TextEditingController();
  final _controller = ControllerCalculo();

  @override
  void initState() {
    _controller.calcularProducto(widget.monto.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Calcular',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            left: ScreenUtil().setWidth(21),
            right: ScreenUtil().setWidth(21),
          ),
          child: AnimatedBuilder(
              animation: _controller,
              builder: (_, c) {
                return Column(
                  children: [
                    /*  Container(
                      child: TextField(
                        maxLines: 1,
                        controller: _precioProductoController,
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            _controller.calcularProducto(value);
                          } else {
                            _controller.lipiar();
                            _depositoController.text = '';
                          }
                        },
                        decoration: InputDecoration(
                          filled: true,
                          labelText: 'Precio producto',
                          labelStyle: TextStyle(
                            color: colorgray,
                            fontWeight: FontWeight.w400,
                            fontSize: ScreenUtil().setSp(12),
                          ),
                          fillColor: Colors.white,
                          contentPadding:
                              EdgeInsets.only(left: ScreenUtil().setWidth(10), top: ScreenUtil().setHeight(5), bottom: ScreenUtil().setHeight(1)),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(color: colorPrimary, width: ScreenUtil().setWidth(1)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(color: colorPrimary, width: ScreenUtil().setWidth(1)),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(color: colorPrimary, width: ScreenUtil().setWidth(1)),
                          ),
                        ),
                        style: TextStyle(
                          color: colorPrimary,
                          fontWeight: FontWeight.w700,
                          fontSize: ScreenUtil().setSp(15),
                        ),
                      ),
                    ),
                     */

                    _expandedContainer('MONTO INICIAL (%)', _controller.expanded1, _contenido1(), 1),
                    SizedBox(
                      height: ScreenUtil().setHeight(14),
                    ),
                    _expandedContainer('PRODUCTO', _controller.expanded2, _contenido2(), 2),
                    SizedBox(
                      height: ScreenUtil().setHeight(14),
                    ),
                    _expandedContainer('CUOTAS', _controller.expanded3, _contenido3(responsive), 3),
                    SizedBox(
                      height: ScreenUtil().setHeight(24),
                    ),
                  ],
                );
              }),
        ),
      ),
    );
  }

  Widget _expandedContainer(String titulo, bool expanded, Widget contenido, int lugar) {
    return Container(
      child: Stack(
        children: [
          (expanded)
              ? Container(
                  padding: EdgeInsets.only(
                    left: ScreenUtil().setWidth(24),
                    right: ScreenUtil().setWidth(24),
                    top: ScreenUtil().setHeight(50),
                    bottom: ScreenUtil().setHeight(8),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: const Offset(1, 0), // changes position of shadow
                      ),
                    ],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: contenido,
                )
              : Container(),
          InkWell(
            onTap: () {
              _controller.changeExpanded(!expanded, lugar);
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: ScreenUtil().setWidth(24),
                vertical: ScreenUtil().setHeight(8),
              ),
              decoration: BoxDecoration(
                color: colorPrimary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    titulo,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: ScreenUtil().setSp(14),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.white,
                    size: ScreenUtil().setHeight(20),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _contenido1() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '5%',
              style: TextStyle(
                fontSize: ScreenUtil().setSp(14),
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              'S/. ${_controller.fivepercent}.00',
              style: TextStyle(
                fontSize: ScreenUtil().setSp(14),
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '10%',
              style: TextStyle(
                fontSize: ScreenUtil().setSp(14),
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              'S/. ${_controller.tenpercent}.00',
              style: TextStyle(
                fontSize: ScreenUtil().setSp(14),
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '15%',
              style: TextStyle(
                fontSize: ScreenUtil().setSp(14),
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              'S/. ${_controller.fifteenpercent}.00',
              style: TextStyle(
                fontSize: ScreenUtil().setSp(14),
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        Divider(),
      ],
    );
  }

  Widget _contenido2() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Precio de compra',
              style: TextStyle(
                fontSize: ScreenUtil().setSp(14),
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              'S/. ${_controller.precioCompra.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: ScreenUtil().setSp(14),
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Costo de despacho',
              style: TextStyle(
                fontSize: ScreenUtil().setSp(14),
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              'S/. ${_controller.despacho}',
              style: TextStyle(
                fontSize: ScreenUtil().setSp(14),
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'IGV',
              style: TextStyle(
                fontSize: ScreenUtil().setSp(14),
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              'S/. ${_controller.igv.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: ScreenUtil().setSp(14),
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'PRECIO TOTAL',
              style: TextStyle(
                fontSize: ScreenUtil().setSp(14),
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              'S/. ${_controller.total.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: ScreenUtil().setSp(14),
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        Divider(),
      ],
    );
  }

  Widget _contenido3(Responsive responsive) {
    return Column(
      children: [
        Container(
          child: TextField(
            maxLines: 1,
            controller: _depositoController,
            keyboardType: TextInputType.number,
            onChanged: (value) {
              _controller.calcularCuotas(widget.monto.toString(), value);
            },
            decoration: InputDecoration(
              filled: true,
              labelText: 'Depósito pagado',
              labelStyle: TextStyle(
                color: colorgray,
                fontWeight: FontWeight.w400,
                fontSize: ScreenUtil().setSp(12),
              ),
              fillColor: Colors.white,
              contentPadding: EdgeInsets.only(left: ScreenUtil().setWidth(10), top: ScreenUtil().setHeight(5), bottom: ScreenUtil().setHeight(1)),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: colorPrimary, width: ScreenUtil().setWidth(1)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: colorPrimary, width: ScreenUtil().setWidth(1)),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: colorPrimary, width: ScreenUtil().setWidth(1)),
              ),
            ),
            style: TextStyle(
              color: colorPrimary,
              fontWeight: FontWeight.w700,
              fontSize: ScreenUtil().setSp(15),
            ),
          ),
        ),
        SizedBox(
          height: ScreenUtil().setHeight(16),
        ),
        Text(
          'Saldo a financiar: S/. ${_controller.saldoFinancio.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: ScreenUtil().setSp(14),
            fontWeight: FontWeight.w600,
            color: colorPrimary,
          ),
        ),
        SizedBox(
          height: ScreenUtil().setHeight(24),
        ),
        ExpansionPrueba(
          cuotas: 12,
          title: '12 CUOTAS (10%)',
          precio: '${_controller.cuota12}.00',
        ),
        ExpansionPrueba(
          cuotas: 14,
          title: '14 CUOTAS (9%)',
          precio: '${_controller.cuota14}.00',
        ),
        ExpansionPrueba(
          cuotas: 16,
          title: '16 CUOTAS (8%)',
          precio: '${_controller.cuota16}.00',
        ),
        ExpansionPrueba(
          cuotas: 19,
          title: '19 CUOTAS (7%)',
          precio: '${_controller.cuota19}.00',
        ),
        ExpansionPrueba(
          cuotas: 23,
          title: '23 CUOTAS (6%)',
          precio: '${_controller.cuota23}.00',
        ),
        ExpansionPrueba(
          cuotas: 28,
          title: '28 CUOTAS (5%)',
          precio: '${_controller.cuota23}.00',
        ),
        
      ],
    );
  }
}

class ControllerCalculo extends ChangeNotifier {
  int fivepercent = 0, tenpercent = 0, fifteenpercent = 0;
  int cuota12 = 0, cuota14 = 0, cuota16 = 0, cuota19 = 0, cuota23 = 0, cuota28 = 0;
  bool expanded1 = true, expanded2 = true, expanded3 = true;
  double precioCompra = 0, igv = 0, total = 0, saldoFinancio = 0;
  String despacho = '0.00';

  void changeExpanded(bool e, int lugar) {
    if (lugar == 1) {
      expanded1 = e;
    } else if (lugar == 2) {
      expanded2 = e;
    } else if (lugar == 3) {
      expanded3 = e;
    }

    notifyListeners();
  }

  void calcularProducto(String precio) {
    double precioProduct = double.parse(precio);

    fivepercent = (precioProduct * .05).round();
    tenpercent = (precioProduct * .1).round();
    fifteenpercent = (precioProduct * .15).round();

    igv = precioProduct * 0.1525416;
    precioCompra = precioProduct - igv;
    total = precioCompra + igv;
    despacho = '-';

    notifyListeners();
  }

  void calcularCuotas(String precioProducto, String pagoIncial) {
    double saldofinanciar = double.parse(precioProducto) - double.parse(pagoIncial);

    cuota12 = (saldofinanciar * 0.1).round();
    cuota14 = (saldofinanciar * .09).round();
    cuota16 = (saldofinanciar * .08).round();
    cuota19 = (saldofinanciar * .07).round();
    cuota23 = (saldofinanciar * .06).round();
    cuota28 = (saldofinanciar * .05).round();
    saldoFinancio = saldofinanciar;

    notifyListeners();
  }

  void lipiar() {
    fivepercent = 0;
    tenpercent = 0;
    fifteenpercent = 0;
    igv = 0;
    precioCompra = 0;
    total = 0;
    despacho = '0.00';
    cuota12 = 0;
    cuota14 = 0;
    cuota16 = 0;
    cuota19 = 0;
    cuota23 = 0;
    cuota28 = 0;
    saldoFinancio = 0;
    notifyListeners();
  }
}

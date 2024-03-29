import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:provider/provider.dart';
import 'package:royal_prestige/bloc_provider/calculator_bloc.dart';
import 'package:royal_prestige/src/bloc/cuota_bloc.dart';
import 'package:royal_prestige/src/bloc/provider_bloc.dart';
import 'package:royal_prestige/src/model/cuota_model.dart';
import 'package:royal_prestige/src/pages/expansionPrueba.dart';
import 'package:royal_prestige/src/utils/colors.dart';
import 'package:royal_prestige/src/widget/carrito.dart';
import 'package:royal_prestige/src/widget/percent_widget.dart';

class CalcularPage extends StatefulWidget {
  const CalcularPage({Key? key}) : super(key: key);

  @override
  State<CalcularPage> createState() => _CalcularPageState();
}

class _CalcularPageState extends State<CalcularPage> {
  final TextEditingController _precioProductoController = TextEditingController();
  final TextEditingController _depositoController = TextEditingController();
  // final _controller = ControllerCalculo();}
  late ControllerCalculo _controller;

  FocusNode _focusPrecio = FocusNode();
  FocusNode _focusDeposito = FocusNode();

  @override
  void initState() {
    _controller = Provider.of<ControllerCalculo>(context, listen: false);
    super.initState();
  }

  int init = 0;

  @override
  Widget build(BuildContext context) {
    final cuotaBloc = ProviderBloc.cuota(context);
    final percentBloc = ProviderBloc.pencert(context);
    if (init == 0) {
      percentBloc.cargarPercents();
    }
    init++;
    percentBloc.cargarPercents();
    init++;
    cuotaBloc.getCuotasMostar();
    return Scaffold(
      body: SafeArea(
        child: KeyboardActions(
          config: KeyboardActionsConfig(
            keyboardSeparatorColor: Colors.white,
            keyboardBarColor: Colors.white,
            actions: [
              KeyboardActionsItem(
                focusNode: _focusPrecio,
                toolbarButtons: [
                  (node) {
                    return GestureDetector(
                      onTap: () => node.unfocus(),
                      child: Container(
                        color: Colors.white,
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Cerrar",
                        ),
                      ),
                    );
                  }
                ],
              ),
              KeyboardActionsItem(
                focusNode: _focusDeposito,
                toolbarButtons: [
                  (node) {
                    return GestureDetector(
                      onTap: () => node.unfocus(),
                      child: Container(
                        color: Colors.white,
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Cerrar",
                        ),
                      ),
                    );
                  }
                ],
              ),
            ],
          ),
          child: SingleChildScrollView(
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
                      Container(
                        padding: EdgeInsets.only(
                          left: ScreenUtil().setWidth(10),
                          top: ScreenUtil().setHeight(5),
                          bottom: ScreenUtil().setHeight(5),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Calculadora',
                              style: TextStyle(
                                fontSize: ScreenUtil().setSp(20),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Spacer(),
                            CarritoWidget(color: Colors.grey)
                          ],
                        ),
                      ),
                      Container(
                        child: TextField(
                          maxLines: 1,
                          controller: _precioProductoController,
                          focusNode: _focusPrecio,
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              _controller.calcularProducto(value);
                              percentBloc.updateMontoPercent(value);
                            } else {
                              _controller.limpiar();
                              _depositoController.text = '';
                              percentBloc.cargarPercents();
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
                      SizedBox(
                        height: ScreenUtil().setHeight(24),
                      ),
                      _expandedContainer('MONTO INICIAL (%)', _controller.expanded1, PercentWidget(), 1, _controller),
                      SizedBox(
                        height: ScreenUtil().setHeight(14),
                      ),
                      _expandedContainer('PRODUCTO', _controller.expanded2, _contenido2(_controller), 2, _controller),
                      SizedBox(
                        height: ScreenUtil().setHeight(14),
                      ),
                      _expandedContainer('CUOTAS', _controller.expanded3, _contenido3(_controller, cuotaBloc), 3, _controller),
                      SizedBox(
                        height: ScreenUtil().setHeight(14),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _expandedContainer(String titulo, bool expanded, Widget contenido, int lugar, ControllerCalculo _controller) {
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

  // Widget _contenido1(ControllerCalculo _controller) {
  //   return Column(
  //     children: [
  //       Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         children: [
  //           Text(
  //             '10%',
  //             style: TextStyle(
  //               fontSize: ScreenUtil().setSp(14),
  //               fontWeight: FontWeight.w400,
  //             ),
  //           ),
  //           Text(
  //             'S/. ${_controller.tenpercent}.00',
  //             style: TextStyle(
  //               fontSize: ScreenUtil().setSp(14),
  //               fontWeight: FontWeight.w400,
  //             ),
  //           ),
  //         ],
  //       ),
  //       Divider(),
  //       Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         children: [
  //           Text(
  //             '15%',
  //             style: TextStyle(
  //               fontSize: ScreenUtil().setSp(14),
  //               fontWeight: FontWeight.w400,
  //             ),
  //           ),
  //           Text(
  //             'S/. ${_controller.fifteenpercent}.00',
  //             style: TextStyle(
  //               fontSize: ScreenUtil().setSp(14),
  //               fontWeight: FontWeight.w400,
  //             ),
  //           ),
  //         ],
  //       ),
  //       Divider(),
  //       Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         children: [
  //           Text(
  //             '20%',
  //             style: TextStyle(
  //               fontSize: ScreenUtil().setSp(14),
  //               fontWeight: FontWeight.w400,
  //             ),
  //           ),
  //           Text(
  //             'S/. ${_controller.twentyPercent}.00',
  //             style: TextStyle(
  //               fontSize: ScreenUtil().setSp(14),
  //               fontWeight: FontWeight.w400,
  //             ),
  //           ),
  //         ],
  //       ),
  //       Divider(),
  //     ],
  //   );
  // }

  Widget _contenido2(ControllerCalculo _controller) {
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
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        Divider(
          thickness: 2,
        ),
        Container(
          child: TextField(
            maxLines: 1,
            controller: _depositoController,
            keyboardType: TextInputType.number,
            focusNode: _focusDeposito,
            onChanged: (value) {
              if (value.isNotEmpty && _precioProductoController.text.isNotEmpty) {
                _controller.calcularCuotas(_precioProductoController.text, value);
              }
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
        Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'SALDO A FINANCIAR',
              style: TextStyle(
                fontSize: ScreenUtil().setSp(14),
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              'S/. ${_controller.saldoFinancio.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: ScreenUtil().setSp(14),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _contenido3(ControllerCalculo _controller, CuotaBloc cuotaBloc) {
    return Column(
      children: [
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
        Container(
          child: StreamBuilder(
            stream: cuotaBloc.cuotasMostrarStream,
            builder: (BuildContext context, AsyncSnapshot<List<CuotaModel>> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.length > 0) {
                  return Container(
                    height: snapshot.data!.length * ScreenUtil().setHeight(20),
                    child: ListView.builder(
                      physics: ClampingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('${snapshot.data![index].cuotaNombre}   --->'),
                            Text(
                              'S/. ${(double.parse('${_controller.saldoFinancio.toStringAsFixed(2)}') * double.parse('${snapshot.data![index].cuotaMultiplicador}')).round()}.00',
                            ),
                          ],
                        );
                      },
                      itemCount: snapshot.data!.length,
                    ),
                  );
                } else {
                  return Container();
                }
              } else {
                return Container();
              }
            },
          ),
        ),
        SizedBox(
          height: ScreenUtil().setHeight(10),
        ),
        ExpansionPrueba(
          title: 'Mostrar todas las cuotas',
          monto: '${_controller.saldoFinancio.toStringAsFixed(2)}',
        ),
      ],
    );
  }
}

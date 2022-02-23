import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:provider/provider.dart';
import 'package:royal_prestige/bloc_provider/calculator_bloc.dart';
import 'package:royal_prestige/src/bloc/cuota_bloc.dart';
import 'package:royal_prestige/src/bloc/provider_bloc.dart';
import 'package:royal_prestige/src/model/cuota_model.dart';
import 'package:royal_prestige/src/model/producto_model.dart';
import 'package:royal_prestige/src/pages/expansionPrueba.dart';
import 'package:royal_prestige/src/utils/colors.dart';
import 'package:royal_prestige/src/utils/responsive.dart';
import 'package:royal_prestige/src/utils/utils.dart';

class CalculaDoraPage extends StatefulWidget {
  final double monto;
  final List<ProductoModel> cart;
  const CalculaDoraPage({Key? key, required this.monto, required this.cart}) : super(key: key);

  @override
  State<CalculaDoraPage> createState() => _CalculaDoraPageState();
}

class _CalculaDoraPageState extends State<CalculaDoraPage> {
  final TextEditingController _depositoController = TextEditingController();
  FocusNode _focusDeposito = FocusNode();

  late ControllerCalculo _controller;

  @override
  void initState() {
    _controller = Provider.of<ControllerCalculo>(context, listen: false);
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _controller.limpiar();
      _controller.calcularProducto(widget.monto.toString());
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final cuotaBloc = ProviderBloc.cuota(context);
    cuotaBloc.getCuotasMostar();
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
      body: KeyboardActions(
        config: KeyboardActionsConfig(
          keyboardSeparatorColor: Colors.white,
          keyboardBarColor: Colors.white,
          actions: [
            KeyboardActionsItem(
              focusNode: _focusDeposito,
              toolbarButtons: [
                (node) {
                  return closeNode(node);
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
                    _expandedContainer('MONTO INICIAL (%)', _controller.expanded1, _contenido1(), 1),
                    SizedBox(
                      height: ScreenUtil().setHeight(14),
                    ),
                    _expandedContainer('PRODUCTO', _controller.expanded2, _contenido2(), 2),
                    SizedBox(
                      height: ScreenUtil().setHeight(14),
                    ),
                    _expandedContainer('CUOTAS', _controller.expanded3, _contenido3(responsive, cuotaBloc), 3),
                    SizedBox(
                      height: ScreenUtil().setHeight(24),
                    ),
                    _expandedContainer('INFORMACIÓN ADICIONAL', _controller.expanded4, _contenido4(_controller, widget.cart), 4),
                    SizedBox(
                      height: ScreenUtil().setHeight(24),
                    ),
                  ],
                );
              },
            ),
          ),
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '20%',
              style: TextStyle(
                fontSize: ScreenUtil().setSp(14),
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              'S/. ${_controller.twentyPercent}.00',
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

  Widget _contenido3(Responsive responsive, CuotaBloc cuotaBloc) {
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
          height: ScreenUtil().setHeight(10),
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
        ExpansionPrueba(
          title: 'Mostrar todas las cuotas',
          monto: '${_controller.saldoFinancio.toStringAsFixed(2)}',
        ),
        SizedBox(
          height: ScreenUtil().setHeight(24),
        ),
      ],
    );
  }

  Widget _contenido4(ControllerCalculo _controller, List<ProductoModel> cart) {
    return Container(
      height: cart.length * ScreenUtil().setHeight(80),
      child: ListView.builder(
        itemCount: cart.length + 1,
        itemBuilder: (context, index) {
          double total = 0;
          for (var i = 0; i < cart.length; i++) {
            total = double.parse('${cart[i].precioRegaloProducto}') + total;
          }
          if (index == cart.length) {
            return Row(
              children: [
                Expanded(
                  child: Text(
                    'Total',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                      fontSize: ScreenUtil().setSp(17),
                    ),
                  ),
                ),
                SizedBox(
                  width: ScreenUtil().setWidth(10),
                ),
                Text(
                  'S/.${total}0',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: ScreenUtil().setSp(15),
                  ),
                ),
              ],
            );
          }

          return Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(5)),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${cart[index].regaloProducto}',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: ScreenUtil().setSp(13),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: ScreenUtil().setWidth(10),
                    ),
                    Text(
                      'S/.${cart[index].precioRegaloProducto}.00',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: ScreenUtil().setSp(15),
                      ),
                    ),
                  ],
                ),
              ),
              Divider()
            ],
          );
        },
      ),
    );
  }
}

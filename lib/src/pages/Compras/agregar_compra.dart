import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:royal_prestige/src/api/cliente_api.dart';
import 'package:royal_prestige/src/bloc/provider_bloc.dart';
import 'package:royal_prestige/src/model/cliente_model.dart';
import 'package:royal_prestige/src/model/compras_model.dart';
import 'package:royal_prestige/src/utils/colors.dart';
import 'package:royal_prestige/src/utils/responsive.dart';
import 'package:royal_prestige/src/utils/utils.dart';

class AgregarCompra extends StatefulWidget {
  const AgregarCompra({Key? key, required this.clienteData}) : super(key: key);
  final ClienteModel clienteData;

  @override
  State<AgregarCompra> createState() => _AgregarCompraState();
}

class _AgregarCompraState extends State<AgregarCompra> {
  ValueNotifier<bool> _cargando = ValueNotifier(false);
  String fechaCompraDato = 'Seleccionar';
  TextEditingController _productosController = TextEditingController();
  TextEditingController _montoTotalController = TextEditingController();
  TextEditingController _fechaPagoController = TextEditingController();
  TextEditingController _observacionController = TextEditingController();

  FocusNode _focusProductos = FocusNode();
  FocusNode _focusMontoTotal = FocusNode();
  FocusNode _focusFechaPago = FocusNode();
  FocusNode _focusObservacion = FocusNode();

  @override
  void dispose() {
    _montoTotalController.dispose();
    _observacionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          'Nueva Compra',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: ValueListenableBuilder(
        valueListenable: _cargando,
        builder: (BuildContext context, bool data, Widget? child) {
          return Stack(
            children: [
              KeyboardActions(
                config: KeyboardActionsConfig(
                  keyboardSeparatorColor: Colors.white,
                  keyboardBarColor: Colors.white,
                  actions: [
                    KeyboardActionsItem(
                      focusNode: _focusProductos,
                      toolbarButtons: [
                        (node) {
                          return closeNode(node);
                        }
                      ],
                    ),
                    KeyboardActionsItem(
                      focusNode: _focusMontoTotal,
                      toolbarButtons: [
                        (node) {
                          return closeNode(node);
                        }
                      ],
                    ),
                    KeyboardActionsItem(
                      focusNode: _focusFechaPago,
                      toolbarButtons: [
                        (node) {
                          return closeNode(node);
                        }
                      ],
                    ),
                    KeyboardActionsItem(
                      focusNode: _focusObservacion,
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
                    padding: EdgeInsets.symmetric(
                      horizontal: ScreenUtil().setWidth(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: ScreenUtil().setHeight(25),
                        ),
                        Text(
                          ' Producto(s)',
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(16),
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(
                          height: ScreenUtil().setHeight(6),
                        ),
                        TextField(
                          controller: _productosController,
                          focusNode: _focusProductos,
                          keyboardType: TextInputType.multiline,
                          maxLines: 3,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'Nombre producto(s)',
                            hintStyle: TextStyle(
                              fontSize: ScreenUtil().setSp(14),
                              color: Colors.grey[600],
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
                                width: 1.0,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
                                width: 2.0,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(
                                ScreenUtil().setWidth(10),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: ScreenUtil().setHeight(20),
                        ),
                        Text(
                          ' Monto total',
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(16),
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(
                          height: ScreenUtil().setHeight(6),
                        ),
                        TextField(
                          controller: _montoTotalController,
                          focusNode: _focusMontoTotal,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'Monto total',
                            hintStyle: TextStyle(
                              fontSize: ScreenUtil().setSp(14),
                              color: Colors.grey[600],
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
                                width: 1.0,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
                                width: 2.0,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(
                                ScreenUtil().setWidth(10),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: ScreenUtil().setHeight(20),
                        ),
                        Text(
                          ' Fecha de pago',
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(16),
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(
                          height: ScreenUtil().setHeight(6),
                        ),
                        TextField(
                          controller: _fechaPagoController,
                          focusNode: _focusFechaPago,
                          keyboardType: TextInputType.text,
                          maxLines: 2,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'Fecha de pago',
                            hintStyle: TextStyle(
                              fontSize: ScreenUtil().setSp(14),
                              color: Colors.grey[600],
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
                                width: 1.0,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
                                width: 2.0,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(
                                ScreenUtil().setWidth(10),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: ScreenUtil().setHeight(20),
                        ),
                        Text(
                          ' Fecha de compra',
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(16),
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(
                          height: ScreenUtil().setHeight(6),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.grey.shade300,
                            ),
                          ),
                          padding: EdgeInsets.only(
                            right: ScreenUtil().setWidth(5),
                          ),
                          height: ScreenUtil().setHeight(50),
                          child: InkWell(
                            onTap: () {
                              _selectdate(context);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Text(
                                    fechaCompraDato,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: (fechaCompraDato != 'Seleccionar Todos') ? Color(0xff5a5a5a) : colorPrimary,
                                      fontSize: ScreenUtil().setSp(16),
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                                Icon(
                                  Icons.calendar_today,
                                  color: colorPrimary,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: ScreenUtil().setHeight(20),
                        ),
                        Text(
                          ' Observación',
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(16),
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(
                          height: ScreenUtil().setHeight(6),
                        ),
                        TextField(
                          maxLines: 3,
                          keyboardType: TextInputType.multiline,
                          controller: _observacionController,
                          focusNode: _focusObservacion,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'Observación ',
                            hintStyle: TextStyle(
                              fontSize: ScreenUtil().setSp(14),
                              color: Colors.grey[600],
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
                                width: 1.0,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
                                width: 2.0,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(
                                ScreenUtil().setWidth(10),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: ScreenUtil().setHeight(20),
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: MaterialButton(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            color: colorPrimary,
                            onPressed: () async {
                              if (_productosController.text.isNotEmpty) {
                                if (_montoTotalController.text.isNotEmpty) {
                                  if (_fechaPagoController.text.isNotEmpty) {
                                    if (fechaCompraDato != 'Seleccionar') {
                                      if (_observacionController.text.isNotEmpty) {
                                        _cargando.value = true;
                                        final clienteApi = ClienteApi();

                                        ComprasModel compra = ComprasModel();
                                        compra.idCliente = widget.clienteData.idCliente.toString();
                                        compra.idProducto = _productosController.text;
                                        compra.montoCuotaCompra = _montoTotalController.text;
                                        compra.fechaPagoCompra = _fechaPagoController.text;
                                        compra.fechaCompra = '$fechaCompraDato';
                                        compra.observacionCompra = _observacionController.text;

                                        final res = await clienteApi.guardarCompra(compra);

                                        if (res) {
                                          showToast2('Compra agregado correctamente', Colors.green);

                                          final comprasBloc = ProviderBloc.compras(context);
                                          comprasBloc.obtenerComprasByIdCliente(widget.clienteData.idCliente.toString());

                                          Navigator.pop(context);
                                          _cargando.value = false;
                                        } else {
                                          showToast2('Ocurrió un error', Colors.red);
                                          _cargando.value = false;
                                        }
                                      } else {
                                        showToast2('Por favor ingrese una observacion de la compra', Colors.red);
                                      }
                                    } else {
                                      showToast2('Por favor seleccione la fecha de compra', Colors.red);
                                    }
                                  } else {
                                    showToast2('Por favor seleccione la fecha de pago', Colors.red);
                                  }
                                } else {
                                  showToast2('Por favor ingrese el monto de pago por cuota', Colors.red);
                                }
                              } else {
                                showToast2('Por favor ingrese producto(s)', Colors.red);
                              }
                            },
                            child: Text(
                              'Guardar',
                              style: TextStyle(color: Colors.white, fontSize: ScreenUtil().setSp(17)),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: ScreenUtil().setHeight(50),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              (data) ? _mostrarAlert(responsive) : Container()
            ],
          );
        },
      ),
    );
  }

  Widget _mostrarAlert(Responsive responsive) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: Colors.white.withOpacity(.5),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: CupertinoActivityIndicator(),
            ),
            Text(
              'Enviando',
              //'${snapshot.data}.toInt()%',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: responsive.ip(2.4),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _selectdate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      firstDate: DateTime(DateTime.now().month - 1),
      initialDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 2),
    );

    print('date $picked');

    setState(() {
      fechaCompraDato =
          "${picked!.year.toString().padLeft(2, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
    });
  }
}

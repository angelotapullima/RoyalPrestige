import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:royal_prestige/src/model/cliente_model.dart';
import 'package:royal_prestige/src/pages/Compras/search_product.dart';
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
  String fechaPagoDato = 'Seleccionar';
  String fechaCompraDato = 'Seleccionar';
  String horaCompraDato = 'Seleccionar';
  TextEditingController _montoCuotaController = TextEditingController();
  TextEditingController _observacionController = TextEditingController();
  String nombreProducto = '';
  String idProducto = '';

  @override
  void dispose() {
    _montoCuotaController.dispose();
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
              SingleChildScrollView(
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
                        ' Nombre de producto',
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(16),
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(
                        height: ScreenUtil().setHeight(6),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (context, animation, secondaryAnimation) {
                                return SearchProducto();
                              },
                              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                var begin = Offset(0.0, 1.0);
                                var end = Offset.zero;
                                var curve = Curves.ease;

                                var tween = Tween(begin: begin, end: end).chain(
                                  CurveTween(curve: curve),
                                );

                                return SlideTransition(
                                  position: animation.drive(tween),
                                  child: child,
                                );
                              },
                            ),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: ScreenUtil().setWidth(10),
                            vertical: ScreenUtil().setHeight(15),
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          width: double.infinity,
                          height: ScreenUtil().setHeight(55),
                          child: Text(
                            (idProducto != '') ? nombreProducto : 'Buscar producto',
                            style: TextStyle(color: (idProducto != '') ? Colors.black : Colors.grey.shade700),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: ScreenUtil().setHeight(20),
                      ),
                      Text(
                        ' Monto por cuota ',
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
                        controller: _montoCuotaController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Monto cuota ',
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
                            _selectdatePago(context);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Text(
                                  fechaPagoDato,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: (fechaPagoDato != 'Seleccionar Todos') ? Color(0xff5a5a5a) : colorPrimary,
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
                      Row(
                        children: [
                          Container(
                            width: responsive.wp(43),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
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
                              ],
                            ),
                          ),
                          Spacer(),
                          Container(
                            width: responsive.wp(43),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  ' Hora de Compra',
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
                                      _selectHora(context);
                                    },
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            horaCompraDato,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: (horaCompraDato != 'Seleccionar Todos') ? Color(0xff5a5a5a) : colorPrimary,
                                              fontSize: ScreenUtil().setSp(16),
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                        Icon(
                                          Icons.timelapse_outlined,
                                          color: colorPrimary,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
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
                        controller: _observacionController,
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
                            if (idProducto != '') {
                              if (_montoCuotaController.text.isNotEmpty) {
                                if (fechaPagoDato != 'Seleccionar') {
                                  if (fechaCompraDato != 'Seleccionar') {
                                    if (horaCompraDato != 'Seleccionar') {
                                      if (_observacionController.text.isNotEmpty) {
                                        _cargando.value = true;
                                        // final clienteApi = ClienteApi();

                                        // ClienteModel clienteModel = ClienteModel();
                                        // clienteModel.nombreCliente = _nombreController.text;
                                        // clienteModel.tipoDocCliente = valueTipoDoc;
                                        // clienteModel.nroDocCliente = _nroDocController.text;
                                        // clienteModel.sexoCliente = valueSexo;
                                        // clienteModel.nacimientoCLiente = fechaDato;
                                        // clienteModel.telefonoCliente = _telefonoController.text;
                                        // clienteModel.direccionCliente = _direccionController.text;

                                        // final res = await clienteApi.saveClient(clienteModel);

                                        // if (res) {
                                        //   showToast2('Cliente agregado correctamente', Colors.green);
                                        //   final clienteBloc = ProviderBloc.cliente(context);
                                        //   clienteBloc.getClientForTipo('1');
                                        //   clienteBloc.getClientForTipo('2');
                                        //   Navigator.pop(context);
                                        //   _cargando.value = false;
                                        // } else {
                                        //   showToast2('Ocurrió un error', Colors.red);
                                        //   _cargando.value = false;
                                        // }
                                      } else {
                                        showToast2('Por favor ingrese una observacion de la compra', Colors.red);
                                      }
                                    } else {
                                      showToast2('Por favor seleccione la hora de compra', Colors.red);
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
                              showToast2('Por favor seleccione un producto', Colors.red);
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

  _selectHora(BuildContext context) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    print('date $picked');

    setState(() {
      horaCompraDato = "${picked!.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}";
    });
  }

  _selectdatePago(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      firstDate: DateTime(DateTime.now().month - 1),
      initialDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 2),
    );

    print('date $picked');

    setState(() {
      fechaPagoDato =
          "${picked!.year.toString().padLeft(2, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
    });
  }
}

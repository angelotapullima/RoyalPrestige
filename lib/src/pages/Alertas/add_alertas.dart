import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:royal_prestige/src/api/alerta_api.dart';
import 'package:royal_prestige/src/bloc/provider_bloc.dart';
import 'package:royal_prestige/src/model/alert_model.dart';
import 'package:royal_prestige/src/model/cliente_model.dart';
import 'package:royal_prestige/src/utils/colors.dart';
import 'package:royal_prestige/src/utils/responsive.dart';
import 'package:royal_prestige/src/utils/utils.dart';

class AddAlertas extends StatefulWidget {
  const AddAlertas({Key? key}) : super(key: key);

  @override
  State<AddAlertas> createState() => _AddAlertasState();
}

class _AddAlertasState extends State<AddAlertas> {
  ValueNotifier<bool> _cargando = ValueNotifier(false);
  String fechaDato = 'Seleccionar';
  String horaDato = 'Seleccionar';
  TextEditingController _tituloController = TextEditingController();
  TextEditingController _detalleController = TextEditingController();

  @override
  void dispose() {
    _tituloController.dispose();
    _detalleController.dispose();
    super.dispose();
  }

  int clienteInt = 0;
  String dropClienteValue = 'Seleccionar';
  String idCliente = '';
  List<String> clienteList = [];

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    final clienteBloc = ProviderBloc.cliente(context);
    clienteBloc.getClientForTipo('1');
    clienteBloc.getClientForTipo('2');

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          'Nueva Alerta',
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
                        ' Cliente',
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(16),
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(
                        height: ScreenUtil().setHeight(6),
                      ),
                      StreamBuilder(
                        stream: clienteBloc.clienteStream,
                        builder: (BuildContext context, AsyncSnapshot<List<ClienteModel>> snapshot) {
                          if (snapshot.hasData) {
                            if (snapshot.data!.length > 0) {
                              if (clienteInt == 0) {
                                clienteList.clear();

                                clienteList.add('Seleccionar');
                                for (int i = 0; i < snapshot.data!.length; i++) {
                                  String nombreCanchas = snapshot.data![i].nombreCliente.toString();
                                  clienteList.add(nombreCanchas);
                                }
                              }

                              final valorLista = clienteList.toSet().toList();
                              return dropCliente(valorLista, snapshot.data!);
                            } else {
                              return Container();
                            }
                          } else {
                            return Container();
                          }
                        },
                      ),
                      SizedBox(
                        height: ScreenUtil().setHeight(20),
                      ),
                      Text(
                        ' Título',
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
                        controller: _tituloController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Documento ',
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
                        ' Detalle',
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
                        controller: _detalleController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: ' Teléfono',
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
                      Row(
                        children: [
                          Container(
                            width: responsive.wp(43),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  ' Fecha',
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
                                            fechaDato,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: (fechaDato != 'Seleccionar Todos') ? Color(0xff5a5a5a) : colorPrimary,
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
                                  ' Hora',
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
                                      _selecttime(context);
                                    },
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            horaDato,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: (horaDato != 'Seleccionar Todos') ? Color(0xff5a5a5a) : colorPrimary,
                                              fontSize: ScreenUtil().setSp(16),
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                        Icon(
                                          Icons.lock_clock,
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
                      SizedBox(
                        width: double.infinity,
                        child: MaterialButton(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          color: colorPrimary,
                          onPressed: () async {
                            if (_tituloController.text.isNotEmpty) {
                              if (_detalleController.text.isNotEmpty) {
                                if (idCliente.isNotEmpty) {
                                  if (fechaDato != 'Seleccionar') {
                                    if (horaDato != 'Seleccionar') {
                                      _cargando.value = true;
                                      final alertApi = AlertApi();

                                      AlertModel alertModel = AlertModel();
                                      alertModel.alertTitle = _tituloController.text;
                                      alertModel.alertDetail = _detalleController.text;
                                      alertModel.idClient = idCliente;
                                      alertModel.alertDate = fechaDato;
                                      alertModel.alertHour = horaDato;

                                      final res = await alertApi.saveAlert(alertModel);

                                      if (res) {
                                        _cargando.value = false;
                                        Navigator.pop(context);
                                        showToast2('alerta guardada correctamente', Colors.green);
                                      } else {
                                        _cargando.value = false;
                                        showToast2('ocurrio un error', Colors.red);
                                      }
                                    } else {
                                      showToast2('Por favor ingrese una fecha', Colors.red);
                                    }
                                  } else {
                                    showToast2('Por favor ingrese una fecha', Colors.red);
                                  }
                                } else {
                                  showToast2('Por favor seleccione el cliente', Colors.red);
                                }
                              } else {
                                showToast2('Por favor ingrese el detalle de la alerta', Colors.red);
                              }
                            } else {
                              showToast2('Por favor ingrese el titulo de la alerta', Colors.red);
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

  Widget dropCliente(List<String> lista, List<ClienteModel> cliente) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ScreenUtil().setWidth(5),
      ),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
        border: Border.all(
          color: Colors.grey.shade300,
        ),
      ),
      child: DropdownButton<String>(
        dropdownColor: Colors.white,
        value: dropClienteValue,
        icon: Icon(Icons.arrow_drop_down),
        iconSize: ScreenUtil().setSp(20),
        elevation: 16,
        isExpanded: true,
        style: TextStyle(
          color: Colors.black,
          fontSize: ScreenUtil().setSp(16),
        ),
        underline: Container(),
        onChanged: (String? data) {
          setState(() {
            dropClienteValue = data.toString();
            clienteInt++;

            obtenerIdCliente(data!, cliente);
          });
        },
        items: lista.map((value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              maxLines: 3,
              style: TextStyle(color: Colors.black),
              overflow: TextOverflow.ellipsis,
            ),
          );
        }).toList(),
      ),
    );
  }

  void obtenerIdCliente(String dato, List<ClienteModel> list) {
    if (dato == 'Seleccionar') {
      idCliente = 'Seleccionar';
    } else {
      for (int i = 0; i < list.length; i++) {
        if (dato == list[i].nombreCliente) {
          idCliente = list[i].idCliente.toString();
        }
      }
    }
    print(idCliente);
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
      fechaDato = "${picked!.year.toString().padLeft(2, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      //inputfieldDateController.text = fechaDato;

      print(fechaDato);
    });
  }

  _selecttime(BuildContext context) async {
    TimeOfDay? picked = await showTimePicker(context: context, initialTime: TimeOfDay.now());

    print('date $picked');

    setState(() {
      horaDato = "${picked!.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}";
      //inputfieldDateController.text = fechaDato;

      print(horaDato);
    });
  }
}

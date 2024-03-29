import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:royal_prestige/src/api/cliente_api.dart';
import 'package:royal_prestige/src/bloc/provider_bloc.dart';
import 'package:royal_prestige/src/model/cliente_model.dart';
import 'package:royal_prestige/src/utils/colors.dart';
import 'package:royal_prestige/src/utils/responsive.dart';
import 'package:royal_prestige/src/utils/utils.dart';

class AgregarCliente extends StatefulWidget {
  const AgregarCliente({Key? key}) : super(key: key);

  @override
  State<AgregarCliente> createState() => _AgregarClienteState();
}

class _AgregarClienteState extends State<AgregarCliente> {
  ValueNotifier<bool> _cargando = ValueNotifier(false);
  String fechaDato = 'Seleccionar';
  TextEditingController _nombreController = TextEditingController();
  TextEditingController _nroDocController = TextEditingController();
  TextEditingController _codigoClienteController = TextEditingController();

  TextEditingController _telefonoController = TextEditingController();
  TextEditingController _direccionController = TextEditingController();

  FocusNode _focusNombre = FocusNode();
  FocusNode _focusNroDoc = FocusNode();
  FocusNode _focusCodCliente = FocusNode();
  FocusNode _focusTelefono = FocusNode();
  FocusNode _focusDireccion = FocusNode();

  @override
  void dispose() {
    _nombreController.dispose();
    _nroDocController.dispose();
    _telefonoController.dispose();
    _direccionController.dispose();
    _codigoClienteController.dispose();
    super.dispose();
  }

  String valueTipoDoc = 'Seleccionar';
  List<String> itemTipoDoc = [
    'Seleccionar',
    'DNI',
    'RUC',
    'CARNET DE EXTRANJERÍA',
  ];

  String valueSexo = 'Seleccionar';
  List<String> itemSexo = [
    'Seleccionar',
    'M',
    'F',
  ];

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          'Nuevo Cliente',
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
                      focusNode: _focusNombre,
                      toolbarButtons: [
                        (node) {
                          return closeNode(node);
                        }
                      ],
                    ),
                    KeyboardActionsItem(
                      focusNode: _focusNroDoc,
                      toolbarButtons: [
                        (node) {
                          return closeNode(node);
                        }
                      ],
                    ),
                    KeyboardActionsItem(
                      focusNode: _focusCodCliente,
                      toolbarButtons: [
                        (node) {
                          return closeNode(node);
                        }
                      ],
                    ),
                    KeyboardActionsItem(
                      focusNode: _focusTelefono,
                      toolbarButtons: [
                        (node) {
                          return closeNode(node);
                        }
                      ],
                    ),
                    KeyboardActionsItem(
                      focusNode: _focusDireccion,
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
                          ' Nombre de cliente',
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
                          controller: _nombreController,
                          focusNode: _focusNombre,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'Nombre ',
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
                          ' Tipo de documento',
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(16),
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(
                          height: ScreenUtil().setHeight(6),
                        ),
                        dropTipoDoc(),
                        SizedBox(
                          height: ScreenUtil().setHeight(20),
                        ),
                        Text(
                          ' Nro. de documento',
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
                          controller: _nroDocController,
                          focusNode: _focusNroDoc,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'Documento',
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
                          ' Código de cliente',
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
                          controller: _codigoClienteController,
                          focusNode: _focusCodCliente,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'Código de cliente',
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
                                    ' Sexo',
                                    style: TextStyle(
                                      fontSize: ScreenUtil().setSp(16),
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(
                                    height: ScreenUtil().setHeight(6),
                                  ),
                                  dropSexo(),
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
                                    ' Fecha de Nacimiento',
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
                          ],
                        ),
                        SizedBox(
                          height: ScreenUtil().setHeight(20),
                        ),
                        Text(
                          ' Teléfono',
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
                          controller: _telefonoController,
                          focusNode: _focusTelefono,
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
                        Text(
                          ' Dirección',
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
                          controller: _direccionController,
                          focusNode: _focusDireccion,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'Dirección ',
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
                              if (_nombreController.text.isNotEmpty) {
                                _cargando.value = true;
                                final clienteApi = ClienteApi();

                                ClienteModel clienteModel = ClienteModel();
                                clienteModel.nombreCliente = _nombreController.text;

                                if (valueTipoDoc == 'Seleccionar') {
                                  clienteModel.tipoDocCliente = '';
                                } else {
                                  clienteModel.tipoDocCliente = valueTipoDoc;
                                }
                                clienteModel.nroDocCliente = _nroDocController.text;
                                clienteModel.codigoCliente = _codigoClienteController.text;
                                if (valueSexo == 'Seleccionar') {
                                  clienteModel.sexoCliente = '';
                                } else {
                                  clienteModel.sexoCliente = valueSexo;
                                }

                                clienteModel.nacimientoCLiente = fechaDato;
                                clienteModel.telefonoCliente = _telefonoController.text;
                                clienteModel.direccionCliente = _direccionController.text;

                                final res = await clienteApi.saveClient(clienteModel);

                                if (res.code == '1') {
                                  showToast2('Cliente agregado correctamente', Colors.green);
                                  final clienteBloc = ProviderBloc.cliente(context);
                                  clienteBloc.getClientForTipo('1');
                                  clienteBloc.getClientForTipo('2');
                                  Navigator.pop(context);
                                  _cargando.value = false;
                                } else {
                                  showToast2('${res.message}', Colors.red);
                                  _cargando.value = false;
                                }
                                // if (valueTipoDoc != 'Seleccionar') {
                                //   if (_nroDocController.text.isNotEmpty) {
                                //     if (valueSexo != 'Seleccionar') {
                                //       if (_telefonoController.text.isNotEmpty) {
                                //         if (fechaDato != 'Seleccionar') {
                                //           if (_direccionController.text.isNotEmpty) {

                                //           } else {
                                //             showToast2('Por favor ingrese una Dirección del cliente', Colors.red);
                                //           }
                                //         } else {
                                //           showToast2('Por favor ingrese la fecha de nacimiento del cliente', Colors.red);
                                //         }
                                //       } else {
                                //         showToast2('Por favor ingrese el nro de teléfono del cliente', Colors.red);
                                //       }
                                //     } else {
                                //       showToast2('Por favor seleccione el sexo del cliente', Colors.red);
                                //     }
                                //   } else {
                                //     showToast2('Por favor ingrese el nro de documento del cliente', Colors.red);
                                //   }
                                // } else {
                                //   showToast2('Por favor seleccione el tipo de documento', Colors.red);
                                // }
                              } else {
                                showToast2('Por favor ingrese el nombre del cliente', Colors.red);
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

  Widget dropTipoDoc() {
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
          )),
      child: DropdownButton<String>(
        dropdownColor: Colors.white,
        value: valueTipoDoc,
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
            valueTipoDoc = data.toString();

            //obtenerIdNegocios(data, ciudades);
          });
        },
        items: itemTipoDoc.map((value) {
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

  Widget dropSexo() {
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
          )),
      child: DropdownButton<String>(
        dropdownColor: Colors.white,
        value: valueSexo,
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
            valueSexo = data.toString();

            //obtenerIdNegocios(data, ciudades);
          });
        },
        items: itemSexo.map((value) {
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
}

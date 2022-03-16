/* import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path/path.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:royal_prestige/core/sharedpreferences/storage_manager.dart';
import 'package:royal_prestige/src/bloc/provider_bloc.dart';
import 'package:royal_prestige/src/utils/constants.dart';
import 'package:royal_prestige/src/utils/responsive.dart';
import 'package:royal_prestige/src/utils/utils.dart';

class NuevoDocumento extends StatefulWidget {
  const NuevoDocumento({
    Key? key,
  }) : super(key: key);

  @override
  _NuevoDocumentoState createState() => _NuevoDocumentoState();
}

class _NuevoDocumentoState extends State<NuevoDocumento> {
  TextEditingController _tituloController = new TextEditingController();
  TextEditingController _descripcionController = new TextEditingController();
  TextEditingController _documentController = new TextEditingController();

  late File selectedfile;
  late Response response;
  late String progress;
  late Dio dio = new Dio();

  @override
  void dispose() {
    _tituloController.dispose();
    _descripcionController.dispose();
    _documentController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _documentController.text = 'Seleccione documento';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UploapBloc>(context, listen: false);
    final responsive = Responsive.of(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          'Nuevo Documento',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: ScreenUtil().setWidth(20),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: ScreenUtil().setHeight(20),
              ),
              Text(
                'Información del documento',
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(19),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: ScreenUtil().setHeight(20),
              ),
              Container(
                width: responsive.wp(90),
                child: TextField(
                  controller: _tituloController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Título',
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
              ),
              SizedBox(
                height: ScreenUtil().setHeight(20),
              ),
              Container(
                width: responsive.wp(90),
                child: TextField(
                  controller: _descripcionController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Descripción',
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
              ),
              SizedBox(
                height: ScreenUtil().setHeight(20),
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: ScreenUtil().setWidth(10),
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextButton(
                  onPressed: () async {
                    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();

                    if (selectedDirectory == null) {
                      // User canceled the picker
                    }

                    FilePickerResult? result = await FilePicker.platform.pickFiles();

                    if (result != null) {
                      selectedfile = File(result.files.single.path.toString());
                      print('file ${selectedfile.path}');

                      setState(() {
                        _documentController.text = '${selectedfile.path}';
                      });
                    } else {
                      // User canceled the picker
                    }
                  },
                  child: Row(
                    children: [
                      Container(
                        height: ScreenUtil().setSp(35),
                        width: ScreenUtil().setSp(35),
                        child: SvgPicture.asset(
                          'assets/svg/folder_rojo.svg',
                        ),
                      ),
                      SizedBox(
                        width: ScreenUtil().setWidth(10),
                      ),
                      Expanded(
                        child: Text(
                          '${_documentController.text}',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: ScreenUtil().setHeight(40),
              ),
              InkWell(
                onTap: () {
                  if (_tituloController.text.isNotEmpty) {
                    if (_descripcionController.text.isNotEmpty) {
                      if (_documentController.text.isNotEmpty && _documentController.text != 'Seleccione documento') {
                        uploadFile(
                          selectedfile,
                          _tituloController.text,
                          _descripcionController.text,
                          provider,
                          context,
                        );
                      } else {
                        showToast2('Seleccione un  documento', Colors.red);
                      }
                    } else {
                      showToast2('Ingrese la descripción del producto ', Colors.red);
                    }
                  } else {
                    showToast2('ingrese el título del documento', Colors.red);
                  }
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(8)),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    border: Border.all(color: Colors.transparent),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  width: double.infinity,
                  child: Center(
                    child: Text(
                      'Enviar',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: ScreenUtil().setSp(20),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: ScreenUtil().setHeight(40),
              ),
              ValueListenableBuilder(
                  valueListenable: provider.cargando,
                  builder: (BuildContext context, double data, Widget? child) {
                    print('data $data');
                    return (data == 0.0)
                        ? Container()
                        : (data == 100.0)
                            ? Container(
                                margin: EdgeInsets.symmetric(horizontal: responsive.wp(5)),
                                padding: EdgeInsets.symmetric(vertical: responsive.hp(.5)),
                                decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(10)),
                                child: Center(
                                  child: Text(
                                    'Carga  completa',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ))
                            : Padding(
                                padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(10)),
                                child: Container(
                                  height: ScreenUtil().setHeight(40),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text('$data %'),
                                      LinearPercentIndicator(
                                        width: responsive.wp(70),
                                        lineHeight: 14.0,
                                        percent: data / 100,
                                        backgroundColor: Colors.white,
                                        progressColor: Colors.blue,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                  }),
              SizedBox(
                height: ScreenUtil().setHeight(40),
              ),
            ],
          ),
        ),
      ),
    );
  }

  uploadFile(
    File _fileUploap,
    String titulo,
    String descripcion,
    UploapBloc provider,
    BuildContext context,
  ) async {
    String? token = await StorageManager.readData('token');
    String uploadurl = "$apiBaseURL/api/Productos/guardar_documento";
    //dont use http://localhost , because emulator don't get that address
    //insted use your local IP address or use live URL
    //hit "ipconfig" in windows or "ip a" in linux to get you local IP

    FormData formdata = FormData.fromMap({
      "documento_file": await MultipartFile.fromFile(_fileUploap.path, filename: basename(_fileUploap.path)
          //show only filename from path
          ),
      "app": "true",
      "tn": "$token",
      "documento_titulo": "$titulo",
      "documento_descripcion": "$descripcion",
      "documento_estado": "1",
    });

    response = await dio.post(
      uploadurl,
      data: formdata,
      onSendProgress: (int sent, int total) {
        String percentage = (sent / total * 100).toStringAsFixed(2);

        progress = "$sent" + " Bytes of " "$total Bytes - " + percentage + " % uploaded";
        print('progress $progress');
        provider._cargando.value = double.parse(percentage);
        //update the progress
      },
    );

    if (response.statusCode == 200) {
      print(response.toString());

      final documentBloc = ProviderBloc.document(context);
      documentBloc.getDocument();

      /*   final documentosOCBloc = ProviderBloc.docOC(context);

      documentosOCBloc.obtenerDocumentos(widget.idOC.toString()); */
      Navigator.pop(context);
      //print response from server
    } else {
      print("Error during connection to server.");
    }
  }
}

class UploapBloc with ChangeNotifier {
  ValueNotifier<double> _cargando = ValueNotifier(0.0);
  ValueNotifier<double> get cargando => this._cargando;

  BuildContext? context;

  UploapBloc({this.context}) {
    _init();
  }
  void _init() {}

  void changeInicio() {
    _cargando.value = 0.0;
    notifyListeners();
  }

  void changeFinish() {
    _cargando.value = 100.0;
    notifyListeners();
  }
}
 */
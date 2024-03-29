import 'dart:io';

import 'package:flowder/flowder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:royal_prestige/database/document_database.dart';
import 'package:royal_prestige/src/bloc/provider_bloc.dart';
import 'package:royal_prestige/src/model/document_model.dart';
import 'package:royal_prestige/src/utils/constants.dart';
import 'package:royal_prestige/src/utils/responsive.dart';

class DocumentosPage extends StatefulWidget {
  const DocumentosPage({Key? key}) : super(key: key);

  @override
  State<DocumentosPage> createState() => _DocumentosPageState();
}

class _DocumentosPageState extends State<DocumentosPage> {
  late DownloaderUtils options;
  late DownloaderCore core;
  int valor = 0;

  @override
  Widget build(BuildContext context) {
    final documentBloc = ProviderBloc.document(context);
    documentBloc.getDocument();

    final responsive = Responsive.of(context);
    final provider = Provider.of<DocumentsBloc>(context, listen: false);
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              height: double.infinity,
              width: double.infinity,
              color: Colors.white,
            ),
            Column(
              children: [
                Container(
                  height: ScreenUtil().setHeight(60),
                  padding: EdgeInsets.symmetric(
                    horizontal: ScreenUtil().setWidth(10),
                    vertical: ScreenUtil().setHeight(5),
                  ),
                  child: Row(
                    children: [
                      Text(
                        'Documentos complementarios',
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(20),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Spacer(),
                    ],
                  ),
                ),
                Expanded(
                  child: StreamBuilder(
                    stream: documentBloc.documentStream,
                    builder: (context, AsyncSnapshot<List<DocumentModel>> snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data!.length > 0) {
                          return Container(
                            width: double.infinity,
                            child: GridView.builder(
                                shrinkWrap: true,
                                padding: EdgeInsets.symmetric(
                                  horizontal: ScreenUtil().setWidth(5),
                                ),
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  childAspectRatio: 1.4,
                                  crossAxisCount: 2,
                                  mainAxisSpacing: responsive.hp(2),
                                  crossAxisSpacing: responsive.wp(3),
                                ),
                                itemCount: snapshot.data!.length,
                                itemBuilder: (context, index) {
                                  int randomNumber = 0;

                                  final fechaFormat = snapshot.data![index].documentFile!.split(".");
                                  var algo = fechaFormat.length - 1;

                                  if (fechaFormat[algo] == 'xlsx') {
                                    randomNumber = 3;
                                  } else if (fechaFormat[algo] == 'pdf') {
                                    randomNumber = 2;
                                  } else if (fechaFormat[algo] == 'docx') {
                                    randomNumber = 1;
                                  }

                                  return itemDatos(snapshot.data![index], randomNumber, provider);
                                }),
                          );
                        } else {
                          return Text('No existen documentos');
                        }
                      } else {
                        return CircularProgressIndicator();
                      }
                    },
                  ),
                ),
                /*   SizedBox(
                  height: ScreenUtil().setHeight(10),
                ),
                Container(
                  height: ScreenUtil().setHeight(60),
                  padding: EdgeInsets.symmetric(
                    horizontal: ScreenUtil().setWidth(10),
                    vertical: ScreenUtil().setHeight(5),
                  ),
                  child: Row(
                    children: [
                      Text(
                        'Alertas',
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(24),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Spacer(),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (context, animation, secondaryAnimation) {
                                return AddAlertas();
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
                          decoration: BoxDecoration(
                            color: Colors.blue[600],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(10), vertical: ScreenUtil().setHeight(5)),
                          child: Text(
                            'Agregar',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                StreamBuilder(
                  stream: alertBloc.alertsStream,
                  builder: (BuildContext context, AsyncSnapshot<List<AlertModel>> snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data!.length > 0) {
                        return Expanded(
                          child: ListView.builder(
                            padding: EdgeInsets.only(
                              top: ScreenUtil().setHeight(10),
                            ),
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: ScreenUtil().setWidth(16),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${snapshot.data![index].alertTitle}',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: ScreenUtil().setSp(20),
                                                ),
                                              ),
                                              Text('${snapshot.data![index].alertDetail}'),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: ScreenUtil().setWidth(10),
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${obtenerFechaString('${snapshot.data![index].alertDate}')}',
                                              style: TextStyle(color: colorPrimary),
                                            ),
                                            Text('${snapshot.data![index].alertHour}'),
                                          ],
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
                      } else {
                        return Center(
                          child: Text('No tiene Alertas'),
                        );
                      }
                    } else {
                      return CupertinoActivityIndicator();
                    }
                  },
                ),
              */
              ],
            ),
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: ValueListenableBuilder(
                valueListenable: provider.cargando,
                builder: (BuildContext context, double data, Widget? child) {
                  return (data == 0.0)
                      ? Container()
                      : (data == 100.0)
                          ? Container(
                              margin: EdgeInsets.symmetric(horizontal: responsive.wp(5)),
                              padding: EdgeInsets.symmetric(vertical: responsive.hp(.5)),
                              decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(10)),
                              child: Center(
                                child: Text(
                                  'Descarga  completa',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ))
                          : Padding(
                              padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(10)),
                              child: Container(
                                height: ScreenUtil().setHeight(40),
                                child: Column(
                                  children: [
                                    Text('Descargando $data%'),
                                    LinearPercentIndicator(
                                      width: responsive.wp(90),
                                      lineHeight: 14.0,
                                      percent: data / 100,
                                      backgroundColor: Colors.white,
                                      progressColor: Colors.blue,
                                    ),
                                  ],
                                ),
                              ),
                            );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget itemDatos(DocumentModel documento, int tipo, DocumentsBloc provider) {
    var svg = 'assets/svg/folder_azul.svg';
    Color col = Color(0xffeef7fe);
    Color colMore = Color(0xff415eb6);

    if (tipo == 1) {
      svg = 'assets/svg/folder_azul.svg';
      col = Color(0xffeef7fe);
      colMore = Color(0xff415eb6);
    } else if (tipo == 0) {
      svg = 'assets/svg/folder_amarillo.svg';
      col = Color(0xfffffbec);
      colMore = Color(0xffffb110);
    } else if (tipo == 2) {
      svg = 'assets/svg/folder_rojo.svg';
      col = Color(0xfffeeeee);
      colMore = Color(0xffac4040);
    } else if (tipo == 3) {
      svg = 'assets/svg/folder_cyan.svg';
      col = Color(0xfff0ffff);
      colMore = Color(0xff23b0b0);
    }
    return InkWell(
      onTap: () async {
        try {
          await new Future.delayed(new Duration(seconds: 1));
          await [
            Permission.location,
            Permission.storage,
          ].request();
          var checkResult = await Permission.storage.status;

          if (checkResult.isGranted) {
            /* var dir = await getExternalStorageDirectory();
                var testdir = await Directory('${dir!.path}/SOAL').create(recursive: true);  */
            if (Platform.isIOS) {
              final documentDatabase = DocumentDatabase();

              final res = await documentDatabase.getDocumentForId(documento.idDocument.toString());

              if (res[0].documentUrlInterno != 'null' && res[0].documentUrlInterno!.isNotEmpty) {
                print('${res[0].documentUrlInterno}');

                final _result = OpenFile.open(res[0].documentUrlInterno).whenComplete(() {
                  print('completado csmare');
                });
                print(_result);
              } else {
                final testdir = (await getApplicationDocumentsDirectory()).path;

                options = DownloaderUtils(
                  progressCallback: (current, total) {
                    provider.cargando.value = double.parse((current / total * 100).toStringAsFixed(2));
                  },
                  file: File('/$testdir/${documento.documentFile}'),
                  progress: ProgressImplementation(),
                  onDone: () async {
                    DocumentModel documentModel = DocumentModel();
                    documentModel.idDocument = documento.idDocument;
                    documentModel.documentDescripcion = documento.documentDescripcion;
                    documentModel.documentEstado = documento.documentEstado;
                    documentModel.documentFile = documento.documentFile;
                    documentModel.documentTitulo = documento.documentTitulo;
                    documentModel.documentUrlInterno = '$testdir/${documento.documentFile}';

                    await documentDatabase.insertDocument(documentModel);
                    print('COMPLETE $testdir/${documento.documentFile}');
                    OpenFile.open('$testdir/${documento.documentFile}');

                    provider.changeFinish();
                  },
                  deleteOnCancel: true,
                );
                //core = await Flowder.download('http://ipv4.download.thinkbroadband.com/5MB.zip', options);
                core = await Flowder.download('$apiBaseURL/${documento.documentFile}', options);

                print(core);
              }
            } else {
              final documentDatabase = DocumentDatabase();

              final res = await documentDatabase.getDocumentForId(documento.idDocument.toString());

              if (res[0].documentUrlInterno != 'null' && res[0].documentUrlInterno!.isNotEmpty) {
                OpenFile.open(res[0].documentUrlInterno);
              } else {
                final testdir = (await getApplicationDocumentsDirectory()).path;

                options = DownloaderUtils(
                  progressCallback: (current, total) {
                    provider.cargando.value = double.parse((current / total * 100).toStringAsFixed(2));
                  },
                  file: File('/$testdir/${documento.documentFile}'),
                  progress: ProgressImplementation(),
                  onDone: () async {
                    DocumentModel documentModel = DocumentModel();
                    documentModel.idDocument = documento.idDocument;
                    documentModel.documentDescripcion = documento.documentDescripcion;
                    documentModel.documentEstado = documento.documentEstado;
                    documentModel.documentFile = documento.documentFile;
                    documentModel.documentTitulo = documento.documentTitulo;
                    documentModel.documentUrlInterno = '$testdir/${documento.documentFile}';

                    await documentDatabase.insertDocument(documentModel);
                    print('COMPLETE $testdir/${documento.documentFile}');
                    OpenFile.open('$testdir/${documento.documentFile}');

                    provider.changeFinish();
                  },
                  deleteOnCancel: true,
                );
                //core = await Flowder.download('http://ipv4.download.thinkbroadband.com/5MB.zip', options);
                core = await Flowder.download('$apiBaseURL/${documento.documentFile}', options);

                print(core);
              }
            }
          } else if (await Permission.storage.request().isPermanentlyDenied) {
            await openAppSettings();
          } else if (await Permission.storage.request().isDenied) {
            Map<Permission, PermissionStatus> statuses = await [
              Permission.location,
              Permission.storage,
            ].request();
            print(statuses[Permission.location]);
          }
        } catch (e) {
          print('$e');
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: col,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: ScreenUtil().setWidth(10),
          vertical: ScreenUtil().setHeight(10),
        ),
        margin: EdgeInsets.symmetric(
          horizontal: ScreenUtil().setWidth(10),
        ),
        width: ScreenUtil().setWidth(140),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: ScreenUtil().setSp(45),
              width: ScreenUtil().setSp(45),
              child: SvgPicture.asset(
                '$svg',
              ),
            ),
            SizedBox(
              height: ScreenUtil().setHeight(10),
            ),
            Text(
              '${documento.documentTitulo}',
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: colMore,
                fontWeight: FontWeight.bold,
                fontSize: ScreenUtil().setSp(13),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class DocumentsBloc with ChangeNotifier {
  ValueNotifier<double> _cargando = ValueNotifier(0.0);
  ValueNotifier<double> get cargando => this._cargando;

  BuildContext? context;

  DocumentsBloc({this.context}) {
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

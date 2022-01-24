import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:royal_prestige/core/sharedpreferences/storage_manager.dart';
import 'package:royal_prestige/src/bloc/productos_bloc.dart';
import 'package:royal_prestige/src/bloc/provider_bloc.dart';
import 'package:royal_prestige/src/model/categoria_model.dart';
import 'package:royal_prestige/src/utils/colors.dart';
import 'package:royal_prestige/src/utils/constants.dart';
import 'package:royal_prestige/src/utils/responsive.dart';
import 'package:royal_prestige/src/utils/utils.dart';

import 'package:path/path.dart';
import 'package:dio/dio.dart';

class AgregarProductosPage extends StatefulWidget {
  const AgregarProductosPage({Key? key}) : super(key: key);

  @override
  State<AgregarProductosPage> createState() => _AgregarProductosPageState();
}

class _AgregarProductosPageState extends State<AgregarProductosPage> {
  ValueNotifier<bool> _cargando = ValueNotifier(false);
  TextEditingController _nombreController = TextEditingController();
  TextEditingController _codigoController = TextEditingController();
  TextEditingController _precioController = TextEditingController();
  TextEditingController _descripcionController = TextEditingController();
  TextEditingController _regaloController = TextEditingController();
  TextEditingController _regaloPrecioController = TextEditingController();

  late File? _image = File('');
  final picker = ImagePicker();

  late Response response;
  late String progress;
  late Dio dio = new Dio();
  CancelToken cancelToken = CancelToken();

  Future getImageCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera, imageQuality: 70);

    if (pickedFile != null) {
      setState(
        () {
          _cropImage(pickedFile.path);
        },
      );
      //_cropImage(pickedFile.path);
    }
    /*setState(() {
      _image = File(pickedFile.path);
    });*/
  }

  Future getImageGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 70);

    if (pickedFile != null) {
      _cropImage(pickedFile.path);
      //_cropImage(pickedFile.path);
    }
    /**/
  }

  Future<Null> _cropImage(filePath) async {
    File? croppedImage = await ImageCropper.cropImage(
        sourcePath: filePath,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        aspectRatio: CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cortar Imagen',
            toolbarColor: Colors.green,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(minimumAspectRatio: 1.0, title: 'Cortar Imagen'));

    _image = croppedImage;
    setState(() {});
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _codigoController.dispose();
    _precioController.dispose();
    super.dispose();
  }

  int categoryInt = 0;
  String dropServicio3 = 'Seleccionar';
  String idCategory = '';
  List<String> categoryList = [];

  @override
  Widget build(BuildContext context) {
    final categoriasBloc = ProviderBloc.productos(context);
    categoriasBloc.obtenerCategorias();

    final responsive = Responsive.of(context);

    return Scaffold(
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Agregar productos',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: ScreenUtil().setSp(24),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: ScreenUtil().setHeight(25),
                      ),
                      Text(
                        'Nombre de producto',
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
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Nombre de producto',
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
                        height: ScreenUtil().setHeight(16),
                      ),
                      Text(
                        ' Categoría ',
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(16),
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(
                        height: ScreenUtil().setHeight(10),
                      ),
                      StreamBuilder(
                        stream: categoriasBloc.categoriaStream,
                        builder: (BuildContext context, AsyncSnapshot<List<CategoriaModel>> snapshot) {
                          if (snapshot.hasData) {
                            if (snapshot.data!.length > 0) {
                              if (categoryInt == 0) {
                                categoryList.clear();

                                categoryList.add('Seleccionar');
                                for (int i = 0; i < snapshot.data!.length; i++) {
                                  String nombreCanchas = snapshot.data![i].nombreCategoria.toString();
                                  categoryList.add(nombreCanchas);
                                }
                              }

                              final valorLista = categoryList.toSet().toList();
                              return dropCategories(valorLista, snapshot.data!);
                            } else {
                              return Container();
                            }
                          } else {
                            return Container();
                          }
                        },
                      ),
                      SizedBox(
                        height: ScreenUtil().setHeight(16),
                      ),
                      Row(
                        children: [
                          Container(
                            width: ScreenUtil().setWidth(160),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  ' Precio',
                                  style: TextStyle(
                                    fontSize: ScreenUtil().setSp(16),
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(
                                  height: ScreenUtil().setHeight(10),
                                ),
                                TextField(
                                  controller: _precioController,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    hintText: 'Precio',
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
                              ],
                            ),
                          ),
                          Spacer(),
                          Container(
                            width: ScreenUtil().setWidth(160),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  ' Código',
                                  style: TextStyle(
                                    fontSize: ScreenUtil().setSp(16),
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(
                                  height: ScreenUtil().setHeight(10),
                                ),
                                TextField(
                                  controller: _codigoController,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    hintText: 'Código',
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
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: ScreenUtil().setHeight(25),
                      ),
                      Text(
                        ' Regalo',
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
                        controller: _regaloController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Regalo',
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
                        height: ScreenUtil().setHeight(16),
                      ),
                      Text(
                        ' Precio del Regalo',
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
                        controller: _regaloPrecioController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Precio',
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
                        height: ScreenUtil().setHeight(16),
                      ),
                      Text(
                        ' Descripción',
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
                        controller: _descripcionController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Ingrese la descripción del producto',
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
                      Container(
                        width: double.infinity,
                        height: ScreenUtil().setHeight(300),
                        child: Stack(
                          children: [
                            (_image!.path.toString() == '')
                                ? InkWell(
                                    onTap: () {
                                      dialiogImage(context, responsive);
                                    },
                                    child: Center(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.withOpacity(0.2),
                                              spreadRadius: 2,
                                              blurRadius: 3,
                                              offset: Offset(0, 2), // changes position of shadow
                                            ),
                                          ],
                                        ),
                                        width: ScreenUtil().setWidth(300),
                                        height: ScreenUtil().setHeight(300),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.camera_alt,
                                              size: ScreenUtil().setSp(50),
                                            ),
                                            Text('Presione para agregar foto')
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                : InkWell(
                                    onTap: () {
                                      dialiogImage(context, responsive);
                                    },
                                    child: Center(
                                      child: Container(
                                        width: ScreenUtil().setWidth(300),
                                        height: ScreenUtil().setHeight(300),
                                        child: Container(
                                          child: Image.file(_image!),
                                          //radius: ScreenUtil().radius(300),
                                        ),
                                      ),
                                    ),
                                  ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: ScreenUtil().setHeight(60),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: MaterialButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          color: colorPrimary,
                          child: Text(
                            'Guardar',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            if (_nombreController.text.isNotEmpty) {
                              if (idCategory != 'Seleccionar') {
                                if (_precioController.text.isNotEmpty) {
                                  if (_codigoController.text.isNotEmpty) {
                                    if (_regaloController.text.isNotEmpty) {
                                      if (_regaloPrecioController.text.isNotEmpty) {
                                        if (_descripcionController.text.isNotEmpty) {
                                          _cargando.value = true;
                                          uploadFile(_image!, _codigoController.text, idCategory, _nombreController.text, _descripcionController.text,
                                              _precioController.text, _regaloController.text, _regaloPrecioController.text, categoriasBloc, context);
                                        } else {
                                          showToast2('Por favor ingrese una descripción del prodcuto', Colors.red);
                                        }
                                      } else {
                                        showToast2('Por favor ingrese el precio del regalo del prodcuto', Colors.red);
                                      }
                                    } else {
                                      showToast2('Por favor ingrese el regalo del prodcuto', Colors.red);
                                    }
                                  } else {
                                    showToast2('Por favor ingrese el código del prodcuto', Colors.red);
                                  }
                                } else {
                                  showToast2('Por favor ingrese el precio del prodcuto', Colors.red);
                                }
                              } else {
                                showToast2('Por favor seleccione la categoría del prodcuto', Colors.red);
                              }
                            } else {
                              showToast2('Por favor ingrese el nombre del prodcuto', Colors.red);
                            }
                          },
                        ),
                      ),
                      SizedBox(
                        height: ScreenUtil().setHeight(60),
                      ),
                    ],
                  ),
                ),
              ),
              (data) ? _mostrarAlert(categoriasBloc, responsive) : Container()
            ],
          );
        },
      ),
    );
  }

  Widget _mostrarAlert(ProductosBloc bottomNaviBloc, Responsive responsive) {
    return StreamBuilder(
      stream: bottomNaviBloc.subidaImagenStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
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
                    '${(snapshot.data)}%',
                    //'${snapshot.data}.toInt()%',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: responsive.ip(2.4),
                    ),
                  ),
                  SizedBox(
                    height: responsive.hp(10),
                  ),
                  MaterialButton(
                    color: Colors.red,
                    onPressed: () {
                      cancelToken.cancel('cancelled');
                      _cargando.value = false;
                    },
                    child: Text(
                      'Cancelar petición',
                      //'${snapshot.data}.toInt()%',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: responsive.ip(1.8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }

  void obtenerIdCategoria(String dato, List<CategoriaModel> list) {
    if (dato == 'Seleccionar') {
      idCategory = 'Seleccionar';
    } else {
      for (int i = 0; i < list.length; i++) {
        if (dato == list[i].nombreCategoria) {
          idCategory = list[i].idCategoria.toString();
        }
      }
    }
    print(idCategory);
  }

  Future<dynamic> dialiogImage(BuildContext context, Responsive responsive) {
    return showDialog(
      barrierDismissible: true,
      context: context,
      builder: (_) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
          contentPadding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
          content: Container(
            width: responsive.wp(90),
            height: responsive.hp(28),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: responsive.wp(2)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Seleccionar Foto',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: ScreenUtil().setSp(20),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Divider(),
                  InkWell(
                    onTap: () {
                      getImageCamera();
                      Navigator.pop(context);
                    },
                    child: Row(
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(
                            vertical: responsive.hp(1),
                          ),
                          width: responsive.ip(4.5),
                          height: responsive.ip(4.5),
                          child: Image(
                            image: AssetImage('assets/img/foto.png'),
                          ),
                        ),
                        SizedBox(
                          width: ScreenUtil().setWidth(20),
                        ),
                        Expanded(
                          child: Text('Desde la cámara'),
                        )
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      getImageGallery();
                      Navigator.pop(context);
                    },
                    child: Row(
                      children: [
                        Container(
                            margin: EdgeInsets.symmetric(
                              vertical: responsive.hp(1),
                            ),
                            width: responsive.ip(4.5),
                            height: responsive.ip(4.5),
                            child: SvgPicture.asset('assets/svg/GALERIA.svg') //Image.asset('assets/logo_largo.svg'),
                            ),
                        SizedBox(
                          width: ScreenUtil().setWidth(20),
                        ),
                        Expanded(
                          child: Text('Desde la galería'),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget dropCategories(List<String> lista, List<CategoriaModel> categories) {
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
        value: dropServicio3,
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
            dropServicio3 = data.toString();
            categoryInt++;

            obtenerIdCategoria(data!, categories);
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

  uploadFile(
    File _imageLlega,
    String codigo,
    String idCategoria,
    String nombre,
    String descripcion,
    String precio,
    String regalo,
    String regaloPrecio,
    ProductosBloc provider,
    BuildContext context,
  ) async {
    String? token = await StorageManager.readData('token');
    String uploadurl = "$apiBaseURL/api/Productos/guardar_producto";
    //dont use http://localhost , because emulator don't get that address
    //insted use your local IP address or use live URL
    //hit "ipconfig" in windows or "ip a" in linux to get you local IP

    FormData formdata = FormData.fromMap({
      "producto_foto": await MultipartFile.fromFile(_imageLlega.path, filename: basename(_imageLlega.path)
          //show only filename from path
          ),
      "app": "true",
      "tn": "$token",
      "producto_codigo": "$codigo",
      "producto_nombre": "$nombre",
      "id_categoria": "$idCategoria",
      "producto_descripcion": "$descripcion",
      "producto_precio": "$precio",
      "producto_regalo": '$regalo',
      "producto_regalo_precio": '$regaloPrecio',
      "producto_estado": '1',
    });

    response = await dio.post(
      uploadurl,
      data: formdata,
      cancelToken: cancelToken,
      onSendProgress: (int sent, int total) {
        String percentage = (sent / total * 100).toStringAsFixed(2);

        progress = "$sent" + " Bytes of " "$total Bytes - " + percentage + " % uploaded";
        print('progress $progress');
        provider.changeSubidaImagen(
          double.parse(percentage),
        );
        //update the progress
      },
    );

    if (response.statusCode == 200) {
      print(response.toString());
      _cargando.value = false;

      final categoriasBloc = ProviderBloc.productos(context);

      categoriasBloc.obtenerProductosByIdCategoria(idCategoria);

      _nombreController.text = '';
      _precioController.text = '';
      _codigoController.text = '';
      _regaloPrecioController.text = '';
      _regaloController.text = '';
      _descripcionController.text = '';

      dropServicio3 = 'Seleccionar';
      _image = File('');
      idCategory = 'Seleccionar';

      setState(() {});
    } else {
      print("Error during connection to server.");
      _cargando.value = false;
    }
  }
}

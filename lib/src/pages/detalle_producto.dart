import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:royal_prestige/database/cart_database.dart';
import 'package:royal_prestige/src/api/productos_api.dart';
import 'package:royal_prestige/src/bloc/provider_bloc.dart';
import 'package:royal_prestige/src/model/cart_model.dart';
import 'package:royal_prestige/src/model/producto_model.dart';
import 'package:royal_prestige/src/pages/detalle_foto.dart';
import 'package:royal_prestige/src/utils/colors.dart';
import 'package:royal_prestige/src/utils/constants.dart';
import 'package:royal_prestige/src/utils/responsive.dart';
import 'package:royal_prestige/src/utils/utils.dart';
import 'package:royal_prestige/src/widget/show_loading.dart';

class DetalleProducto extends StatefulWidget {
  const DetalleProducto({Key? key, required this.idProducto}) : super(key: key);
  final String idProducto;

  @override
  State<DetalleProducto> createState() => _DetalleProductoState();
}

class _DetalleProductoState extends State<DetalleProducto> {
  final _controller = Controller();
  @override
  Widget build(BuildContext context) {
    final productoBloc = ProviderBloc.productos(context);
    productoBloc.obtenerProductoByIdProducto(widget.idProducto);

    final responsive = Responsive.of(context);
    return Scaffold(
      body: StreamBuilder(
        stream: productoBloc.productoIdStream,
        builder: (context, AsyncSnapshot<List<ProductoModel>> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.length > 0) {
              return AnimatedBuilder(
                  animation: _controller,
                  builder: (_, t) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: ScreenUtil().setHeight(330),
                          child: Stack(
                            children: [
                              Container(
                                height: ScreenUtil().setHeight(290),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: colorPrimary,
                                  borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(30),
                                    bottomLeft: Radius.circular(30),
                                  ),
                                ),
                                child: (snapshot.data![0].galery!.length > 0)
                                    ? CarouselSlider.builder(
                                        itemCount: snapshot.data![0].galery!.length,
                                        itemBuilder: (context, x, y) {
                                          return InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                PageRouteBuilder(
                                                  pageBuilder: (context, animation, secondaryAnimation) {
                                                    return DetailPicture(
                                                      index: x.toString(),
                                                      idProducto: snapshot.data![0].galery![x].idProduct.toString(),
                                                    );
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
//DetailPicture
                                            },
                                            child: Container(
                                              margin: EdgeInsets.symmetric(
                                                horizontal: ScreenUtil().setWidth(0),
                                              ),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10.0),
                                              ),
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(10.0),
                                                child: Stack(
                                                  children: [
                                                    CachedNetworkImage(
                                                      placeholder: (context, url) => Container(
                                                          width: double.infinity, height: double.infinity, child: CupertinoActivityIndicator()),
                                                      errorWidget: (context, url, error) => Container(
                                                        width: double.infinity,
                                                        height: double.infinity,
                                                        child: Center(
                                                          child: Icon(Icons.error),
                                                        ),
                                                      ),
                                                      imageUrl: '$apiBaseURL/${snapshot.data![0].galery![x].file}',
                                                      imageBuilder: (context, imageProvider) => Container(
                                                        decoration: BoxDecoration(
                                                          image: DecorationImage(
                                                            image: imageProvider,
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                        options: CarouselOptions(
                                            height: ScreenUtil().setHeight(552),
                                            onPageChanged: (index, page) {},
                                            enlargeCenterPage: true,
                                            autoPlay: true,
                                            autoPlayCurve: Curves.fastOutSlowIn,
                                            autoPlayInterval: Duration(seconds: 6),
                                            autoPlayAnimationDuration: Duration(milliseconds: 2000),
                                            viewportFraction: 1),
                                      )
                                    : Container(
                                        width: double.infinity,
                                        height: double.infinity,
                                        child: Center(
                                          child: Icon(Icons.error),
                                        ),
                                      ),
                              ),
                              Positioned(
                                top: 0,
                                right: ScreenUtil().setWidth(25),
                                child: SafeArea(
                                  child: InkWell(
                                    onTap: () {
                                      agregarGaleria(context, snapshot.data![0]);
                                    },
                                    child: Align(
                                      alignment: Alignment.topRight,
                                      child: Container(
                                        height: ScreenUtil().setHeight(40),
                                        width: ScreenUtil().setWidth(40),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(color: Colors.white),
                                          color: Colors.white,
                                        ),
                                        child: Center(
                                          child: Icon(
                                            Icons.photo_camera,
                                            color: NewColors.green,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              /*  Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Container(
                                  margin: EdgeInsets.symmetric(
                                    horizontal: ScreenUtil().setWidth(20),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: ScreenUtil().setWidth(23),
                                    vertical: ScreenUtil().setHeight(18),
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.3),
                                        spreadRadius: 1,
                                        blurRadius: 3,
                                        offset: const Offset(1, 0), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: Container(
                                    height: ScreenUtil().setHeight(50),
                                    child: ListView.builder(
                                      itemCount: 5,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (_, index) {
                                        return Container(
                                          margin: EdgeInsets.only(
                                            right: ScreenUtil().setWidth(24),
                                          ),
                                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
                                          child: Image.asset('assets/img/picture2.jpg'),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              */
                              SafeArea(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: colorPrimary,
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(color: Colors.white),
                                  ),
                                  margin: EdgeInsets.only(
                                    left: ScreenUtil().setWidth(20),
                                  ),
                                  child: BackButton(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: ScreenUtil().setHeight(24),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: ScreenUtil().setWidth(24),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  '${snapshot.data![0].nombreProducto}',
                                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(24)),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  _controller.changeExpanded2(!_controller.expanded2);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(color: colorPrimary),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  padding: EdgeInsets.all(2),
                                  child: Icon(
                                    Icons.keyboard_arrow_down,
                                    color: colorPrimary,
                                    size: ScreenUtil().setHeight(20),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: ScreenUtil().setHeight(12),
                        ),
                        (_controller.expanded2)
                            ? Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: ScreenUtil().setWidth(24),
                                ),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: ScreenUtil().setWidth(23),
                                    vertical: ScreenUtil().setHeight(18),
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.3),
                                        spreadRadius: 1,
                                        blurRadius: 3,
                                        offset: const Offset(1, 0), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: Text(
                                    '${snapshot.data![0].regaloProducto} \n S/.${snapshot.data![0].precioRegaloProducto}',
                                    style: TextStyle(fontWeight: FontWeight.w300, fontSize: ScreenUtil().setSp(11)),
                                  ),
                                ),
                              )
                            : Container(),
                        SizedBox(
                          height: ScreenUtil().setHeight(12),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: ScreenUtil().setWidth(24),
                          ),
                          child: Text(
                            'Descripción',
                            style: TextStyle(fontWeight: FontWeight.w600, fontSize: ScreenUtil().setSp(13)),
                          ),
                        ),
                        SizedBox(
                          height: ScreenUtil().setHeight(6),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: ScreenUtil().setWidth(24),
                          ),
                          child: Text(
                            '${snapshot.data![0].descripcionProducto}',
                            style: TextStyle(fontWeight: FontWeight.w300, fontSize: ScreenUtil().setSp(11)),
                          ),
                        ),
                        SizedBox(
                          height: ScreenUtil().setHeight(24),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: ScreenUtil().setWidth(24),
                          ),
                          child: _expandedContainer('Precio S/. ${snapshot.data![0].precioProducto}', _controller.expanded, _contenido()),
                        ),
                        Spacer(),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: ScreenUtil().setHeight(20),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: ScreenUtil().setWidth(20),
                                ),
                                width: ScreenUtil().setWidth(160),
                                decoration: BoxDecoration(
                                  border: Border.all(color: colorPrimary),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        _controller.changeCantidad(-1);
                                      },
                                      child: Text(
                                        '-',
                                        style: TextStyle(
                                          fontSize: ScreenUtil().setSp(40),
                                          color: colorPrimary,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      '${_controller.cantidad}',
                                      style: TextStyle(fontSize: ScreenUtil().setSp(24)),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        _controller.changeCantidad(1);
                                      },
                                      child: Text(
                                        '+',
                                        style: TextStyle(
                                          fontSize: ScreenUtil().setSp(30),
                                          color: colorPrimary,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: ScreenUtil().setWidth(50),
                              ),
                              InkWell(
                                onTap: () {
                                  dialiogCart(
                                    context,
                                    responsive,
                                    snapshot.data![0],
                                    '${_controller.cantidad}',
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: colorPrimary,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  padding: EdgeInsets.all(5),
                                  child: Icon(
                                    Icons.shopping_cart,
                                    color: Colors.white,
                                    size: ScreenUtil().setHeight(30),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  });
            } else {
              return Center(
                child: Text('Cargar nuevamente'),
              );
            }
          } else {
            return ShowLoadding(
              active: true,
              h: double.infinity,
              w: double.infinity,
              fondo: Colors.transparent,
              colorText: Colors.black,
            );
          }
        },
      ),
    );
  }

  Future<dynamic> dialiogCart(BuildContext context, Responsive responsive, ProductoModel productoModel, String cantidad) {
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
                    'Elige una opción',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: ScreenUtil().setSp(20),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Divider(),
                  InkWell(
                    onTap: () async {
                      /*
  String? ;
  String? ;
  String? ;
  String? ;
  String? ;
  String? ;
   */
                      final cartDatabase = CartDatabase();

                      final list = await cartDatabase.getCartForId(productoModel.idProducto.toString());
                      if (list.length > 0) {
                        var subtotalex = (double.parse(cantidad) + double.parse(list[0].amount.toString())) *
                            double.parse(productoModel.precioProducto.toString());
                        CartModel cartModel = CartModel();
                        cartModel.idProduct = productoModel.idProducto;
                        /* cartModel.descripcionProducto = productoModel.descripcionProducto;
                        cartModel.nombreProducto = productoModel.nombreProducto;
                        cartModel.precioProducto = productoModel.precioProducto;
                        cartModel.regaloProducto = productoModel.regaloProducto;
                        cartModel.precioRegaloProducto = productoModel.precioRegaloProducto;
                        cartModel.fotoProducto = productoModel.fotoProducto; */
                        cartModel.amount = (double.parse(cantidad) + double.parse(list[0].amount.toString())).toString();
                        cartModel.subtotal = subtotalex.toString();
                        cartModel.status = productoModel.estadoProducto;

                        await cartDatabase.insertCart(cartModel);
                      } else {
                        var subtotalex = double.parse(cantidad) * double.parse(productoModel.precioProducto.toString());
                        CartModel cartModel = CartModel();
                        cartModel.idProduct = productoModel.idProducto;
                        cartModel.amount = cantidad;
                        cartModel.descripcionProducto = productoModel.descripcionProducto;
                        /*  cartModel.nombreProducto = productoModel.nombreProducto;
                        cartModel.precioProducto = productoModel.precioProducto;
                        cartModel.regaloProducto = productoModel.regaloProducto;
                        cartModel.precioRegaloProducto = productoModel.precioRegaloProducto;
                        cartModel.fotoProducto = productoModel.fotoProducto; */
                        cartModel.subtotal = subtotalex.toString();
                        cartModel.status = productoModel.estadoProducto;

                        await cartDatabase.insertCart(cartModel);
                      }

                      showToast2('Producto agregado correctamente', Colors.green);
                      final carritoBloc = ProviderBloc.cart(context);
                      carritoBloc.getCart();
                      Navigator.pop(context);
                    },
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: colorPrimary,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          padding: EdgeInsets.all(5),
                          child: Icon(
                            Icons.shopping_cart,
                            color: Colors.white,
                            size: ScreenUtil().setHeight(30),
                          ),
                        ),
                        SizedBox(
                          width: ScreenUtil().setWidth(20),
                        ),
                        Expanded(
                          child: Text('Agregar al carrito'),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(5),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          padding: EdgeInsets.all(5),
                          child: Icon(
                            Icons.search,
                            color: Colors.white,
                            size: ScreenUtil().setHeight(30),
                          ),
                        ),
                        SizedBox(
                          width: ScreenUtil().setWidth(20),
                        ),
                        Expanded(
                          child: Text('Seguir buscando'),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(5),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                      final bottomBloc = ProviderBloc.botton(context);
                      bottomBloc.changePage(5);
                    },
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          padding: EdgeInsets.all(5),
                          child: Icon(
                            Icons.shopping_bag,
                            color: Colors.white,
                            size: ScreenUtil().setHeight(30),
                          ),
                        ),
                        SizedBox(
                          width: ScreenUtil().setWidth(20),
                        ),
                        Expanded(
                          child: Text('Ir al carrito'),
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

  void agregarGaleria(BuildContext context, ProductoModel producto) {
    final _controller = ChangeEditController();

    _controller.changeBoton(false);

    final picker = ImagePicker();
    Future<Null> _cropImage(filePath) async {
      File? croppedImage = await ImageCropper.cropImage(
          sourcePath: filePath,
          aspectRatioPresets: Platform.isAndroid
              ? [
                  CropAspectRatioPreset.original,
                  CropAspectRatioPreset.ratio4x3,
                  CropAspectRatioPreset.ratio16x9,
                ]
              : [
                  CropAspectRatioPreset.original,
                  CropAspectRatioPreset.ratio4x3,
                  CropAspectRatioPreset.ratio16x9,
                ],
          androidUiSettings: AndroidUiSettings(
              toolbarTitle: 'Cortar Imagen',
              toolbarColor: Colors.green,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              showCropGrid: true,
              lockAspectRatio: false),
          iosUiSettings: IOSUiSettings(minimumAspectRatio: 1.0, title: 'Cortar Imagen'));
      if (croppedImage != null) {
        _controller.changeImage(croppedImage);
      }
    }

    Future getImageCamera() async {
      final pickedFile = await picker.pickImage(source: ImageSource.camera, imageQuality: 70);

      if (pickedFile != null) {
        _cropImage(pickedFile.path);
      }
    }

    Future getImageGallery() async {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 70);

      if (pickedFile != null) {
        _cropImage(pickedFile.path);
      }
      /**/
    }

    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return Stack(
            children: [
              GestureDetector(
                child: Container(
                  color: Color.fromRGBO(0, 0, 0, 0.001),
                  child: DraggableScrollableSheet(
                      initialChildSize: 0.93,
                      minChildSize: 0.2,
                      maxChildSize: 0.93,
                      builder: (_, controller) {
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(25.0),
                              topRight: const Radius.circular(25.0),
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: ScreenUtil().setHeight(24),
                              horizontal: ScreenUtil().setWidth(24),
                            ),
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          Icons.arrow_back_ios,
                                          color: NewColors.black,
                                        ),
                                        iconSize: ScreenUtil().setSp(20),
                                        onPressed: () => Navigator.of(context).pop(),
                                      ),
                                      SizedBox(width: ScreenUtil().setWidth(24)),
                                      Text(
                                        'Añadir galeria',
                                        style: GoogleFonts.poppins(
                                          fontStyle: FontStyle.normal,
                                          fontWeight: FontWeight.w700,
                                          color: NewColors.black,
                                          fontSize: ScreenUtil().setSp(18),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: ScreenUtil().setHeight(16),
                                  ),
                                  AnimatedBuilder(
                                    animation: _controller,
                                    builder: (_, s) {
                                      return Center(
                                        child: (_controller.image != null)
                                            ? Container(
                                                height: ScreenUtil().setHeight(150),
                                                width: ScreenUtil().setWidth(150),
                                                child: ClipRRect(
                                                  child: Image.file(_controller.image!),
                                                ),
                                              )
                                            : Container(
                                                height: ScreenUtil().setHeight(150),
                                                width: ScreenUtil().setWidth(150),
                                                color: NewColors.white,
                                                child: SvgPicture.asset('assets/torneo/fondoCapitan.svg'),
                                              ),
                                      );
                                    },
                                  ),
                                  SizedBox(
                                    height: ScreenUtil().setHeight(8),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        backgroundColor: Colors.transparent,
                                        builder: (context) {
                                          return GestureDetector(
                                            child: Container(
                                              color: Color.fromRGBO(0, 0, 0, 0.001),
                                              child: GestureDetector(
                                                onTap: () {},
                                                child: DraggableScrollableSheet(
                                                  initialChildSize: 0.2,
                                                  minChildSize: 0.2,
                                                  maxChildSize: 0.2,
                                                  builder: (_, controller) {
                                                    return Container(
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius: BorderRadius.only(
                                                          topLeft: const Radius.circular(25.0),
                                                          topRight: const Radius.circular(25.0),
                                                        ),
                                                      ),
                                                      child: Padding(
                                                        padding: EdgeInsets.symmetric(
                                                          horizontal: ScreenUtil().setWidth(24),
                                                        ),
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            SizedBox(
                                                              height: ScreenUtil().setHeight(24),
                                                            ),
                                                            InkWell(
                                                              onTap: () {
                                                                Navigator.pop(context);
                                                                getImageGallery();
                                                              },
                                                              child: Row(
                                                                children: [
                                                                  Text(
                                                                    'Seleccionar foto',
                                                                    style: GoogleFonts.poppins(
                                                                      fontStyle: FontStyle.normal,
                                                                      fontWeight: FontWeight.w400,
                                                                      color: NewColors.black,
                                                                      fontSize: ScreenUtil().setSp(16),
                                                                      letterSpacing: ScreenUtil().setSp(0.016),
                                                                    ),
                                                                  ),
                                                                  Spacer(),
                                                                  SvgPicture.asset(
                                                                    'assets/info/photo.svg',
                                                                    fit: BoxFit.cover,
                                                                    height: ScreenUtil().setHeight(24),
                                                                    width: ScreenUtil().setWidth(24),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Divider(
                                                              thickness: 1,
                                                              color: NewColors.grayBackSpace,
                                                            ),
                                                            SizedBox(
                                                              height: ScreenUtil().setHeight(10),
                                                            ),
                                                            InkWell(
                                                              onTap: () {
                                                                Navigator.pop(context);
                                                                getImageCamera();
                                                              },
                                                              child: Row(
                                                                children: [
                                                                  Text(
                                                                    'Tomar foto',
                                                                    style: GoogleFonts.poppins(
                                                                      fontStyle: FontStyle.normal,
                                                                      fontWeight: FontWeight.w400,
                                                                      color: NewColors.black,
                                                                      fontSize: ScreenUtil().setSp(16),
                                                                      letterSpacing: ScreenUtil().setSp(0.016),
                                                                    ),
                                                                  ),
                                                                  Spacer(),
                                                                  SvgPicture.asset(
                                                                    'assets/info/camera.svg',
                                                                    fit: BoxFit.cover,
                                                                    height: ScreenUtil().setHeight(24),
                                                                    width: ScreenUtil().setWidth(24),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Divider(
                                                              thickness: 1,
                                                              color: NewColors.grayBackSpace,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    child: Center(
                                      child: Text(
                                        'Añadir foto',
                                        style: GoogleFonts.poppins(
                                          fontStyle: FontStyle.normal,
                                          fontWeight: FontWeight.w400,
                                          color: NewColors.green,
                                          fontSize: ScreenUtil().setSp(14),
                                          letterSpacing: ScreenUtil().setSp(0.016),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: ScreenUtil().setHeight(48)),
                                  InkWell(
                                    onTap: () async {
                                      _controller.changeCargando(true);

                                      if (_controller.boton) {
                                        final productosApi = ProductosApi();
                                        final res = await productosApi.agregarGaleria(
                                            _controller.image!, '${producto.idProducto}', '${producto.nombreProducto}');
                                        if (res) {
                                          /* final galeriaBloc = ProviderBloc.galeria(context);
                                          galeriaBloc.obtenerGalerias(negocio.idEmpresa); */
                                          Navigator.pop(context);
                                        } else {
                                          _controller.changeText('Ocurrió un error');
                                        }
                                      }

                                      _controller.changeCargando(false);
                                    },
                                    child: AnimatedBuilder(
                                        animation: _controller,
                                        builder: (_, s) {
                                          return Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(50),
                                              color: (_controller.boton) ? NewColors.green : NewColors.green.withOpacity(0.6),
                                            ),
                                            child: Center(
                                              child: Text(
                                                'Guardar',
                                                style: GoogleFonts.poppins(
                                                    color: NewColors.white,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: ScreenUtil().setSp(18),
                                                    fontStyle: FontStyle.normal),
                                              ),
                                            ),
                                            height: ScreenUtil().setHeight(60),
                                            width: ScreenUtil().setWidth(327),
                                          );
                                        }),
                                  ),
                                  SizedBox(height: ScreenUtil().setHeight(8)),
                                  Center(
                                    child: AnimatedBuilder(
                                        animation: _controller,
                                        builder: (_, s) {
                                          return Text(
                                            _controller.text,
                                            style: GoogleFonts.poppins(
                                              color: NewColors.orangeLight,
                                              fontWeight: FontWeight.w600,
                                              fontSize: ScreenUtil().setSp(14),
                                              fontStyle: FontStyle.normal,
                                              letterSpacing: ScreenUtil().setSp(0.016),
                                            ),
                                          );
                                        }),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                ),
              ),
              AnimatedBuilder(
                  animation: _controller,
                  builder: (_, s) {
                    if (_controller.cargando) {
                      return _mostrarAlert();
                    } else {
                      return Container();
                    }
                  })
            ],
          );
        });
  }

  Widget _mostrarAlert() {
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: Color.fromRGBO(0, 0, 0, 0.5),
      child: Center(
        child: Container(
          height: 150.0,
          child: CupertinoActivityIndicator(),
        ),
      ),
    );
  }

  Widget _expandedContainer(String titulo, bool expanded, Widget contenido) {
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
              _controller.changeExpanded(!expanded);
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

  Widget _contenido() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Compra:',
              style: TextStyle(
                fontSize: ScreenUtil().setSp(14),
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              'S/. 12 250.80',
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
              'IGV:',
              style: TextStyle(
                fontSize: ScreenUtil().setSp(14),
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              'S/. 2 689.20',
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
}

class Controller extends ChangeNotifier {
  bool expanded = true, expanded2 = false;
  int cantidad = 1;

  void changeExpanded(bool e) {
    expanded = e;
    notifyListeners();
  }

  void changeExpanded2(bool e) {
    expanded2 = e;
    notifyListeners();
  }

  void changeCantidad(int c) {
    if (cantidad > 0) {
      cantidad = cantidad + c;
    } else {
      cantidad = 1;
    }
    notifyListeners();
  }
}

class ChangeEditController extends ChangeNotifier {
  bool cargando = false;
  String hora1 = '';
  String hora2 = '';
  String hora1D = '';
  String hora2D = '';
  String text = '';
  bool boton = true;
  File? image;

  void changeImage(File i) {
    image = i;
    boton = true;
    notifyListeners();
  }

  void changeBoton(bool b) {
    boton = b;
    notifyListeners();
  }

  void changeHora1(String h) {
    hora1 = h;
    notifyListeners();
  }

  void changeHora2(String p) {
    hora2 = p;
    notifyListeners();
  }

  void changeHora1D(String h) {
    hora1D = h;
    notifyListeners();
  }

  void changeHora2D(String p) {
    hora2D = p;
    notifyListeners();
  }

  void changeCargando(bool c) {
    cargando = c;
    notifyListeners();
  }

  void changeText(String t) {
    text = t;
    notifyListeners();
  }
}

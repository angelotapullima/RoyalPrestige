import 'dart:io';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:royal_prestige/src/bloc/data_user.dart';
import 'package:royal_prestige/src/pages/logout.dart';
import 'package:royal_prestige/src/utils/constants.dart';
import 'package:royal_prestige/src/utils/responsive.dart';
import 'package:royal_prestige/src/utils/utils.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_extend/share_extend.dart';

class InfoUser extends StatefulWidget {
  const InfoUser({Key? key, required this.user}) : super(key: key);
  final UserModel user;

  @override
  _InfoUserState createState() => _InfoUserState();
}

class _InfoUserState extends State<InfoUser> {
  Uint8List? _imageFile;
  List<String> imagePaths = [];
  ScreenshotController screenshotController = ScreenshotController();
  final _controller = ControllerShare();

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    return Scaffold(
      body: Screenshot(
        controller: screenshotController,
        child: Stack(
          children: [
            Container(
              height: double.infinity,
              width: double.infinity,
              color: NewColors.card,
            ),
            SafeArea(
              child: Container(
                margin: EdgeInsets.only(
                  top: ScreenUtil().setHeight(10),
                  bottom: ScreenUtil().setHeight(10),
                  left: ScreenUtil().setWidth(16),
                  right: ScreenUtil().setWidth(16),
                ),
                padding: EdgeInsets.only(
                  top: ScreenUtil().setHeight(16),
                  left: ScreenUtil().setWidth(16),
                  right: ScreenUtil().setWidth(16),
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 3,
                      blurRadius: 3,
                      offset: const Offset(1, 0), // changes position of shadow
                    ),
                  ],
                ),
                child: _tickerDetails(responsive),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tickerDetails(Responsive responsive) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Center(
          child: Container(
            height: ScreenUtil().setHeight(8),
            width: ScreenUtil().setWidth(100),
            decoration: BoxDecoration(color: NewColors.grayCarnet.withOpacity(0.6), borderRadius: BorderRadius.circular(10)),
          ),
        ),
        Row(
          children: [
            IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: NewColors.black,
              ),
              iconSize: ScreenUtil().setSp(24),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            Spacer(),
            IconButton(
              icon: Icon(
                Icons.share_outlined,
                color: NewColors.black,
              ),
              iconSize: ScreenUtil().setSp(24),
              onPressed: () {
                _controller.changeActive(false);
                takeScreenshotandShare();
              },
            ),
          ],
        ),
        SizedBox(
          height: ScreenUtil().setHeight(16),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Spacer(),
            Text(
              '#${widget.user.idUser}',
              style: GoogleFonts.poppins(
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w500,
                color: NewColors.grayCarnet,
                fontSize: ScreenUtil().setSp(18),
              ),
            ),
          ],
        ),
        SizedBox(
          height: ScreenUtil().setHeight(30),
        ),
        Center(
          child: Container(
            child: Image.asset(
              'assets/img/logo-royal.png',
              fit: BoxFit.cover,
              height: ScreenUtil().setHeight(50),
            ),
          ),
        ),
        SizedBox(
          height: ScreenUtil().setHeight(20),
        ),
        Center(
          child: Container(
            width: ScreenUtil().setWidth(120),
            height: ScreenUtil().setHeight(120),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: CachedNetworkImage(
                placeholder: (context, url) => Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: Image(image: AssetImage('assets/img/profile.png'), fit: BoxFit.cover),
                ),
                errorWidget: (context, url, error) => Container(
                  child: Container(
                    child: Image.asset(
                      'assets/img/profile.png',
                      fit: BoxFit.cover,
                      width: ScreenUtil().setWidth(150),
                      height: ScreenUtil().setHeight(150),
                    ),
                  ),
                ),
                imageUrl: '$apiBaseURL/${widget.user.userImage}',
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.red, width: ScreenUtil().setWidth(3)),
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: ScreenUtil().setHeight(8),
        ),
        Center(
          child: Text(
            '${obtenerPrimerNombre('${widget.user.personName}')} ${widget.user.personSurname}',
            style: GoogleFonts.poppins(
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w700,
              color: NewColors.card,
              fontSize: ScreenUtil().setSp(18),
            ),
          ),
        ),
        SizedBox(
          height: ScreenUtil().setHeight(16),
        ),
        _data('DNI:', ''),
        SizedBox(
          height: ScreenUtil().setHeight(12.5),
        ),
        _data('Cargo:', ''),
        SizedBox(
          height: ScreenUtil().setHeight(12.5),
        ),
        SizedBox(
          height: ScreenUtil().setHeight(18),
        ),
        Spacer(),
        Center(
          child: Container(
            child: Image.asset(
              'assets/img/logo-royal.png',
              fit: BoxFit.cover,
              height: ScreenUtil().setHeight(150),
            ),
          ),
        ),
        SizedBox(
          height: ScreenUtil().setHeight(20),
        ),
        AnimatedBuilder(
            animation: _controller,
            builder: (_, t) {
              return (_controller.activarLogout)
                  ? Center(
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              opaque: false,
                              pageBuilder: (context, animation, secondaryAnimation) {
                                return Logout();
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
                        child: Text(
                          'Cerrar sesión',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: ScreenUtil().setSp(20),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    )
                  : Container();
            }),
        SizedBox(
          height: ScreenUtil().setHeight(30),
        ),
      ],
    );
  }

  Row _data(String lavel, String titulo) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          lavel,
          style: GoogleFonts.poppins(
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.w500,
            color: NewColors.card,
            fontSize: ScreenUtil().setSp(14),
            letterSpacing: ScreenUtil().setSp(0.016),
          ),
        ),
        SizedBox(
          width: ScreenUtil().setWidth(8),
        ),
        Text(
          titulo,
          style: GoogleFonts.poppins(
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.w500,
            color: NewColors.backGroundCarnet,
            fontSize: ScreenUtil().setSp(14),
            letterSpacing: ScreenUtil().setSp(0.016),
          ),
        ),
      ],
    );
  }

  takeScreenshotandShare() async {
    var now = DateTime.now();
    var nombre = now.microsecond.toString();
    _imageFile = null;
    screenshotController.capture(delay: Duration(milliseconds: 10), pixelRatio: 2.0).then((Uint8List? image) async {
      setState(() {
        _imageFile = image;
      });

      await ImageGallerySaver.saveImage(image!);

      final directory = (await getApplicationDocumentsDirectory()).path;
      Uint8List pngBytes = _imageFile!;
      File imgFile = new File('$directory/Screenshot$nombre.png');
      imgFile.writeAsBytes(pngBytes);
      print("File Saved to Gallery");

      imagePaths.clear();
      imagePaths.add(imgFile.path);

      if (imagePaths.isNotEmpty) {
        await Future.delayed(
          Duration(seconds: 1),
        );

        ShareExtend.shareMultiple(imagePaths, "image", subject: "carnet");
        _controller.changeActive(true);
      } else {
        _controller.changeActive(true);
      }
    }).catchError((onError) {
      print(onError);
    });
  }
}

class ControllerShare extends ChangeNotifier {
  bool activarLogout = true;

  void changeActive(bool a) {
    activarLogout = a;
    notifyListeners();
  }
}

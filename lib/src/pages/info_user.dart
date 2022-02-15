import 'dart:io';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:royal_prestige/core/sharedpreferences/storage_manager.dart';
import 'package:royal_prestige/src/utils/responsive.dart';
import 'package:royal_prestige/src/utils/utils.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_extend/share_extend.dart';

class InfoUser extends StatefulWidget {
  const InfoUser({Key? key}) : super(key: key);

  @override
  _InfoUserState createState() => _InfoUserState();
}

class _InfoUserState extends State<InfoUser> {
  Uint8List? _imageFile;
  List<String> imagePaths = [];
  ScreenshotController screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    return Scaffold(
      body: Screenshot(
        controller: screenshotController,
        child: Stack(
          children: [
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
              '#${_titulo('idUser')}',
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
              width: ScreenUtil().setWidth(255),
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
                imageUrl: '',
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
            '${obtenerPrimerNombre(_titulo('personName'))} ${_titulo('personSurname')}',
            style: GoogleFonts.poppins(
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w700,
              color: NewColors.grayCarnet,
              fontSize: ScreenUtil().setSp(18),
            ),
          ),
        ),
        SizedBox(
          height: ScreenUtil().setHeight(16),
        ),
        _data(Icons.email, 'userEmail'),
        SizedBox(
          height: ScreenUtil().setHeight(12.5),
        ),
        SizedBox(
          height: ScreenUtil().setHeight(18),
        ),
        // Row(
        //   children: [
        //     Column(
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       children: [
        //         Text(
        //           'Edad',
        //           style: GoogleFonts.poppins(
        //             fontStyle: FontStyle.normal,
        //             fontWeight: FontWeight.w400,
        //             color: Color(0xFF8D9597),
        //             fontSize: ScreenUtil().setSp(14),
        //             letterSpacing: ScreenUtil().setSp(0.016),
        //           ),
        //         ),
        //         Text(
        //           '${obtenerEdad(_titulo('personName'))}',
        //           style: GoogleFonts.poppins(
        //             fontStyle: FontStyle.normal,
        //             fontWeight: FontWeight.w500,
        //             color: NewColors.backGroundCarnet,
        //             fontSize: ScreenUtil().setSp(14),
        //             letterSpacing: ScreenUtil().setSp(0.016),
        //           ),
        //         ),
        //       ],
        //     ),
        //     Spacer(),

        //   ],
        // ),
        Spacer(),
        Center(
          child: Container(
            child: Image.asset(
              'assets/img/logo-royal.png',
              fit: BoxFit.cover,
              height: ScreenUtil().setHeight(50),
              width: ScreenUtil().setWidth(255),
            ),
          ),
        ),
        SizedBox(
          height: ScreenUtil().setHeight(30),
        ),
      ],
    );
  }

  Row _data(IconData icon, String titulo) {
    return Row(
      children: [
        Icon(icon),
        SizedBox(
          width: ScreenUtil().setWidth(8),
        ),
        Text(
          '${_titulo(titulo)}',
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

  _titulo(String titulo) async {
    String? data = await StorageManager.readData(titulo);
    return data;
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
      } else {}
    }).catchError((onError) {
      print(onError);
    });
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:royal_prestige/src/model/compras_model.dart';
import 'package:royal_prestige/src/utils/utils.dart';

class DetalleCompra extends StatelessWidget {
  const DetalleCompra({Key? key, required this.compra}) : super(key: key);
  final ComprasModel compra;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: Text(
          'Detalle Compra',
          style: TextStyle(
            color: NewColors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(24)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: ScreenUtil().setHeight(20),
              ),
              Center(
                child: Container(height: ScreenUtil().setHeight(100), child: Image.asset('assets/img/sethi_logo.png')),
              ),
              Container(
                width: ScreenUtil().setWidth(250),
                child: Lottie.asset(
                  'assets/Json/shopping-cart.json',
                ),
              ),
              Text(
                '${compra.idProducto}',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: ScreenUtil().setSp(24),
                  fontWeight: FontWeight.w700,
                  color: Color(0XFFED3237),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Precio:',
                    style: GoogleFonts.poppins(
                      fontSize: ScreenUtil().setSp(20),
                      fontWeight: FontWeight.w600,
                      color: Color(0XFFED3237),
                    ),
                  ),
                  SizedBox(
                    width: ScreenUtil().setWidth(8),
                  ),
                  Text(
                    'S/ ${compra.montoCuotaCompra}',
                    style: GoogleFonts.poppins(
                      fontSize: ScreenUtil().setSp(20),
                      fontWeight: FontWeight.w600,
                      color: Color(0XFFED3237),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: ScreenUtil().setHeight(10),
              ),
              Text(
                '${compra.observacionCompra}',
                textAlign: TextAlign.justify,
                style: GoogleFonts.poppins(
                  fontSize: ScreenUtil().setSp(14),
                  fontWeight: FontWeight.w500,
                  color: NewColors.grayCarnet,
                ),
              ),
              SizedBox(
                height: ScreenUtil().setHeight(12),
              ),
              Text(
                'Fecha de pago:',
                style: GoogleFonts.poppins(
                  fontSize: ScreenUtil().setSp(14),
                  fontWeight: FontWeight.w600,
                  color: Color(0XFFED3237),
                ),
              ),
              Text(
                '${compra.fechaPagoCompra}',
                style: GoogleFonts.poppins(
                  fontSize: ScreenUtil().setSp(18),
                  fontWeight: FontWeight.w500,
                  color: NewColors.grayCarnet,
                ),
              ),
              SizedBox(
                height: ScreenUtil().setHeight(12),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.calendar_today,
                    color: Color(0XFFED3237),
                  ),
                  SizedBox(
                    width: ScreenUtil().setWidth(8),
                  ),
                  Text(
                    'Compra realizada el ${obtenerFecha(compra.fechaCompra.toString())}',
                    style: GoogleFonts.poppins(
                      fontSize: ScreenUtil().setSp(14),
                      fontWeight: FontWeight.w500,
                      color: NewColors.grayCarnet,
                    ),
                  ),
                ],
              ), SizedBox(
                height: ScreenUtil().setHeight(60),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:royal_prestige/src/bloc/provider_bloc.dart';
import 'package:royal_prestige/src/model/alert_model.dart';
import 'package:royal_prestige/src/model/fecha_alert_model.dart';
import 'package:royal_prestige/src/pages/Alertas/add_alertas.dart';
import 'package:royal_prestige/src/utils/responsive.dart';

class AgendaPage extends StatelessWidget {
  const AgendaPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final alertasBloc = ProviderBloc.alert(context);
    alertasBloc.getAlertsTodayPluss();
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
        toolbarHeight: ScreenUtil().setHeight(70),
        centerTitle: false,
        backgroundColor: Colors.transparent,
        flexibleSpace: SafeArea(
          child: Container(
            margin: EdgeInsets.only(
              left: ScreenUtil().setWidth(10),
              right: ScreenUtil().setWidth(10),
              bottom: ScreenUtil().setHeight(1),
            ),
            child: Column(
              children: [
                Container(
                  height: ScreenUtil().setHeight(60),
                  padding: EdgeInsets.symmetric(
                    horizontal: ScreenUtil().setWidth(10),
                    vertical: ScreenUtil().setHeight(5),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        ' Agenda',
                        textAlign: TextAlign.center,
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
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: StreamBuilder(
          stream: alertasBloc.alertsStream,
          builder: (context, AsyncSnapshot<List<FechaAlertModel>> alertas) {
            if (alertas.hasData) {
              if (alertas.data!.length > 0) {
                return _itemFechaAlert(context, alertas.data!);
              } else {
                return Center(
                  child: Text('Sin agendas registradas'),
                );
              }
            } else {
              return Center(child: CupertinoActivityIndicator());
            }
          },
        ),
      ),
    );
  }

  Widget _itemFechaAlert(BuildContext context, List<FechaAlertModel> fechas) {
    final responsive = Responsive.of(context);

    return ListView.builder(
      padding: EdgeInsets.only(
        bottom: responsive.hp(5),
      ),
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      itemCount: fechas.length,
      itemBuilder: (context, y) {
        return Container(
          child: ListView.builder(
            padding: EdgeInsets.only(
              bottom: responsive.hp(3),
            ),
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            itemCount: 1,
            itemBuilder: (context, x) {
              /*  if (x == 0) {
                return Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: responsive.wp(3),
                    vertical: responsive.hp(2),
                  ),
                  child: Text(
                    '${fechas[y].fecha}',
                    style: GoogleFonts.poppins(
                      fontSize: ScreenUtil().setSp(16),
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                      letterSpacing: ScreenUtil().setSp(0.016),
                    ),
                  ),
                );
              } */

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: responsive.wp(19),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: responsive.wp(2),
                        vertical: responsive.hp(2),
                      ),
                      child: Text(
                        '${fechas[y].fecha}',
                        style: GoogleFonts.poppins(
                          fontSize: ScreenUtil().setSp(16),
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          letterSpacing: ScreenUtil().setSp(0.016),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      child: ListView.builder(
                        padding: EdgeInsets.all(0),
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        itemCount: fechas[y].alertas!.length,
                        /*  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio: 1,
                          crossAxisCount: 2,
                          mainAxisSpacing: responsive.hp(1),
                          crossAxisSpacing: responsive.wp(5),
                        ), */
                        itemBuilder: (context, i) {
                          return _itemAlerta(context, fechas[y].alertas![i], responsive);
                        },
                      ),
                    ),
                  ),
                ],
              );
              //return _cardCanchas(responsive, canchasDeporte[i], negocio);
            },
          ),
        );
      },
    );
  }

  Widget _itemAlerta(BuildContext context, AlertModel alerta, Responsive responsive) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: responsive.wp(2),
      ),
      margin: EdgeInsets.only(
        right: responsive.wp(2),
        bottom: responsive.hp(.5),
        top: responsive.hp(.5),
      ),
      decoration: BoxDecoration(
        color: Colors.blueGrey.shade100.withOpacity(.2),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${alerta.nombreCLiente}  ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: [
              Text(
                'Telefono: ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text('${alerta.telefonoCliente}'),
              Spacer(),
              Text(
                'Hora: ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text('${alerta.alertHour}'),
            ],
          ),
          Text(
            '${alerta.alertTitle}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text('${alerta.alertDetail}'),
          Text(''),
        ],
      ),
    );
  }
}

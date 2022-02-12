import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:royal_prestige/src/bloc/provider_bloc.dart';
import 'package:royal_prestige/src/model/alert_model.dart';
import 'package:royal_prestige/src/pages/Alertas/add_alertas.dart';

class AgendaPage extends StatelessWidget {
  const AgendaPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final alertasBloc = ProviderBloc.alert(context);
    alertasBloc.getAlerts();
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
        child: Expanded(
          child: StreamBuilder(
            stream: alertasBloc.alertsStream,
            builder: (context, AsyncSnapshot<List<AlertModel>> alertas) {
              if (alertas.hasData) {
                if (alertas.data!.length > 0) {
                  return ListView.builder(
                    itemCount: alertas.data!.length,
                    itemBuilder: (context, index) {
                      return _itemAlerta(context, alertas.data![index]);
                    },
                  );
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
      ),
    );
  }

  Widget _itemAlerta(BuildContext context, AlertModel alerta) {
    return Container(
      child: Row(
        children: [
          Text('${alerta.alertTitle}'),
        ],
      ),
    );
  }
}

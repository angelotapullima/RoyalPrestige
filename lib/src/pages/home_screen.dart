import 'package:flutter/material.dart';
import 'package:royal_prestige/core/sharedpreferences/storage_manager.dart';
import 'package:royal_prestige/src/bloc/provider_bloc.dart';
import 'package:royal_prestige/src/model/api_model.dart';
import 'package:royal_prestige/src/pages/Alertas/detail_alerta.dart';
import 'package:royal_prestige/src/pages/tabs/agenda_page.dart';
import 'package:royal_prestige/src/pages/tabs/calcular_page.dart';
import 'package:royal_prestige/src/pages/tabs/cliente_y_prospectos_page.dart';
import 'package:royal_prestige/src/pages/tabs/prueba_inicio.dart';
import 'package:royal_prestige/src/pages/tabs/tab_model.dart';
import 'package:royal_prestige/src/utils/responsive.dart';
import 'package:royal_prestige/src/widget/button_bar_widget.dart';

import 'tabs/documentosPage.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Widget> pageList = [];
  List<TabModel> tabs = [];

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 1), () async {
      String? tabCliente = await StorageManager.readData('tabCliente');
      String? tabAgenda = await StorageManager.readData('tabAgenda');

      pageList
          .add(PruebaInicio(showPendientes: tabAgenda == '1' ? true : false));
      pageList.add(const DocumentosPage());

      tabs.add(TabModel(icon: Icons.home, title: 'Inicio\n', value: 0));
      tabs.add(
          TabModel(icon: Icons.file_copy, title: 'Documentos\n', value: 1));

      int nTab = 2;

      if (tabCliente != null && tabCliente.isNotEmpty) {
        if (tabCliente == '1') {
          pageList.add(const ClientesyProspectosPage());
          tabs.add(TabModel(
              icon: Icons.person,
              title: 'Clientes y\nprospectos',
              value: nTab));

          nTab++;
        }
      }

      if (tabAgenda != null && tabAgenda.isNotEmpty) {
        if (tabAgenda == '1') {
          pageList.add(const AgendaPage());
          tabs.add(TabModel(
              icon: Icons.view_agenda, title: 'Agenda\n', value: nTab));
          nTab++;
        }
      }

      pageList.add(const CalcularPage());

      tabs.add(
          TabModel(icon: Icons.calculate, title: 'Calculadora\n', value: nTab));
    });

    super.initState();
  }

  void onClickNotifications(String? playLoad) => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => DetalleAlerta(
            idAlert: playLoad,
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final bottomBloc = ProviderBloc.botton(context);

    final responsive = Responsive.of(context);

    final carritoBloc = ProviderBloc.cart(context);
    carritoBloc.getCart();

    final dataBloc = ProviderBloc.data(context);
    dataBloc.obtenerDatosUser();

    return Scaffold(
      body: Stack(
        children: [
          StreamBuilder(
            stream: bottomBloc.selectPageStream,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                bottomBloc.changePage(snapshot.data);
              }
              return Stack(
                children: [
                  Container(
                    padding: EdgeInsets.only(
                      bottom: kBottomNavigationBarHeight * responsive.hp(.21),
                    ),
                    child: IndexedStack(
                      index: snapshot.data,
                      children: pageList,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: kBottomNavigationBarHeight * responsive.hp(.21),
                      padding: EdgeInsets.only(
                        bottom: responsive.hp(2),
                        left: responsive.wp(2),
                        right: responsive.wp(2),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadiusDirectional.only(
                          topStart: Radius.circular(20),
                          topEnd: Radius.circular(20),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: StreamBuilder(
                        stream: bottomBloc.selectPageStream,
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          return Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: responsive.wp(2),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: tabs
                                  .map(
                                    (tab) => ButtonBarWidget(
                                      onTap: () {
                                        bottomBloc.changePage(tab.value);
                                      },
                                      responsive: responsive,
                                      color: (bottomBloc.page == tab.value)
                                          ? Colors.red
                                          : Colors.grey,
                                      data: tab,
                                    ),
                                  )
                                  .toList(),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          StreamBuilder(
            stream: dataBloc.estadoUserStream,
            builder: (context, AsyncSnapshot<ApiModel> estadoUser) {
              if (estadoUser.hasData) {
                return (estadoUser.data!.code == '2')
                    ? Container(
                        height: double.infinity,
                        width: double.infinity,
                        color: Colors.white,
                        child: Center(
                          child: Text(
                              'El usuario se encuenta actualmente deshabilitado'),
                        ),
                      )
                    : Container();
              } else {
                return Container();
              }
            },
          ),
        ],
      ),
    );
  }
}

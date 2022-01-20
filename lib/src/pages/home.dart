import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:royal_prestige/src/bloc/bottom_navigation_bloc.dart';
import 'package:royal_prestige/src/bloc/data_user.dart';
import 'package:royal_prestige/src/bloc/inicio_bloc.dart';
import 'package:royal_prestige/src/bloc/provider_bloc.dart';
import 'package:royal_prestige/src/pages/tabs/buscar_page.dart';
import 'package:royal_prestige/src/pages/tabs/calcular_page.dart';
import 'package:royal_prestige/src/pages/tabs/productos_page.dart';
import 'package:royal_prestige/src/utils/colors.dart';

import 'tabs/documentosPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Widget> pageList = [];

  @override
  void initState() {
    pageList.add(const BuscarPage());
    pageList.add(const CalcularPage());
    pageList.add(const ProductosPage());
    pageList.add(const DocumentosPage());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bottomBloc = ProviderBloc.botton(context);
    final bloc = HomeBloc();

    bottomBloc.changePage(3);
    final dataBloc = ProviderBloc.data(context);
    dataBloc.obtenerUser();
    return Scaffold(
      backgroundColor: colorPrimary,
      body: StreamBuilder(
        stream: bottomBloc.selectPageStream,
        builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
          if (snapshot.hasData) {
            return Stack(
              children: [
                Container(
                  color: colorPrimary,
                  height: double.infinity,
                  width: double.infinity,
                ),
                SafeArea(
                  bottom: false,
                  child: Stack(
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                          top: kBottomNavigationBarHeight + ScreenUtil().setHeight(20),
                        ),
                        child: IndexedStack(
                          index: bottomBloc.page,
                          children: pageList,
                        ),
                      ),
                      posi3(bottomBloc, context, bloc),
                    ],
                  ),
                ),
                AnimatedBuilder(
                  animation: bloc,
                  builder: (_, s) {
                    return (bloc.menuState == MenuIniciostate.open)
                        ? StreamBuilder(
                            stream: dataBloc.userStream,
                            builder: (context, AsyncSnapshot<UserModel> dataShot) {
                              if (dataShot.hasData) {
                                return Stack(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        bloc.changeToClosed();
                                      },
                                      child: Container(
                                        height: double.infinity,
                                        width: double.infinity,
                                      ),
                                    ),
                                    Container(
                                      width: ScreenUtil().setWidth(260),
                                      decoration: BoxDecoration(
                                        color: colorPrimary,
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(25),
                                          bottomRight: Radius.circular(25),
                                        ),
                                      ),
                                      child: SafeArea(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(
                                                left: ScreenUtil().setWidth(30),
                                                top: ScreenUtil().setHeight(20),
                                                bottom: ScreenUtil().setHeight(20),
                                              ),
                                              child: InkWell(
                                                onTap: () {
                                                  bloc.changeToClosed();
                                                },
                                                child: SizedBox(
                                                  height: ScreenUtil().setSp(30),
                                                  width: ScreenUtil().setSp(30),
                                                  child: (bottomBloc.page == 0)
                                                      ? SvgPicture.asset(
                                                          'assets/svg/menu.svg',
                                                          color: Colors.white,
                                                        )
                                                      : SvgPicture.asset(
                                                          'assets/svg/menu.svg',
                                                          color: Colors.white,
                                                        ),
                                                ),
                                              ),
                                            ),
                                            Divider(
                                              color: Colors.white,
                                            ),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: ScreenUtil().setWidth(24),
                                                vertical: ScreenUtil().setHeight(8),
                                              ),
                                              child: Row(
                                                children: [
                                                  SizedBox(
                                                    height: ScreenUtil().setHeight(43),
                                                    width: ScreenUtil().setWidth(43),
                                                    child: Image.asset('assets/img/profile.png'),
                                                  ),
                                                  SizedBox(
                                                    width: ScreenUtil().setWidth(12),
                                                  ),
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        '${dataShot.data!.personName}',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight: FontWeight.w500,
                                                          fontSize: ScreenUtil().setSp(15),
                                                        ),
                                                      ),
                                                      Text(
                                                        '${dataShot.data!.roleName}',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight: FontWeight.w500,
                                                          fontSize: ScreenUtil().setSp(15),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                            Divider(
                                              color: Colors.white,
                                            ),
                                            InkWell(
                                              onTap: () {
                                                bloc.changeToClosed();
                                                bottomBloc.changePage(0);
                                              },
                                              child: itemOption('Lista de precios'),
                                            ),
                                            Divider(
                                              color: Colors.white,
                                            ),
                                            InkWell(
                                              onTap: () {
                                                bloc.changeToClosed();
                                                bottomBloc.changePage(2);
                                              },
                                              child: itemOption('Productos'),
                                            ),
                                            Divider(
                                              color: Colors.white,
                                            ),
                                            InkWell(
                                              onTap: () {
                                                bloc.changeToClosed();
                                                bottomBloc.changePage(3);
                                              },
                                              child: itemOption('Documentos'),
                                            ),
                                            Divider(
                                              color: Colors.white,
                                            ),
                                            InkWell(
                                              child: itemOption('Royal Prestige'),
                                            ),
                                            Divider(
                                              color: Colors.white,
                                            ),
                                            Spacer(),
                                            Divider(
                                              color: Colors.white,
                                            ),
                                            InkWell(
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: ScreenUtil().setWidth(24),
                                                  vertical: ScreenUtil().setHeight(8),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(
                                                      'Salir',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.w500,
                                                        fontSize: ScreenUtil().setSp(15),
                                                      ),
                                                    ),
                                                    Icon(
                                                      Icons.logout,
                                                      color: Colors.white,
                                                      size: ScreenUtil().setHeight(20),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: ScreenUtil().setHeight(10),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              } else {
                                return Container();
                              }
                            })
                        : Container();
                  },
                ),
              ],
            );
          } else {
            final bottomBloc = ProviderBloc.botton(context);
            bottomBloc.changePage(0);
            return const Center(
              child: CupertinoActivityIndicator(),
            );
          }
        },
      ),
    );
  }

  Widget posi3(BottomNaviBloc bottomBloc, BuildContext context, HomeBloc bloc) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.only(
          left: ScreenUtil().setWidth(10),
          right: ScreenUtil().setWidth(10),
        ),
        height: kBottomNavigationBarHeight + ScreenUtil().setHeight(20),
        decoration: BoxDecoration(
          color: colorPrimary,
          borderRadius: const BorderRadiusDirectional.only(
            bottomEnd: Radius.circular(0),
            bottomStart: Radius.circular(0),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                bloc.changeToOpen();
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: ScreenUtil().setSp(30),
                    width: ScreenUtil().setSp(30),
                    child: (bottomBloc.page == 0)
                        ? SvgPicture.asset(
                            'assets/svg/menu.svg',
                            color: Colors.white,
                          )
                        : SvgPicture.asset(
                            'assets/svg/menu.svg',
                            color: Colors.white,
                          ),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () {
                bottomBloc.changePage(0);
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: ScreenUtil().setSp(30),
                    width: ScreenUtil().setSp(30),
                    child: (bottomBloc.page == 0)
                        ? SvgPicture.asset(
                            'assets/svg/search.svg',
                            color: Colors.white,
                          )
                        : SvgPicture.asset(
                            'assets/svg/search.svg',
                            color: Colors.white,
                          ),
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(2),
                  ),
                  CircleAvatar(
                    radius: ScreenUtil().setHeight(3),
                    backgroundColor: (bottomBloc.page == 0) ? Colors.white : Colors.transparent,
                  )
                ],
              ),
            ),
            InkWell(
              onTap: () {
                bottomBloc.changePage(1);
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: ScreenUtil().setSp(30),
                    width: ScreenUtil().setSp(30),
                    child: (bottomBloc.page == 1)
                        ? SvgPicture.asset(
                            'assets/svg/cal.svg',
                            color: Colors.white,
                          )
                        : SvgPicture.asset(
                            'assets/svg/cal.svg',
                            color: Colors.white,
                          ),
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(2),
                  ),
                  CircleAvatar(
                    radius: ScreenUtil().setHeight(3),
                    backgroundColor: (bottomBloc.page == 1) ? Colors.white : Colors.transparent,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget itemOption(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: ScreenUtil().setWidth(24),
        vertical: ScreenUtil().setHeight(8),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
          fontSize: ScreenUtil().setSp(16),
        ),
      ),
    );
  }
}

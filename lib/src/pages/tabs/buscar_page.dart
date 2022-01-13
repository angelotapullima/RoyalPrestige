import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:royal_prestige/src/utils/colors.dart';

class BuscarPage extends StatefulWidget {
  const BuscarPage({Key? key}) : super(key: key);

  @override
  State<BuscarPage> createState() => _BuscarPageState();
}

class _BuscarPageState extends State<BuscarPage> {
  final _controller = Controller();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(
          top: kBottomNavigationBarHeight + ScreenUtil().setHeight(10),
          left: ScreenUtil().setWidth(21),
          right: ScreenUtil().setWidth(21),
        ),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: colorPrimary),
                borderRadius: BorderRadius.circular(20),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: ScreenUtil().setWidth(30),
                vertical: ScreenUtil().setHeight(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Buscar...',
                    style: TextStyle(
                      color: colorOffText,
                      fontWeight: FontWeight.w300,
                      fontSize: ScreenUtil().setSp(15),
                    ),
                  ),
                  Icon(
                    Icons.search,
                    color: colorPrimary,
                    size: ScreenUtil().setHeight(20),
                  )
                ],
              ),
            ),
            SizedBox(
              height: ScreenUtil().setHeight(24),
            ),
            Container(
              height: ScreenUtil().setHeight(50),
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 6,
                  itemBuilder: (_, index) {
                    return itemChoice(index);
                  }),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 5,
                itemBuilder: (_, index) {
                  return itemProduct();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget itemChoice(int index) {
    return AnimatedBuilder(
        animation: _controller,
        builder: (_, s) {
          return InkWell(
            onTap: () {
              _controller.changeIndex(index);
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: colorPrimary),
                borderRadius: BorderRadius.circular(10),
                color: (_controller.index == index) ? colorPrimary : Colors.transparent,
              ),
              margin: EdgeInsets.all(8),
              padding: EdgeInsets.all(8),
              child: Text(
                'Especiales',
                style: TextStyle(
                  color: (_controller.index == index) ? Colors.white : Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: ScreenUtil().setSp(11),
                ),
              ),
            ),
          );
        });
  }

  Widget itemProduct() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(10), horizontal: ScreenUtil().setWidth(4)),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: ScreenUtil().setWidth(16),
          vertical: ScreenUtil().setHeight(16),
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(1, 0), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: ScreenUtil().setHeight(125),
              child: Image.asset('assets/img/picture.jpg'),
            ),
            SizedBox(
              height: ScreenUtil().setHeight(10),
            ),
            Text(
              'SET DE 15 C4672',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: ScreenUtil().setSp(15),
              ),
            ),
            Text(
              'Sarten Gourmet de 20 cm + Tapa mediana',
              style: TextStyle(
                fontWeight: FontWeight.w300,
                fontSize: ScreenUtil().setSp(11),
              ),
            ),
            SizedBox(
              height: ScreenUtil().setHeight(5),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: colorPrimary,
                  ),
                  padding: EdgeInsets.all(8),
                  child: Text(
                    'S/ 14 940,00',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: ScreenUtil().setSp(11),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class Controller extends ChangeNotifier {
  int index = 0;

  void changeIndex(int i) {
    index = i;
    notifyListeners();
  }
}

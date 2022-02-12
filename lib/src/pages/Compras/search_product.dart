import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:royal_prestige/src/bloc/provider_bloc.dart';
import 'package:royal_prestige/src/model/producto_model.dart';

enum EstadoBusqueda { inicio, datos, vacio }

class SearchProducto extends StatefulWidget {
  const SearchProducto({Key? key}) : super(key: key);

  @override
  _SearchProductoState createState() => _SearchProductoState();
}

class _SearchProductoState extends State<SearchProducto> {
  TextEditingController _controller = TextEditingController();

  dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productosBloc = ProviderBloc.productos(context);
    productosBloc.obtenerProductoPorQuery('');

    final provider = Provider.of<EstadoController>(context, listen: false);

    return Scaffold(
      body: ValueListenableBuilder(
        valueListenable: provider._estado,
        builder: (BuildContext context, EstadoBusqueda data, Widget? child) {
          return Column(
            children: [
              Container(
                color: Colors.white,
                padding: EdgeInsets.only(
                  bottom: ScreenUtil().setHeight(10),
                ),
                child: SafeArea(
                  child: Row(
                    children: [
                      BackButton(),
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                            prefixIcon: Icon(Icons.search),
                            hintText: "Buscar producto",
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.transparent),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.transparent),
                            ),
                          ),
                          onChanged: (value) {
                            provider.changeDatos();
                            productosBloc.obtenerProductoPorQuery(value);
                          },
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            provider.changeInicio();

                            _controller.text = '';
                          },
                          icon: Icon(Icons.close)),
                      SizedBox(
                        width: ScreenUtil().setWidth(10),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                child: (data == EstadoBusqueda.datos)
                    ? StreamBuilder(
                        stream: productosBloc.productosQueryStream,
                        builder: (BuildContext context, AsyncSnapshot<List<ProductoModel>> snapshot) {
                          if (snapshot.hasData) {
                            if (snapshot.data!.length > 0) {
                              return ListView.builder(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemCount: snapshot.data!.length,
                                itemBuilder: (context, i) => _itemPedido(
                                  context,
                                  snapshot.data![i],
                                ),
                              );
                            } else {
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    height: ScreenUtil().setSp(200),
                                    width: ScreenUtil().setSp(200),
                                    child: SvgPicture.asset(
                                      'assets/svg/truck.svg',
                                    ),
                                  ),
                                  Text('No existen productos'),
                                ],
                              );
                            }
                          } else {
                            return Center(
                              child: CupertinoActivityIndicator(),
                            );
                          }
                        },
                      )
                    : (data == EstadoBusqueda.inicio)
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: ScreenUtil().setSp(200),
                                width: ScreenUtil().setSp(200),
                                child: SvgPicture.asset(
                                  'assets/svg/truck.svg',
                                ),
                              ),
                              Text('Buscar productos'),
                            ],
                          )
                        : (data == EstadoBusqueda.vacio)
                            ? Container()
                            : Container(),
              )
            ],
          );
        },
      ),
    );
  }

  Widget _itemPedido(BuildContext context, ProductoModel productosData) {
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.symmetric(
          vertical: ScreenUtil().setHeight(10),
          horizontal: ScreenUtil().setWidth(18),
        ),
        padding: EdgeInsets.only(
          right: ScreenUtil().setWidth(18),
        ),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(13),
        ),
        child: Text(
          '${productosData.nombreProducto}',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w400,
            fontSize: ScreenUtil().setSp(16),
          ),
        ),
      ),
      onTap: () {
        final provider = Provider.of<EstadoController>(context, listen: false);
        provider.changeProducto(productosData.idProducto.toString(), productosData.nombreProducto.toString());
        Navigator.pop(context);
      },
    );
  }
}

class EstadoController with ChangeNotifier {
  ValueNotifier<EstadoBusqueda> _estado = ValueNotifier(EstadoBusqueda.inicio);
  ValueNotifier<EstadoBusqueda> get estado => this._estado;

  ValueNotifier<String> _idProducto = ValueNotifier('');
  ValueNotifier<String> get idProducto => this._idProducto;

  ValueNotifier<String> _nombreProducto = ValueNotifier('');
  ValueNotifier<String> get nombreProducto => this._nombreProducto;

  void changeVacio() {
    _estado.value = EstadoBusqueda.vacio;
    notifyListeners();
  }

  void changeInicio() {
    _estado.value = EstadoBusqueda.inicio;
    notifyListeners();
  }

  void changeDatos() {
    _estado.value = EstadoBusqueda.datos;
    notifyListeners();
  }

  void changeProducto(String id, String nombre) {
    _idProducto.value = id;
    _nombreProducto.value = nombre;
  }
}

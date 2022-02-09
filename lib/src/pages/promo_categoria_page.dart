import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:royal_prestige/src/bloc/provider_bloc.dart';
import 'package:royal_prestige/src/model/categoria_model.dart';
import 'package:royal_prestige/src/model/promocion_model.dart';
import 'package:royal_prestige/src/widget/show_loading.dart';

class PromoCategoriaPage extends StatefulWidget {
  const PromoCategoriaPage({Key? key, required this.promoCategoria}) : super(key: key);
  final PromocionModel promoCategoria;

  @override
  State<PromoCategoriaPage> createState() => _PromoCategoriaPageState();
}

class _PromoCategoriaPageState extends State<PromoCategoriaPage> {
  @override
  Widget build(BuildContext context) {
    final categoriaBloc = ProviderBloc.productos(context);
    categoriaBloc.obtenerCategoriasById(widget.promoCategoria.idCategoria.toString());
    return Scaffold(
      body: StreamBuilder(
          stream: categoriaBloc.categoriaIdStream,
          builder: (context, AsyncSnapshot<List<CategoriaModel>> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.length > 0) {
                return Column(
                  children: [
                    Container(
                      height: ScreenUtil().setHeight(60),
                      padding: EdgeInsets.symmetric(
                        horizontal: ScreenUtil().setWidth(10),
                        vertical: ScreenUtil().setHeight(5),
                      ),
                      child: Row(
                        children: [
                          Text(
                            'Documentos',
                            style: TextStyle(
                              fontSize: ScreenUtil().setSp(24),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              } else {
                return Center(
                  child: Text('No se encontró la promoción para la categoría'),
                );
              }
            } else {
              return ShowLoadding(
                active: true,
                colorText: Colors.black,
                fondo: Colors.transparent,
                w: double.infinity,
                h: double.infinity,
              );
            }
          }),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:royal_prestige/src/bloc/provider_bloc.dart';
import 'package:royal_prestige/src/model/galery_model.dart';
import 'package:royal_prestige/src/utils/constants.dart';
import 'package:royal_prestige/src/utils/responsive.dart';

class DetailPicture extends StatefulWidget {
  const DetailPicture({
    Key? key,
    required this.idProducto,
    required this.index,
  }) : super(key: key);

  final String idProducto;
  final String index;

  @override
  _DetailPictureState createState() => _DetailPictureState();
}

class _DetailPictureState extends State<DetailPicture> {
  @override
  Widget build(BuildContext context) {
    final galeriaBloc = ProviderBloc.galery(context);
    galeriaBloc.obtenerGalerias(widget.idProducto);
    galeriaBloc.changePage(int.parse(widget.index));

    final responsive = Responsive.of(context);
    final _pageController = PageController(viewportFraction: 1, initialPage: int.parse(widget.index));

    return StreamBuilder(
      stream: galeriaBloc.selectPageStream,
      builder: (BuildContext context, AsyncSnapshot snapshotConteo) {
        return StreamBuilder(
          stream: galeriaBloc.galeriaStream,
          builder: (context, AsyncSnapshot<List<GaleryModel>> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.length > 0) {
                return Scaffold(
                  backgroundColor: Colors.black,
                  appBar: AppBar(
                    backgroundColor: Colors.transparent,
                    actions: [
                    
                      Container(
                        height: responsive.ip(1),
                        padding: EdgeInsets.symmetric(
                          horizontal: responsive.wp(2),
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.grey[300],
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        margin: EdgeInsets.symmetric(
                          horizontal: responsive.wp(5),
                          vertical: responsive.hp(1.3),
                        ),
                        child: Row(
                          children: [
                            Text(
                              (galeriaBloc.page! + 1).toString(),
                              style: TextStyle(fontSize: responsive.ip(1.5), color: Colors.black),
                            ),
                            Text(
                              ' / ',
                              style: TextStyle(fontSize: responsive.ip(1.5), color: Colors.black),
                            ),
                            Text(
                              '${snapshot.data!.length}',
                              style: TextStyle(fontSize: responsive.ip(1.5), color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  body: PageView.builder(
                      itemCount: snapshot.data!.length,
                      controller: _pageController,
                      onPageChanged: (index) {
                        print(index);
                        galeriaBloc.changePage(index);
                      },
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onVerticalDragUpdate: (algo) {
                            if (algo.primaryDelta! > 7) {
                              Navigator.pop(context);
                            }
                          },
                          child: Stack(
                            children: <Widget>[
                              Center(
                                child: Container(
                                  width: double.infinity,
                                  child: PhotoView(
                                    imageProvider: CachedNetworkImageProvider(
                                      '$apiBaseURL/${snapshot.data![index].file}',
                                    ),
                                  ),
                                ),
                              ),
                            /*   InkWell(
                                onTap: () async {
                                  final productosApi = ProductosApi();

                                  final res = await productosApi.disabledGalery(snapshot.data![index].idGalery.toString());
                                  if (res) {
                                    final galeriaBloc = ProviderBloc.galery(context);
                                    galeriaBloc.obtenerGalerias(widget.idProducto);
                                    Navigator.pop(context);
                                  } else {
                                    showToast2('Ocurrió un error', Colors.red);
                                  }
                                },
                                child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Padding(
                                    padding: EdgeInsets.all(24),
                                    child: Container(
                                      height: ScreenUtil().setHeight(50),
                                      width: ScreenUtil().setWidth(50),
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Colors.white,
                                          )
                                          //color: Colors.white,
                                          ),
                                      child: Center(
                                        child: Icon(
                                          Icons.delete_outline,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                           */  ],
                          ),
                        );
                      }),
                );
              } else {
                return Center(
                  child: CupertinoActivityIndicator(),
                );
              }
            } else {
              return Center(
                child: CupertinoActivityIndicator(),
              );
            }
          },
        );
      },
    );
  }
}

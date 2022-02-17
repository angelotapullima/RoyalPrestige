import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:royal_prestige/src/utils/constants.dart';

class DetailPromoVista extends StatelessWidget {
  final String foto;
  const DetailPromoVista({Key? key, required this.foto}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Center(
        child: PhotoView(
          imageProvider: CachedNetworkImageProvider(
            '$apiBaseURL/$foto',
          ),
        ),
      ),
    );
  }
}

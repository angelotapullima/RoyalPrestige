import 'package:royal_prestige/src/model/galery_model.dart';

class ProductoModel {
  String? idProducto;
  String? idCategoria;
  String? codigoProducto;
  String? nombreProducto;
  String? descripcionProducto;
  String? precioProducto;
  String? regaloProducto;
  String? precioRegaloProducto;
  String? fotoProducto;
  String? estadoProducto;
  String? cantidad;
  String? subtotal;

  List<GaleryModel>? galery;

  ProductoModel({
    this.idProducto,
    this.idCategoria,
    this.codigoProducto,
    this.nombreProducto,
    this.descripcionProducto,
    this.precioProducto,
    this.regaloProducto,
    this.precioRegaloProducto,
    this.fotoProducto,
    this.estadoProducto,
    this.cantidad,
    this.subtotal,
    this.galery,
  });

  static List<ProductoModel> fromJsonList(List<dynamic> json) => json.map((i) => ProductoModel.fromJson(i)).toList();

  Map<String, dynamic> toJson() => {
        'idProducto': idProducto,
        'idCategoria': idCategoria,
        'codigoProducto': codigoProducto,
        'nombreProducto': nombreProducto,
        'descripcionProducto': descripcionProducto,
        'precioProducto': precioProducto,
        'regaloProducto': regaloProducto,
        'precioRegaloProducto': precioRegaloProducto,
        'fotoProducto': fotoProducto,
        'estadoProducto': estadoProducto,
      };

  factory ProductoModel.fromJson(Map<String, dynamic> json) => ProductoModel(
        idProducto: json["idProducto"],
        idCategoria: json["idCategoria"],
        codigoProducto: json["codigoProducto"],
        nombreProducto: json["nombreProducto"],
        descripcionProducto: json["descripcionProducto"],
        precioProducto: json["precioProducto"],
        regaloProducto: json["regaloProducto"],
        precioRegaloProducto: json["precioRegaloProducto"],
        fotoProducto: json["fotoProducto"],
        estadoProducto: json["estadoProducto"],
      );
}

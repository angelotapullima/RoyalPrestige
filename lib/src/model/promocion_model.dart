class PromocionModel {
  String? idPromo;
  String? promoTipo;
  String? idProduct;
  String? idCategoria;
  String? precioPromo;
  String? detallePromo;
  String? fechaLimitePromo;
  String? imagenPromo;
  String? estadoPromo;

  PromocionModel({
    this.idPromo,
    this.promoTipo,
    this.idProduct,
    this.idCategoria,
    this.precioPromo,
    this.detallePromo,
    this.fechaLimitePromo,
    this.imagenPromo,
    this.estadoPromo,
  });

  static List<PromocionModel> fromJsonList(List<dynamic> json) => json.map((i) => PromocionModel.fromJson(i)).toList();

  Map<String, dynamic> toJson() => {
        'idPromo': idPromo,
        'promoTipo': promoTipo,
        'idProduct': idProduct,
        'idCategoria': idCategoria,
        'precioPromo': precioPromo,
        'detallePromo': detallePromo,
        'fechaLimitePromo': fechaLimitePromo,
        'imagenPromo': imagenPromo,
        'estadoPromo': estadoPromo,
      };

  factory PromocionModel.fromJson(Map<String, dynamic> json) => PromocionModel(
        idPromo: json["idPromo"],
        promoTipo: json["promoTipo"],
        idProduct: json["idProduct"],
        idCategoria: json["idCategoria"],
        precioPromo: json["precioPromo"],
        detallePromo: json["detallePromo"],
        fechaLimitePromo: json["fechaLimitePromo"],
        imagenPromo: json["imagenPromo"],
        estadoPromo: json["estadoPromo"],
      );
}

class PromocionModel {
  String? idPromo;
  String? idProduct;
  String? idCategoria;
  String? precioPromo;
  String? detallePromo;
  String? fechaLimitePromo;
  String? imagenPromo;
  String? estadoPromo;

  PromocionModel({
    this.idPromo,
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
        idProduct: json["idProduct"],
        idCategoria: json["idCategoria"],
        precioPromo: json["precioPromo"],
        detallePromo: json["detallePromo"],
        fechaLimitePromo: json["fechaLimitePromo"],
        imagenPromo: json["imagenPromo"],
        estadoPromo: json["estadoPromo"],
      );
}

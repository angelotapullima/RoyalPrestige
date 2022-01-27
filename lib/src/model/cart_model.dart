class CartModel {
  String? idProduct;
  String? amount;
  String? subtotal;
  String? status;
  String? nombreProducto;
  String? descripcionProducto;
  String? precioProducto;
  String? regaloProducto;
  String? precioRegaloProducto;
  String? fotoProducto;

  CartModel({
    this.idProduct,
    this.amount,
    this.subtotal,
    this.status,
    this.nombreProducto,
    this.descripcionProducto,
    this.precioProducto,
    this.regaloProducto,
    this.precioRegaloProducto,
    this.fotoProducto,
  });

  static List<CartModel> fromJsonList(List<dynamic> json) => json.map((i) => CartModel.fromJson(i)).toList();

  Map<String, dynamic> toJson() => {
        'idProduct': idProduct,
        'amount': amount,
        'subtotal': subtotal,
        'status': status,
        'nombreProducto': nombreProducto,
        'descripcionProducto': descripcionProducto,
        'precioProducto': precioProducto,
        'regaloProducto': regaloProducto,
        'precioRegaloProducto': precioRegaloProducto,
        'fotoProducto': fotoProducto,
      };

  factory CartModel.fromJson(Map<String, dynamic> json) => CartModel(
        idProduct: json["idProduct"],
        amount: json["amount"],
        subtotal: json["subtotal"],
        status: json["status"],
        nombreProducto: json["nombreProducto"],
        descripcionProducto: json["descripcionProducto"],
        precioProducto: json["precioProducto"],
        regaloProducto: json["regaloProducto"],
        precioRegaloProducto: json["precioRegaloProducto"],
        fotoProducto: json["fotoProducto"],
      );
}

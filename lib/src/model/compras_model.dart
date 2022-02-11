import 'package:royal_prestige/src/model/producto_model.dart';

class ComprasModel {
  String? idCompra;
  String? idUsuario;
  String? idCliente;
  String? idProducto;
  String? montoCuotaCompra;
  String? fechaPagoCompra;
  String? fechaCompra;
  String? observacionCompra;
  String? estadoCompra;
  ProductoModel? producto;

  ComprasModel({
    this.idCompra,
    this.idUsuario,
    this.idCliente,
    this.idProducto,
    this.montoCuotaCompra,
    this.fechaPagoCompra,
    this.fechaCompra,
    this.observacionCompra,
    this.estadoCompra,
    this.producto,
  });

  static List<ComprasModel> fromJsonList(List<dynamic> json) => json.map((i) => ComprasModel.fromJson(i)).toList();

  Map<String, dynamic> toJson() => {
        'idCompra': idCompra,
        'idUsuario': idUsuario,
        'idCliente': idCliente,
        'idProducto': idProducto,
        'montoCuotaCompra': montoCuotaCompra,
        'fechaPagoCompra': fechaPagoCompra,
        'fechaCompra': fechaCompra,
        'observacionCompra': observacionCompra,
        'estadoCompra': estadoCompra,
      };

  factory ComprasModel.fromJson(Map<String, dynamic> json) => ComprasModel(
        idCompra: json["idCompra"],
        idUsuario: json["idUsuario"],
        idCliente: json["idCliente"],
        idProducto: json["idProducto"],
        montoCuotaCompra: json["montoCuotaCompra"],
        fechaPagoCompra: json["fechaPagoCompra"],
        fechaCompra: json["fechaCompra"],
        observacionCompra: json["observacionCompra"],
        estadoCompra: json["estadoCompra"],
      );
}

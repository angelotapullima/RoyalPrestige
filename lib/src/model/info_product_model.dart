class InfoProductoModel{

  String? idProDoc;
  String? idProducto;
  String? proTipo;
  String? proTitulo;
  String? proDetalle;
  String? proUrl;
  String? proEstado;

  InfoProductoModel({
    this.idProDoc,
    this.idProducto,
    this.proTipo,
    this.proTitulo,
    this.proDetalle,
    this.proUrl,
    this.proEstado,
  });

  static List<InfoProductoModel> fromJsonList(List<dynamic> json) => json.map((i) => InfoProductoModel.fromJson(i)).toList();

  Map<String, dynamic> toJson() => {
        'idProDoc': idProDoc,
        'idProducto': idProducto,
        'proTipo': proTipo,
        'proTitulo': proTitulo,
        'proDetalle': proDetalle,
        'proUrl': proUrl,
        'proEstado': proEstado,
      };

  factory InfoProductoModel.fromJson(Map<String, dynamic> json) => InfoProductoModel(
        idProDoc: json["idProDoc"],
        idProducto: json["idProducto"],
        proTipo: json["proTipo"],
        proTitulo: json["proTitulo"],
        proDetalle: json["proDetalle"],
        proUrl: json["proUrl"],
        proEstado: json["proEstado"],
      );
}

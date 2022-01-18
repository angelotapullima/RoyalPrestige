class CategoriaModel {
  String? idCategoria;
  String? nombreCategoria;
  String? estadoCategoria;

  CategoriaModel({
    this.idCategoria,
    this.nombreCategoria,
    this.estadoCategoria,
  });

  static List<CategoriaModel> fromJsonList(List<dynamic> json) => json.map((i) => CategoriaModel.fromJson(i)).toList();

  Map<String, dynamic> toJson() => {
        'idCategoria': idCategoria,
        'nombreCategoria': nombreCategoria,
        'estadoCategoria': estadoCategoria,
      };

  factory CategoriaModel.fromJson(Map<String, dynamic> json) => CategoriaModel(
        idCategoria: json["idCategoria"],
        nombreCategoria: json["nombreCategoria"],
        estadoCategoria: json["estadoCategoria"],
      );
}

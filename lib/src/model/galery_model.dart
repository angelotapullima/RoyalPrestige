class GaleryModel {
  String? idGalery;
  String? idProduct;
  String? name;
  String? file;
  String? status;

  GaleryModel({
    this.idGalery,
    this.idProduct,
    this.name,
    this.file,
    this.status,
  });

  static List<GaleryModel> fromJsonList(List<dynamic> json) => json.map((i) => GaleryModel.fromJson(i)).toList();

  Map<String, dynamic> toJson() => {
        'idGalery': idGalery,
        'idProduct': idProduct,
        'name': name,
        'file': file,
        'status': status,
      };

  factory GaleryModel.fromJson(Map<String, dynamic> json) => GaleryModel(
        idGalery: json["idGalery"],
        idProduct: json["idProduct"],
        name: json["name"],
        file: json["file"],
        status: json["status"],
      );
}

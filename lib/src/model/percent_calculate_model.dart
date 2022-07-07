class PercentCaculateModel {
  String? id;
  String? value;
  String? estado;
  String? monto;

  PercentCaculateModel({
    this.id,
    this.value,
    this.estado,
    this.monto,
  });

  static List<PercentCaculateModel> fromJsonList(List<dynamic> json) => json.map((i) => PercentCaculateModel.fromJson(i)).toList();

  Map<String, dynamic> toJson() => {
        'id': id,
        'value': value,
        'estado': estado,
        'monto': monto,
      };

  factory PercentCaculateModel.fromJson(Map<String, dynamic> json) => PercentCaculateModel(
        id: json["id"],
        value: json["value"],
        estado: json["estado"],
        monto: json["monto"],
      );
}

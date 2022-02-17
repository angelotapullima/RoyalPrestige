class CuotaModel {
  String? idCuota;
  String? cuotaNombre;
  String? cuotaMultiplicador;
  String? cuotaMostar;
  String? cuotaEstado;

  CuotaModel({
    this.idCuota,
    this.cuotaNombre,
    this.cuotaMultiplicador,
    this.cuotaMostar,
    this.cuotaEstado,
  });

  static List<CuotaModel> fromJsonList(List<dynamic> json) => json.map((i) => CuotaModel.fromJson(i)).toList();

  Map<String, dynamic> toJson() => {
        'idCuota': idCuota,
        'cuotaNombre': cuotaNombre,
        'cuotaMultiplicador': cuotaMultiplicador,
        'cuotaMostar': cuotaMostar,
        'cuotaEstado': cuotaEstado,
      };

  factory CuotaModel.fromJson(Map<String, dynamic> json) => CuotaModel(
        idCuota: json["idCuota"],
        cuotaNombre: json["cuotaNombre"],
        cuotaMultiplicador: json["cuotaMultiplicador"],
        cuotaMostar: json["cuotaMostar"],
        cuotaEstado: json["cuotaEstado"],
      );
}

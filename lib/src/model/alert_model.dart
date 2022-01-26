class AlertModel {
  String? idAlert;
  String? idUsuario;
  String? idClient;
  String? alertTitle;
  String? alertDetail;
  String? alertDate;
  String? alertHour;
  String? alertStatus;

  AlertModel({
    this.idAlert,
    this.idUsuario,
    this.idClient,
    this.alertTitle,
    this.alertDetail,
    this.alertDate,
    this.alertHour,
    this.alertStatus,
  });

  static List<AlertModel> fromJsonList(List<dynamic> json) => json.map((i) => AlertModel.fromJson(i)).toList();

  Map<String, dynamic> toJson() => {
        'idAlert': idAlert,
        'idUsuario': idUsuario,
        'idClient': idClient,
        'alertTitle': alertTitle,
        'alertDetail': alertDetail,
        'alertDate': alertDate,
        'alertHour': alertHour,
        'alertStatus': alertStatus,
      };

  factory AlertModel.fromJson(Map<String, dynamic> json) => AlertModel(
        idAlert: json["idAlert"],
        idUsuario: json["idUsuario"],
        idClient: json["idClient"],
        alertTitle: json["alertTitle"],
        alertDetail: json["alertDetail"],
        alertDate: json["alertDate"],
        alertHour: json["alertHour"],
        alertStatus: json["alertStatus"],
      );
}

class ClienteModel {
  String? idCliente;
  String? idUsuario;
  String? nombreCliente;
  String? tipoDocCliente;
  String? nroDocCliente;
  String? codigoCliente;
  String? sexoCliente;
  String? nacimientoCLiente;
  String? telefonoCliente;
  String? direccionCliente;
  String? observacionesCliente;
  String? tipo;
  String? estadoCliente;

  ClienteModel({
    this.idCliente,
    this.idUsuario,
    this.nombreCliente,
    this.tipoDocCliente,
    this.nroDocCliente,
    this.codigoCliente,
    this.sexoCliente,
    this.nacimientoCLiente,
    this.telefonoCliente,
    this.direccionCliente,
    this.observacionesCliente,
    this.tipo,
    this.estadoCliente,
  });

  static List<ClienteModel> fromJsonList(List<dynamic> json) => json.map((i) => ClienteModel.fromJson(i)).toList();

  Map<String, dynamic> toJson() => {
        'idCliente': idCliente,
        'idUsuario': idUsuario,
        'nombreCliente': nombreCliente,
        'tipoDocCliente': tipoDocCliente,
        'nroDocCliente': nroDocCliente,
        'sexoCliente': sexoCliente,
        'nacimientoCLiente': nacimientoCLiente,
        'telefonoCliente': telefonoCliente,
        'direccionCliente': direccionCliente,
        'observacionesCliente': observacionesCliente,
        'tipo': tipo,
        'estadoCliente': estadoCliente,
      };

  factory ClienteModel.fromJson(Map<String, dynamic> json) => ClienteModel(
        idCliente: json["idCliente"],
        idUsuario: json["idUsuario"],
        nombreCliente: json["nombreCliente"],
        tipoDocCliente: json["tipoDocCliente"],
        nroDocCliente: json["nroDocCliente"],
        sexoCliente: json["sexoCliente"],
        nacimientoCLiente: json["nacimientoCLiente"],
        telefonoCliente: json["telefonoCliente"],
        direccionCliente: json["direccionCliente"],
        observacionesCliente: json["observacionesCliente"],
        tipo: json["tipo"],
        estadoCliente: json["estadoCliente"],
      );
}

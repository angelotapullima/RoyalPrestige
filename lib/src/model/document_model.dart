class DocumentModel {
  String? idDocument;
  String? documentTitulo;
  String? documentDescripcion;
  String? documentFile;
  String? documentUrlInterno;
  String? documentEstado;

  DocumentModel({
    this.idDocument,
    this.documentTitulo,
    this.documentDescripcion,
    this.documentFile,
    this.documentUrlInterno,
    this.documentEstado,
  });

  static List<DocumentModel> fromJsonList(List<dynamic> json) => json.map((i) => DocumentModel.fromJson(i)).toList();

  Map<String, dynamic> toJson() => {
        'idDocument': idDocument,
        'documentTitulo': documentTitulo,
        'documentDescripcion': documentDescripcion,
        'documentFile': documentFile,
        'documentUrlInterno': documentUrlInterno,
        'documentEstado': documentEstado,
      };

  factory DocumentModel.fromJson(Map<String, dynamic> json) => DocumentModel(
        idDocument: json["idDocument"],
        documentTitulo: json["documentTitulo"],
        documentDescripcion: json["documentDescripcion"],
        documentFile: json["documentFile"],
        documentUrlInterno: json["documentUrlInterno"],
        documentEstado: json["documentEstado"],
      );
}

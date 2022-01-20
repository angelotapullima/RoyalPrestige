class DocumentModel {
  String? idDocument;
  String? documentTitulo;
  String? documentDescripcion;
  String? documentFile;
  String? documentEstado;

  DocumentModel({
    this.idDocument,
    this.documentTitulo,
    this.documentDescripcion,
    this.documentFile,
    this.documentEstado,
  });

  static List<DocumentModel> fromJsonList(List<dynamic> json) => json.map((i) => DocumentModel.fromJson(i)).toList();

  Map<String, dynamic> toJson() => {
        'idDocument': idDocument,
        'documentTitulo': documentTitulo,
        'documentDescripcion': documentDescripcion,
        'documentFile': documentFile,
        'documentEstado': documentEstado,
      };

  factory DocumentModel.fromJson(Map<String, dynamic> json) => DocumentModel(
        idDocument: json["idDocument"],
        documentTitulo: json["documentTitulo"],
        documentDescripcion: json["documentDescripcion"],
        documentFile: json["documentFile"],
        documentEstado: json["documentEstado"],
      );
}

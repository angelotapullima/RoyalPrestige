import 'package:royal_prestige/database/document_database.dart';
import 'package:royal_prestige/src/api/document_api.dart';
import 'package:royal_prestige/src/model/document_model.dart';
import 'package:rxdart/rxdart.dart';

class DocumentBloc {
  final documentDatabase = DocumentDatabase();
  final documentApi = DocumentApi();

  final _documentController = BehaviorSubject<List<DocumentModel>>();
  Stream<List<DocumentModel>> get documentStream => _documentController.stream;

  dispose() {
    _documentController.close();
  }

  void getDocument() async {
    _documentController.sink.add(await documentApi.documentDatabase.getDocument());
    await documentApi.listarDocument();
    _documentController.sink.add(await documentApi.documentDatabase.getDocument());
  }
}

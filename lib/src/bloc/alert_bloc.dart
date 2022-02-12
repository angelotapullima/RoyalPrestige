import 'package:royal_prestige/core/sharedpreferences/storage_manager.dart';
import 'package:royal_prestige/src/api/alerta_api.dart';
import 'package:royal_prestige/src/model/alert_model.dart';
import 'package:royal_prestige/src/model/fecha_alert_model.dart';
import 'package:rxdart/rxdart.dart';

class AlertBloc {
  final alertApi = AlertApi();

  final _alertController = BehaviorSubject<List<AlertModel>>();
  Stream<List<AlertModel>> get alertsStream => _alertController.stream;

  dispose() {
    _alertController.close();
  }

  void getAlerts() async {
    String? idUsuario = await StorageManager.readData('idUser');
    _alertController.sink.add(await alertApi.alertDatabase.getAlert(idUsuario!));
    await alertApi.getAlertForUser();
    _alertController.sink.add(await alertApi.alertDatabase.getAlert(idUsuario));
  }

  Future<List<FechaAlertModel>> getAlertsTodayPluss() async {
    String? idUsuario = await StorageManager.readData('idUser');
    var now = DateTime.now();
    String fecha = "${now.year.toString().padLeft(2, '0')}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

    final fechasAlertas = await alertApi.alertDatabase.getAlertByFecha(fecha, idUsuario.toString());
    print('Cantidad de fechas ${fechasAlertas.length}');
    if (fechasAlertas.length > 0) {}

    final List<FechaAlertModel> listaReturn = [];

    return listaReturn;
  }
}

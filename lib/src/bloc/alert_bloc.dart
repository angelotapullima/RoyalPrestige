import 'package:royal_prestige/core/sharedpreferences/storage_manager.dart';
import 'package:royal_prestige/database/cliente_database.dart';
import 'package:royal_prestige/src/api/alerta_api.dart';
import 'package:royal_prestige/src/api/local_notification_api.dart';
import 'package:royal_prestige/src/model/alert_model.dart';
import 'package:royal_prestige/src/model/fecha_alert_model.dart';
import 'package:royal_prestige/src/utils/utils.dart';
import 'package:rxdart/rxdart.dart';

class AlertBloc {
  final alertApi = AlertApi();
  final clienteDatabase = ClienteDatabase();

  final _alertController = BehaviorSubject<List<FechaAlertModel>>();
  Stream<List<FechaAlertModel>> get alertsStream => _alertController.stream;

  final _alertDayController = BehaviorSubject<List<AlertModel>>();
  Stream<List<AlertModel>> get alertsDayStream => _alertDayController.stream;

  dispose() {
    _alertController.close();
    _alertDayController.close();
  }

  void getAlertsForDay() async {
    var now = DateTime.now();
    String fecha = "${now.year.toString().padLeft(2, '0')}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

    String? idUsuario = await StorageManager.readData('idUser');
    _alertDayController.sink.add(await alertApi.alertDatabase.getAlertByFecha(fecha, idUsuario!));
    await alertApi.getAlertForUser();
    _alertDayController.sink.add(await alertApi.alertDatabase.getAlertByFecha(fecha, idUsuario));
  }

  void getAlertsTodayPluss() async {
    _alertController.sink.add(await getAlertsTodayPluss2());
    await alertApi.getAlertForUser();
    _alertController.sink.add(await getAlertsTodayPluss2());
  }

  Future<List<FechaAlertModel>> getAlertsTodayPluss2() async {
    final List<String> listDates = [];
    final List<FechaAlertModel> listaReturn = [];
    String? idUsuario = await StorageManager.readData('idUser');
    var now = DateTime.now();
    String fecha = "${now.year.toString().padLeft(2, '0')}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

    final fechasAlertas = await alertApi.alertDatabase.getAlertByFechaGroupByDate(fecha, idUsuario.toString());
    print('Cantidad de fechas ${fechasAlertas.length}');
    if (fechasAlertas.length > 0) {
      for (var i = 0; i < fechasAlertas.length; i++) {
        listDates.add(fechasAlertas[i].alertDate.toString());
      }
    }

    if (listDates.length > 0) {
      for (var x = 0; x < listDates.length; x++) {
        final List<AlertModel> alertSubList = [];
        //final List<String> horitas = [];
        FechaAlertModel fechaAlertModel = FechaAlertModel();
        fechaAlertModel.fecha = obtenerFecha(listDates[x].toString());

        final fechix = await alertApi.alertDatabase.getAlertByFecha(listDates[x].toString(), idUsuario!);

        if (fechix.length > 0) {
          for (var y = 0; y < fechix.length; y++) {
            final clients = await clienteDatabase.getClientPorIdCliente(fechix[y].idClient.toString());

            DateTime fechita = DateTime.parse('${fechix[y].alertDate} ${fechix[y].alertHour}');

            if (fechita.isAfter(DateTime.now())) {
              Duration _horas = fechita.difference(DateTime.now());

              if (_horas.inHours < 1) {
                LocalNotificationApi.showAlertProgramado(
                  id: y,
                  title: '${fechix[y].alertTitle}',
                  body: "${fechix[y].alertDetail} | Hoy a las ${fechix[y].alertHour} horas" + "\t" + "Cliente: ${clients[0].nombreCliente}",
                  playLoad: '-',
                  time: DateTime.now().add(Duration(seconds: 2)),
                );
              } else if (_horas.inHours == 1) {
                LocalNotificationApi.showAlertProgramado(
                  id: y,
                  title: '${fechix[y].alertTitle}',
                  body: '${fechix[y].alertDetail} | Hoy a las ${fechix[y].alertHour} horas',
                  playLoad: '-',
                  time: DateTime.now().add(Duration(hours: 1)),
                );
              }
            }

            AlertModel alertModel = AlertModel();

            alertModel.nombreCLiente = (clients.length > 0) ? clients[0].nombreCliente : '';
            alertModel.telefonoCliente = (clients.length > 0) ? clients[0].telefonoCliente : '';
            alertModel.idAlert = fechix[y].idAlert;
            alertModel.idUsuario = fechix[y].idUsuario;
            alertModel.idClient = fechix[y].idClient;
            alertModel.alertTitle = fechix[y].alertTitle;
            alertModel.alertDetail = fechix[y].alertDetail;
            alertModel.alertDate = fechix[y].alertDate;
            alertModel.alertHour = obtenerHora(fechix[y].alertHour.toString());
            alertModel.alertStatus = fechix[y].alertStatus;
            alertSubList.add(alertModel);
          }
        }

        fechaAlertModel.alertas = alertSubList;

        listaReturn.add(fechaAlertModel);
      }
    }

    print('ctm');

    return listaReturn;
  }
}

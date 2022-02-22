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

  final _alertIdController = BehaviorSubject<List<AlertModel>>();
  Stream<List<AlertModel>> get alertsIdStream => _alertIdController.stream;

  dispose() {
    _alertController.close();
    _alertDayController.close();
    _alertIdController.close();
  }

  void getAlertsForDay() async {
    var now = DateTime.now();
    String fecha = "${now.year.toString().padLeft(2, '0')}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
    //String fecha = "2022-02-18";

    String? idUsuario = await StorageManager.readData('idUser');
    _alertDayController.sink.add(await alertesByFecha(fecha, idUsuario!));
    await alertApi.getAlertForUser();
    _alertDayController.sink.add(await alertesByFecha(fecha, idUsuario));
  }

  Future<List<AlertModel>> alertesByFecha(String fecha, String idUser) async {
    final List<AlertModel> listReturn = [];

    final listdd = await alertApi.alertDatabase.getAlertByFecha(fecha, idUser);
    if (listdd.length > 0) {
      for (var i = 0; i < listdd.length; i++) {
        DateTime fechita = DateTime.parse('${listdd[i].alertDate} ${listdd[i].alertHour}');
        if (fechita.isAfter(DateTime.now())) {
          final client = await clienteDatabase.getClientPorIdCliente(listdd[i].idClient.toString());

          AlertModel alertModel = AlertModel();

          alertModel.nombreCLiente = (client.length > 0) ? client[0].nombreCliente : '';
          alertModel.telefonoCliente = (client.length > 0) ? client[0].telefonoCliente : '';
          alertModel.idAlert = listdd[i].idAlert;
          alertModel.idUsuario = listdd[i].idUsuario;
          alertModel.idClient = listdd[i].idClient;
          alertModel.alertTitle = listdd[i].alertTitle;
          alertModel.alertDetail = listdd[i].alertDetail;
          alertModel.alertDate = obtenerFecha(listdd[i].alertDate.toString());
          alertModel.alertHour = obtenerHora(listdd[i].alertHour.toString());
          alertModel.alertStatus = listdd[i].alertStatus;
          listReturn.add(alertModel);
        }
      }
    }

    return listReturn;
  }

  void getAlertsTodayPluss() async {
    _alertController.sink.add(await getAlertsTodayPluss2());
    await alertApi.getAlertForUser();
    _alertController.sink.add(await getAlertsTodayPluss2());
  }

  void getAlertById(String idAlert) async {
    _alertIdController.sink.add(await getAlertId(idAlert));
  }

  Future<List<AlertModel>> getAlertId(String idAlert) async {
    final List<AlertModel> listReturn = [];
    final alertDB = await alertApi.alertDatabase.getAlertByIdAlert(idAlert);

    if (alertDB.length > 0) {
      final client = await clienteDatabase.getClientPorIdCliente(alertDB[0].idClient.toString());

      if (client.length > 0) {
        AlertModel alertModel = AlertModel();

        alertModel.nombreCLiente = (client.length > 0) ? client[0].nombreCliente : '';
        alertModel.telefonoCliente = (client.length > 0) ? client[0].telefonoCliente : '';
        alertModel.idAlert = alertDB[0].idAlert;
        alertModel.idUsuario = alertDB[0].idUsuario;
        alertModel.idClient = alertDB[0].idClient;
        alertModel.alertTitle = alertDB[0].alertTitle;
        alertModel.alertDetail = alertDB[0].alertDetail;
        alertModel.alertDate = obtenerFecha(alertDB[0].alertDate.toString());
        alertModel.alertHour = obtenerHora(alertDB[0].alertHour.toString());
        alertModel.alertStatus = alertDB[0].alertStatus;
        listReturn.add(alertModel);
      } else if (alertDB[0].idClient == '0') {
        AlertModel alertModel = AlertModel();

        alertModel.idAlert = alertDB[0].idAlert;
        alertModel.idUsuario = alertDB[0].idUsuario;
        alertModel.idClient = alertDB[0].idClient;
        alertModel.alertTitle = alertDB[0].alertTitle;
        alertModel.alertDetail = alertDB[0].alertDetail;
        alertModel.alertDate = obtenerFecha(alertDB[0].alertDate.toString());
        alertModel.alertHour = obtenerHora(alertDB[0].alertHour.toString());
        alertModel.alertStatus = alertDB[0].alertStatus;
        listReturn.add(alertModel);
      }
    }
    return listReturn;
  }

  Future<List<FechaAlertModel>> getAlertsTodayPluss2() async {
    final List<String> listDates = [];
    final List<FechaAlertModel> listaReturn = [];
    String? idUsuario = await StorageManager.readData('idUser');
    var now = DateTime.now();
    String fecha = "${now.year.toString().padLeft(2, '0')}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

    final fechasAlertas = await alertApi.alertDatabase.getAlertByFechaGroupByDate(fecha, idUsuario.toString());

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
                  body: "${fechix[y].alertDetail} | Hoy a las ${fechix[y].alertHour} horas 2",
                  playLoad: '${fechix[y].idAlert}',
                  time: DateTime.now().add(
                    Duration(seconds: 2),
                  ),
                );
              } else {
                LocalNotificationApi.showAlertProgramado(
                  id: y,
                  title: '${fechix[y].alertTitle}',
                  body: '${fechix[y].alertDetail} | Hoy a las ${fechix[y].alertHour} horas 3',
                  playLoad: '${fechix[y].idAlert}',
                  time: DateTime.now().add(
                    Duration(
                      hours: _horas.inHours,
                      minutes: _horas.inMinutes,
                    ),
                  ),
                );
              }
              LocalNotificationApi.showAlertProgramado(
                id: y,
                title: '${fechix[y].alertTitle}',
                body: '${fechix[y].alertDetail} | Hoy a las ${fechix[y].alertHour} horas 3',
                playLoad: '${fechix[y].idAlert}',
                time: DateTime.now().add(
                  Duration(
                    hours: _horas.inHours,
                    minutes: _horas.inMinutes,
                  ),
                ),
              );
              AlertModel alertModel = AlertModel();

              alertModel.nombreCLiente = (clients.length > 0) ? clients[0].nombreCliente : '';
              alertModel.telefonoCliente = (clients.length > 0) ? clients[0].telefonoCliente : '';
              alertModel.idAlert = fechix[y].idAlert;
              alertModel.idUsuario = fechix[y].idUsuario;
              alertModel.idClient = fechix[y].idClient;
              alertModel.alertTitle = fechix[y].alertTitle;
              alertModel.alertDetail = fechix[y].alertDetail;
              alertModel.alertDate = fechix[y].alertDate;
              alertModel.alertHour = obtenerHora(
                fechix[y].alertHour.toString(),
              );
              alertModel.alertStatus = fechix[y].alertStatus;
              alertSubList.add(alertModel);
            }
          }
        }

        fechaAlertModel.alertas = alertSubList;
        if (alertSubList.length > 0) {
          listaReturn.add(fechaAlertModel);
        }
      }
    }

    return listaReturn;
  }
}

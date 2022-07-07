import 'package:royal_prestige/src/api/login_api.dart';
import 'package:royal_prestige/src/model/percent_calculate_model.dart';
import 'package:rxdart/rxdart.dart';

class PercenteBloc {
  final _api = LoginApi();
  final _percentsController = BehaviorSubject<List<PercentCaculateModel>>();
  Stream<List<PercentCaculateModel>> get percentsStream => _percentsController.stream;

  dispose() {
    _percentsController.close();
  }

  void cargarPercents() async {
    await _api.percentBD.updateAllPercent();
    _percentsController.sink.add(await _api.percentBD.getPercentAll());
    await _api.consultarUsuario();
    _percentsController.sink.add(await _api.percentBD.getPercentAll());
  }

  void updateMontoPercent(String monto) async {
    final list = await _api.percentBD.getPercentAll();

    double mont = double.parse(monto);

    for (var i = 0; i < list.length; i++) {
      double percent = double.parse(list[i].value.toString());
      double monto = mont * percent;
      await _api.percentBD.updatePercent(list[i].id.toString(), monto.round().toStringAsFixed(2));
    }

    _percentsController.sink.add(await _api.percentBD.getPercentAll());
  }

  void updateMontoPercentInit(String monto) async {
    double mont = double.parse(monto);

    await _api.percentBD.updateAllPercent();
    final list0 = await _api.percentBD.getPercentAll();
    for (var i = 0; i < list0.length; i++) {
      double percent = double.parse(list0[i].value.toString());
      double monto = mont * percent;
      await _api.percentBD.updatePercent(list0[i].id.toString(), monto.round().toStringAsFixed(2));
    }
    _percentsController.sink.add(await _api.percentBD.getPercentAll());
    await _api.consultarUsuario();
    final list = await _api.percentBD.getPercentAll();
    for (var i = 0; i < list.length; i++) {
      double percent = double.parse(list[i].value.toString());
      double monto = mont * percent;
      await _api.percentBD.updatePercent(list[i].id.toString(), monto.round().toStringAsFixed(2));
    }

    _percentsController.sink.add(await _api.percentBD.getPercentAll());
  }
}

import 'package:royal_prestige/src/api/cuota_api.dart';
import 'package:royal_prestige/src/model/cuota_model.dart';
import 'package:rxdart/rxdart.dart';

class CuotaBloc {
  final cuotaApi = CuotaApi();

  final _cuotaController = BehaviorSubject<List<CuotaModel>>();
  Stream<List<CuotaModel>> get cuotaStream => _cuotaController.stream;

  final _cuotasMostrarController = BehaviorSubject<List<CuotaModel>>();
  Stream<List<CuotaModel>> get cuotasMostrarStream => _cuotasMostrarController.stream;
//getCuotasMostar
  dispose() {
    _cuotaController.close();
    _cuotasMostrarController.close();
  }

  void getCuota() async {
    _cuotaController.sink.add(await cuotaApi.cuotaDatabase.getCuotas());
    await cuotaApi.getCuotas();
    _cuotaController.sink.add(await cuotaApi.cuotaDatabase.getCuotas());
  }

  void getCuotasMostar() async {
    _cuotasMostrarController.sink.add(await cuotaApi.cuotaDatabase.getCuotasMostar());
  }
}

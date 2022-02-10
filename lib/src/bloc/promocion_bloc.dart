import 'package:royal_prestige/src/api/promocion_api.dart';
import 'package:royal_prestige/src/model/promocion_model.dart';
import 'package:rxdart/rxdart.dart';

class PromocionBloc {
  final promoApi = PromocionApi();

  final _promocionController = BehaviorSubject<List<PromocionModel>>();

  Stream<List<PromocionModel>> get promocionStream => _promocionController.stream;

  dipose() {
    _promocionController.close();
  }

  void obtenerPromos() async {
    _promocionController.sink.add(await promoApi.promoDatabase.getPromocion());
    await promoApi.listarPromociones();
    _promocionController.sink.add(await promoApi.promoDatabase.getPromocion());
  }
}

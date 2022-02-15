import 'package:royal_prestige/core/sharedpreferences/storage_manager.dart';
import 'package:royal_prestige/src/api/login_api.dart';
import 'package:royal_prestige/src/model/api_model.dart';
import 'package:rxdart/rxdart.dart';

class DataUserBloc {
  final loginApi = LoginApi();
  final _dataUserController = BehaviorSubject<UserModel>();
  final _estadouserController = BehaviorSubject<ApiModel>();

  Stream<UserModel> get userStream => _dataUserController.stream;
  Stream<ApiModel> get estadoUserStream => _estadouserController.stream;

  dispose() {
    _dataUserController.close();
    _estadouserController.close();
  }

  void getEstatusUser() async {
    _estadouserController.sink.add(await loginApi.consultarUsuario());
  }

  void obtenerUser() async {
    UserModel userModel = UserModel();
    userModel.idUser = await StorageManager.readData('idUser');
    userModel.idPerson = await StorageManager.readData('idPerson');
    userModel.userNickname = await StorageManager.readData('userNickname');
    userModel.userEmail = await StorageManager.readData('userEmail');
    userModel.userImage = await StorageManager.readData('userImage');
    userModel.personName = await StorageManager.readData('personName');
    userModel.personSurname = await StorageManager.readData('personSurname');
    userModel.idRoleUser = await StorageManager.readData('idRoleUser');
    userModel.roleName = await StorageManager.readData('roleName');
    _dataUserController.sink.add(userModel);
  }
}

class UserModel {
  String? idUser;
  String? idPerson;
  String? userNickname;
  String? userEmail;
  String? userImage;
  String? personName;
  String? personSurname;
  String? idRoleUser;
  String? roleName;

  UserModel({
    this.idUser,
    this.idPerson,
    this.userNickname,
    this.userEmail,
    this.userImage,
    this.personName,
    this.personSurname,
    this.idRoleUser,
    this.roleName,
  });
}

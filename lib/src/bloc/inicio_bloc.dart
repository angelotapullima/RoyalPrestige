import 'package:flutter/material.dart';

enum MenuIniciostate {
  open,
  closed,
}

class HomeBloc with ChangeNotifier {
  MenuIniciostate menuState = MenuIniciostate.closed;

  void changeToOpen() {
    menuState = MenuIniciostate.open;
    notifyListeners();
  }

  void changeToClosed() {
    menuState = MenuIniciostate.closed;
    notifyListeners();
  }
}

import 'package:flutter/material.dart';

class ProviderBloc extends InheritedWidget {
  ProviderBloc({Key? key, required Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(ProviderBloc oldWidget) => true;
}

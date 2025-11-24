import 'package:flutter/material.dart';

enum UserMode { Servicer, Usu }

class Userrole extends ChangeNotifier {
  UserMode _mode = UserMode.Usu;

  bool get isUsu {
    return _mode == UserMode.Usu;
  }

  bool get isServicer {
    return _mode == UserMode.Servicer;
  }

  void changeToServicer() {
    _mode = UserMode.Servicer;
    notifyListeners();
  }

  void changeToClient() {
    _mode = UserMode.Usu;
    notifyListeners();
  }

  void toggleMode() {
    _mode = isUsu ? UserMode.Servicer : UserMode.Usu;
    notifyListeners();
  }
}

import 'package:flutter/material.dart';
import 'package:ijob/Entities/profileUser.dart';

class Profileuserlist extends ChangeNotifier {
  List<Profileuser> _profileList = [];

  List<Profileuser> get profileLists {
    return [..._profileList];
  }

  void addProfiler(Profileuser profiler) {
    _profileList.add(profiler);
    notifyListeners();
  }

  Profileuser? searchProfiler(String id) {
    return _profileList.where((pro) => pro.id == id).toList().firstOrNull;
  }
}

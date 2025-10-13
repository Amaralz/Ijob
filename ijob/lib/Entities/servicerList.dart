import 'package:flutter/material.dart';
import 'package:ijob/Data/dummyData.dart';
import 'package:ijob/Entities/categor.dart';
import 'package:ijob/Entities/servicer.dart';

class Servicerlist extends ChangeNotifier {
  List<Servicer> _servicers = DummyServicer;

  List<Servicer> get servicers => [..._servicers];
  List<Servicer> servicersByCategorie(Categor categorie) {
    return _servicers
        .where((serv) => serv.category!.id == categorie.id)
        .toList();
  }

  void addServicer(Servicer servicer) {
    _servicers.add(servicer);
    notifyListeners();
  }

  void removeServicer(Servicer servicer) {
    _servicers.remove(servicer);
    notifyListeners();
  }
}

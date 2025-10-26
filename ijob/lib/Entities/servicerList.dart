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

  List<Servicer> searchServicerServicersByCategorie(
    Categor categorie,
    String searcher,
  ) {
    return _servicers
        .where(
          (serv) =>
              serv.category! == categorie.id &&
              serv.nome!.toLowerCase().startsWith(searcher),
        )
        .toList();
  }

  List<Servicer> searchServicer(String search) {
    return _servicers
        .where((servicer) => servicer.nome!.toLowerCase().startsWith(search))
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

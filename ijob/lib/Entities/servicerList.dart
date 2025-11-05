import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ijob/Entities/categor.dart';
import 'package:ijob/Entities/servicer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Servicerlist extends ChangeNotifier {
  final _db = FirebaseFirestore.instance.collection("servicer");
  List<Servicer> _servicers = [];

  List<Servicer> get servicers => [..._servicers];

  List<Servicer> servicersByCategorie(Categor categorie) {
    final list = _servicers.where((serv) {
      return serv.category!.any((cat) {
        return cat == categorie.id;
      });
    }).toList();
    return list;
  }

  List<Servicer> searchServicerServicersByCategorie(
    Categor categorie,
    String searcher,
  ) {
    final list = servicersByCategorie(
      categorie,
    ).where((serv) => serv.nome!.toLowerCase().startsWith(searcher)).toList();
    return list;
  }

  List<Servicer> searchServicer(String search) {
    return _servicers
        .where((servicer) => servicer.nome!.toLowerCase().startsWith(search))
        .toList();
  }

  Future<void> loadServicers() async {
    _servicers.clear();
    try {
      final query = await _db.get();
      _servicers = query.docs
          .map((serv) => Servicer.fromSnapshot(serv))
          .toList();
    } catch (e) {
      print("ERRO DETECTADO: ${e.toString()}");
    }
    notifyListeners();
  }

  Future<void> createServicer(User user, Servicer servicer) async {
    String uid = user.uid;
    final docRef = _db.doc(uid);
    await docRef.set(servicer.toJson());
    _servicers.add(servicer);
    notifyListeners();
  }

  void removeServicer(Servicer servicer) {
    _servicers.remove(servicer);
    notifyListeners();
  }
}

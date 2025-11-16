import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ijob/Core/Entities/categor.dart';
import 'package:ijob/Core/Entities/servicer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Servicerlist extends ChangeNotifier {
  final _db = FirebaseFirestore.instance.collection("users");
  List<Servicer> _servicers = [];

  Servicer? _servicerUser;

  List<Servicer> get servicers => [..._servicers];

  Servicer get servicerUser => _servicerUser!;

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

  Future<bool> _verificarCpfUnico(Servicer user) async {
    final snapshot = await _db.where('cpf', isEqualTo: user.cpf).limit(1).get();
    return snapshot.docs.isEmpty;
  }

  Future<bool> _verificarCelularUnico(Servicer user) async {
    final snapshot = await _db
        .where('celular', isEqualTo: user.celular)
        .limit(1)
        .get();
    return snapshot.docs.isEmpty;
  }

  Future<void> loadServicers() async {
    _servicers.clear();
    try {
      final query = await _db.where('role', isEqualTo: 1).get();
      _servicers = query.docs
          .map((serv) => Servicer.fromSnapshot(serv))
          .toList();
      notifyListeners();
    } catch (e) {
      print("ERRO DETECTADO: ${e.toString()}");
    }
  }

  Future<void> loadServicerUser(User user) async {
    final query = await _db.doc(user.uid).get();
    if (query.exists) {
      _servicerUser = Servicer.fromSnapshot(query);

      notifyListeners();
    } else {
      throw Exception("Servicer não encontrado");
    }
  }

  final Map<String, Servicer> _servicerCache = {};

  Future<Servicer?> getServicer(String uid) async {
    if (_servicerCache.containsKey(uid)) {
      return _servicerCache[uid];
    }

    try {
      final query = await _db.doc(uid).get();
      Servicer serv = Servicer.fromSnapshot(query);

      _servicerCache[uid] = serv;

      return serv;
    } catch (e) {
      print("ERROOOOOOOOO");
      return null;
    }
  }

  Future<void> createServicer(User user, Servicer servicer) async {
    String response = '';
    try {
      String uid = user.uid;
      final docRef = _db.doc(uid);

      bool cpfU = await _verificarCpfUnico(servicer);
      bool teleU = await _verificarCelularUnico(servicer);

      if (!cpfU) {
        response = 'CPF já existe em outra conta!';
        return;
      }

      if (!teleU) {
        response = 'Celular já existe em outra conta!';
        return;
      }
      await docRef.set(servicer.toJson());
      _servicers.add(servicer);
    } catch (e) {
      throw response;
    }
    notifyListeners();
  }

  void removeServicer(Servicer servicer) {
    _servicers.remove(servicer);
    notifyListeners();
  }

  Future<bool> existsServicer(User user) async {
    final verify = await _db.where('id', isEqualTo: user.uid).get();

    if (verify.docs.isNotEmpty) {
      return true;
    } else
      return false;
  }

  Future<void> deactivateServicer(Servicer serv) async {
    final query = _db.doc(serv.id);

    Servicer servicer = Servicer(
      id: serv.id,
      nome: serv.nome,
      category: serv.category,
      cpf: serv.cpf,
      endereco: serv.endereco,
      celular: serv.celular,
      email: serv.email,
      rating: serv.rating,
      url: serv.url,
      role: serv.role,
      active: false,
    );

    try {
      await query.update(servicer.toJson());
    } catch (error) {
      throw "Erro ao tentar desativar servicer";
    }
  }

  Future<void> updateServicer(Servicer serv) async {
    final query = _db.doc(serv.id);

    Servicer servicer = Servicer(
      id: serv.id,
      nome: serv.nome,
      category: serv.category,
      cpf: serv.cpf,
      endereco: serv.endereco,
      celular: serv.celular,
      email: serv.email,
      rating: serv.rating,
      url: serv.url,
      role: serv.role,
    );

    try {
      await query.update(servicer.toJson());
    } catch (error) {
      throw "Erro ao tentar atualizar servicer";
    }
  }
}

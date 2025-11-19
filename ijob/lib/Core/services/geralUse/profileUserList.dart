import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ijob/Core/Entities/profileUser.dart';

class Profileuserlist extends ChangeNotifier {
  Profileuser? _profile;

  Profileuser get profile => _profile!;

  final _db = FirebaseFirestore.instance.collection("users");

  Future<bool> _verificarCpfUnico(Profileuser profile) async {
    final snapshot = await _db
        .where('cpf', isEqualTo: profile.cpf)
        .limit(1)
        .get();
    return snapshot.docs.isEmpty;
  }

  Future<bool> _verificarCelularUnico(Profileuser profile) async {
    final snapshot = await _db
        .where('celular', isEqualTo: profile.celular)
        .limit(1)
        .get();
    return snapshot.docs.isEmpty;
  }

  Future<void> createUserProfile(
    User firebaseuser,
    Profileuser profileData,
  ) async {
    String response = '';
    try {
      String uid = firebaseuser.uid;
      final docRef = _db.doc(uid);

      bool cpfU = await _verificarCpfUnico(profileData);
      bool teleU = await _verificarCelularUnico(profileData);

      if (!cpfU) {
        response = 'CPF já existe em outra conta!';
        return;
      }

      if (!teleU) {
        response = 'Celular já existe em outra conta!';
        return;
      }

      await docRef.set(profileData.toJson());
      notifyListeners();
    } catch (e) {
      print(response);
      throw response;
    }
  }

  final Map<String, Profileuser> _profilerCache = {};

  Future<Profileuser?> getProfile(String uid) async {
    if (_profilerCache.containsKey(uid)) {
      return _profilerCache[uid];
    }

    try {
      final query = await _db.doc(uid).get();
      Profileuser profile = Profileuser.fromSnapshot(query);

      _profilerCache[uid] = profile;

      return profile;
    } catch (e) {
      print("ERROOOOOOOOO");
      return null;
    }
  }

  Future<void> loadProfileUser(User user) async {
    final query = await _db.doc(user.uid).get();
    if (query.exists) {
      _profile = Profileuser.fromSnapshot(query);

      notifyListeners();
    } else {
      throw Exception("ProfileUser não encontrado");
    }
  }

  Future<bool> existsProfileUser(User user) async {
    final verify = await _db.where('id', isEqualTo: user.uid).get();

    if (verify.docs.isNotEmpty) {
      return true;
    } else
      return false;
  }

  Future<void> deactivateUser(Profileuser user) async {
    final query = _db.doc(user.id);

    Profileuser profiler = Profileuser(
      id: user.id,
      nome: user.nome,
      cpf: user.cpf,
      endereco: user.endereco,
      celular: user.celular,
      email: user.email,
      role: user.role,
      url: user.url,
      genero: user.genero,
      active: false,
    );

    try {
      await query.update(profiler.toJson());
    } catch (error) {
      throw "Error ao tentar desativar conta";
    }
  }

  Future<void> updateProfile(Profileuser user) async {
    final query = _db.doc(user.id);

    Profileuser profiler = Profileuser(
      id: user.id,
      nome: user.nome,
      cpf: user.cpf,
      endereco: user.endereco,
      celular: user.celular,
      email: user.email,
      role: user.role,
      url: user.url,
      genero: user.genero,
    );

    try {
      await query.update(profiler.toJson());
    } catch (error) {
      throw "Error ao tentar atualizar conta";
    }
  }
}

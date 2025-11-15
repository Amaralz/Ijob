import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ijob/Core/Entities/requestMessage.dart';

class Requestmessageservices extends ChangeNotifier {
  final _db = FirebaseFirestore.instance;

  List<Requestmessage> _requests = [];

  List<Requestmessage> get requests {
    return [..._requests];
  }

  CollectionReference<Map<String, dynamic>> _getColection(String chatId) {
    return _db.collection('chat').doc(chatId).collection('requests');
  }

  StreamSubscription? _requestSubscription;

  Future<void> loadRequests(String chatId) async {
    _requestSubscription?.cancel();
    try {
      final store = _getColection(chatId).snapshots();
      _requestSubscription = store.listen((snapshot) {
        _requests = snapshot.docs.map((doc) {
          return Requestmessage.fromSnapshot(doc);
        }).toList();
        notifyListeners();
      });
    } catch (error) {
      throw "Erro inesperado ao tentar carregar pedidos";
    }
  }

  void disposeRequest() {
    _requestSubscription?.cancel();
    _requests = [];
  }

  Future<void> newMessage(String chatId, Requestmessage msg) async {
    await _getColection(chatId)
        .withConverter(
          fromFirestore: (snapshot, options) =>
              Requestmessage.fromSnapshot(snapshot),
          toFirestore: (chatMsg, options) => chatMsg.toJson(),
        )
        .add(msg);
  }

  Future<void> messageAccepted(
    Requestmessage msg,
    bool accepted,
    String uid,
  ) async {
    final query = _getColection(uid).doc(msg.id);

    final newStatusRequest = Requestmessage(
      id: msg.id,
      categor: msg.categor,
      definedAt: msg.definedAt,
      state: accepted,
      value: msg.value,
      createdAt: msg.createdAt,
      userId: msg.userId,
      servicerId: msg.servicerId,
    );
    if (accepted == true) {
      await query.update(newStatusRequest.toJson());
    } else {
      await query.delete();
    }

    notifyListeners();
  }

  Future<void> deleteRequest(String uid, String? msgId) async {
    final query = _getColection(uid).doc(msgId);

    try {
      await query.delete();
    } catch (error) {
      throw "Erro ao excluir request";
    }
  }
}

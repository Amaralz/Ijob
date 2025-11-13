import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ijob/Core/Entities/chat.dart';

class Chatservices extends ChangeNotifier {
  final _db = FirebaseFirestore.instance.collection('chat');
  List<Chat> _chats = [];

  StreamSubscription<QuerySnapshot>? _chatSubscription;

  List<Chat> get chats {
    return [..._chats];
  }

  Future<void> loadChats(String? userId) async {
    _chatSubscription?.cancel();

    try {
      _chatSubscription = _db
          .where('participants', arrayContains: userId)
          .snapshots()
          .listen((snapshot) {
            _chats = snapshot.docs
                .map((doc) => Chat.fromSnapshot(doc))
                .toList();
            notifyListeners();
          });
    } catch (error) {
      print("$error");
      throw 'Erro inesperado no carregamento das conversas';
    }
  }

  Future<void> createChat(Chat chat) async {
    try {
      await _db.add(chat.toJson()).then((docu) => chat.id = docu.id);
    } catch (error) {
      throw 'Erro inesperado ao criar uma conversa';
    }
  }

  Future<bool> checkExistingChat(String? userId, String? servicerId) async {
    if (userId == null || servicerId == null) {
      return false;
    }

    try {
      final checker = await _db
          .where('participants', arrayContains: userId)
          .get();
      final bool exists = checker.docs.any((doc) {
        final data = doc.data();
        final participants = List.from(data['participants'] ?? []);
        return participants.contains(servicerId);
      });

      return exists;
    } catch (error) {
      throw 'Erro inesperado ao checar existência de chat';
    }
  }

  void cleanListen() {
    _chatSubscription?.cancel();
    _chats = [];
    notifyListeners();
  }
}

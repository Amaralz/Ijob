import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ijob/Core/Entities/chatMessage.dart';

class Messageservices {
  final _db = FirebaseFirestore.instance;

  CollectionReference _getColection(String chatId) {
    return _db.collection('chat').doc(chatId).collection('messages');
  }

  Stream<List<Chatmessage>> loadMessageStream(String chatId) {
    final store = _getColection(chatId);
    final snapshots = store
        .withConverter(
          fromFirestore: (snapshot, options) =>
              Chatmessage.fromSnapshot(snapshot),
          toFirestore: (chatMsg, options) => chatMsg.toJson(),
        )
        .orderBy('createdAt', descending: true)
        .snapshots();

    return snapshots.map((snapshot) {
      return snapshot.docs.map((snap) {
        return snap.data();
      }).toList();
    });
  }

  Future<Chatmessage?> newMessage(String chatId, Chatmessage msg) async {
    final docRef = await _getColection(chatId)
        .withConverter(
          fromFirestore: (snapshot, options) =>
              Chatmessage.fromSnapshot(snapshot),
          toFirestore: (chatMsg, options) => chatMsg.toJson(),
        )
        .add(msg);
    final doc = await docRef.get();
    return doc.data()!;
  }
}

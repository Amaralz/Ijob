import 'package:cloud_firestore/cloud_firestore.dart';

class Chatmessage {
  final String id;
  final String text;
  final DateTime createdAt;

  final String userId;

  const Chatmessage({
    required this.id,
    required this.text,
    required this.createdAt,
    required this.userId,
  });

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'createdAt': createdAt.toIso8601String(),
      'userId': userId,
    };
  }

  factory Chatmessage.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> docu,
  ) {
    final data = docu.data()!;
    return Chatmessage(
      id: docu.id,
      text: data['text'],
      createdAt: DateTime.parse(data['createdAt']),
      userId: data['userId'],
    );
  }
}

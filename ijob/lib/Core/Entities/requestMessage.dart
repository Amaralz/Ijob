import 'package:cloud_firestore/cloud_firestore.dart';

class Requestmessage {
  String id;
  String categor;
  int value;
  bool state;
  DateTime createdAt;
  DateTime definedAt;
  String userId;
  String servicerId;

  Requestmessage({
    required this.id,
    required this.categor,
    required this.state,
    required this.value,
    required this.createdAt,
    required this.definedAt,
    required this.userId,
    required this.servicerId,
  });

  Map<String, dynamic> toJson() {
    return {
      'categor': categor,
      'value': value,
      'state': state,
      'createdAt': createdAt.toIso8601String(),
      'definedAt': definedAt.toIso8601String(),
      'userId': userId,
      'servicerId': servicerId,
    };
  }

  factory Requestmessage.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> docu,
  ) {
    final data = docu.data()!;
    return Requestmessage(
      id: docu.id,
      userId: data['userId'],
      servicerId: data['servicerId'],
      categor: data['categor'],
      state: data['state'],
      value: data['value'],
      createdAt: DateTime.parse(data['createdAt']),
      definedAt: DateTime.parse(data['definedAt']),
    );
  }
}

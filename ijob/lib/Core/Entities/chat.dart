import 'package:cloud_firestore/cloud_firestore.dart';

enum Situation { Ativa, Finalizada }

class Chat {
  String id;
  List<String> participants;
  DateTime createdAt;
  String situation;
  String servicerName;
  String userName;
  Situation _chatSituation = Situation.Ativa;

  Chat({
    required this.id,
    required this.participants,
    required this.createdAt,
    required this.situation,
    required this.userName,
    required this.servicerName,
  });

  void finalize() {
    _chatSituation = Situation.Finalizada;
  }

  Map<String, dynamic> toJson() {
    return {
      'participants': participants,
      'createdAt': createdAt.toIso8601String(),
      'situation': _chatSituation == Situation.Ativa ? 'Ativo' : 'Finalizado',
      'userName': userName,
      'servicerName': servicerName,
    };
  }

  factory Chat.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> docu) {
    final data = docu.data()!;
    return Chat(
      id: docu.id,
      participants: List<String>.from(data['participants']),
      createdAt: DateTime.parse(data['createdAt']),
      situation: data['situation'],
      userName: data['userName'],
      servicerName: data['servicerName'],
    );
  }
}

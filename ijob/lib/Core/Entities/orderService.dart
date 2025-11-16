import 'package:cloud_firestore/cloud_firestore.dart';

class OrderService {
  String id;
  int value;
  DateTime orderedAt;
  DateTime? finishedAt;
  DateTime definedAt;
  String categor;
  String servicer;
  String user;
  String initiatedIn;
  String? requestedIn;
  int status;

  OrderService({
    required this.id,
    required this.user,
    required this.servicer,
    required this.categor,
    required this.value,
    required this.orderedAt,
    required this.definedAt,
    required this.status,
    required this.initiatedIn,
    this.requestedIn,
    this.finishedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'user': user,
      'servicer': servicer,
      'categor': categor,
      'value': value,
      'orderedAt': orderedAt.toIso8601String(),
      'definedAt': definedAt.toIso8601String(),
      'finishedAt': finishedAt?.toIso8601String(),
      'initiatedIn': initiatedIn,
      'requestedIn': requestedIn,
      'status': status,
    };
  }

  factory OrderService.fromSnapshto(
    DocumentSnapshot<Map<String, dynamic>> docu,
  ) {
    final data = docu.data();
    return OrderService(
      id: docu.id,
      user: data!['user'],
      servicer: data['servicer'],
      categor: data['categor'],
      value: data['value'],
      orderedAt: DateTime.parse(data['orderedAt']),
      definedAt: DateTime.parse(data['definedAt']),
      finishedAt: data['finishedAt'] == null
          ? null
          : DateTime.parse(data['finishedAt']),
      initiatedIn: data['initiatedIn'],
      requestedIn: data['requestedIn'],
      status: data['status'],
    );
  }
}

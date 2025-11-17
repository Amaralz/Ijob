import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ijob/Core/Entities/orderService.dart';

class Orderservicer extends ChangeNotifier {
  final _db = FirebaseFirestore.instance.collection('orders');
  List<OrderService> _orders = [];

  List<OrderService> get orders {
    return [..._orders];
  }

  StreamSubscription? _ordersSubscription;

  Future<void> loadOrders(String userId) async {
    _ordersSubscription?.cancel();
    try {
      final filterUser = Filter('user', isEqualTo: userId);
      final filterServicer = Filter('servicer', isEqualTo: userId);

      final query = await _db
          .where(Filter.or(filterUser, filterServicer))
          .orderBy('orderedAt')
          .snapshots();

      _ordersSubscription = query.listen((snapshot) {
        _orders = snapshot.docs.map((doc) {
          return OrderService.fromSnapshto(doc);
        }).toList();
        notifyListeners();
      });
    } catch (error) {
      throw "Erro ao carregar pedidos";
    }
  }

  void disposeRequest() {
    _ordersSubscription?.cancel();
    _orders = [];
  }

  Future<void> createOrder(OrderService orderService) async {
    try {
      await _db
          .add(orderService.toJson())
          .then((doc) => orderService.id = doc.id);
    } catch (error) {
      throw "Erro ao criar pedido";
    }
  }

  Future<void> updateOrder(OrderService orderService) async {
    final query = _db.doc(orderService.id);

    await query.update(orderService.toJson());
  }
}

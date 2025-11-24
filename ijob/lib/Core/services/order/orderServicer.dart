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
          .snapshots();

      _ordersSubscription = query.listen((snapshot) {
        _orders = snapshot.docs.map((doc) {
          return OrderService.fromSnapshto(doc);
        }).toList();
        _orders.sort((x, y) => x.orderedAt.compareTo(y.orderedAt));

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

  Future<void> updateLates(String uid) async {
    _ordersSubscription?.cancel();
    try {
      final filterUser = Filter('user', isEqualTo: uid);
      final filterServicer = Filter('servicer', isEqualTo: uid);

      final query = _db
          .where(Filter.or(filterUser, filterServicer))
          .where('status', isEqualTo: 1)
          .snapshots();

      _ordersSubscription = query.listen((snapshot) async {
        List<OrderService> lista = snapshot.docs
            .map((doc) => OrderService.fromSnapshto(doc))
            .where((order) => DateTime.now().isAfter(order.definedAt))
            .toList();

        //nunca usar .map para efeitos de updates ou exclusões, sempre usar o for in
        for (final order in lista) {
          final lateOrder = OrderService(
            id: order.id,
            user: order.user,
            servicer: order.servicer,
            categor: order.categor,
            value: order.value,
            orderedAt: order.orderedAt,
            definedAt: order.definedAt,
            finishedAt: order.finishedAt,
            requestedIn: order.requestedIn,
            status: 4,
            initiatedIn: order.initiatedIn,
          );

          await updateOrder(lateOrder);
        }

        //só depois de verificar e atualizar ele irá informar (e só se realmente tiver ocorrido)
        if (lista.isNotEmpty) {
          notifyListeners();
        }
      });
    } catch (error) {
      throw "Erro ao carregar pedidos";
    }
  }
}

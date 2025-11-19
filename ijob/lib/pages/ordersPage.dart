import 'package:flutter/material.dart';
import 'package:ijob/Components/ordersFuture.dart';
import 'package:ijob/Core/Entities/orderService.dart';
import 'package:ijob/Core/services/geralUse/profileUserList.dart';
import 'package:ijob/Core/services/geralUse/servicerList.dart';
import 'package:ijob/Core/Entities/userRole.dart';
import 'package:ijob/Core/services/order/orderServicer.dart';
import 'package:ijob/components/side_bar.dart';
import 'package:provider/provider.dart';

class Orderspage extends StatefulWidget {
  @override
  State<Orderspage> createState() => _OrderspageState();
}

class _OrderspageState extends State<Orderspage> {
  bool _initialized = false;
  bool _filtered = false;
  List<OrderService> _order = [];
  int? _filter;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final role = Provider.of<Userrole>(context, listen: false);

      String? userId = role.isUsu
          ? Provider.of<Profileuserlist>(context, listen: false).profile.id
          : Provider.of<Servicerlist>(context, listen: false).servicerUser.id;

      if (userId == null) {
        return;
      }
      final provider = Provider.of<Orderservicer>(context, listen: false);

      provider.loadOrders(userId);
      provider.updateLates(userId);

      Object? filterer = ModalRoute.of(context)?.settings.arguments;

      if (filterer != null) {
        _filtered = true;
        _filter = filterer as int;
      }

      _initialized = true;
    }
  }

  @override
  void dispose() {
    Provider.of<Orderservicer>(context, listen: false).dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _order = Provider.of<Orderservicer>(context).orders.reversed.toList();

    if (_filtered) {
      switch (_filter) {
        case 0:
          _order = _order.where((order) => order.status == 0).toList();
          break;
        case 1:
          _order = _order.where((order) => order.status == 1).toList();
          break;
        case 2:
          _order = _order.where((order) => order.status == 2).toList();
          break;
        case 3:
          _order = _order.where((order) => order.status == 3).toList();
          break;
        case 4:
          _order = _order.where((order) => order.status == 4).toList();
          break;
        default:
          _order;
          break;
      }
    }
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Pedidos",
          style: TextStyle(color: Theme.of(context).secondaryHeaderColor),
        ),
        centerTitle: true,
      ),
      drawer: !_filtered ? Sidebar() : null,
      body: ListView.builder(
        itemCount: _order.length,
        itemBuilder: (context, index) {
          return Ordersfuture(order: _order[index]);
        },
      ),
    );
  }
}

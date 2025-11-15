import 'package:flutter/material.dart';
import 'package:ijob/Components/orderListTile.dart';
import 'package:ijob/Core/Entities/profileUserList.dart';
import 'package:ijob/Core/Entities/servicerList.dart';
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

      Provider.of<Orderservicer>(context, listen: false).loadOrders(userId);

      _initialized = true;
    }
  }

  @override
  void dispose() {
    Provider.of<Orderservicer>(context).dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<Orderservicer>(context).orders;
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Pedidos",
          style: TextStyle(color: Theme.of(context).secondaryHeaderColor),
        ),
        centerTitle: true,
      ),
      drawer: Sidebar(),
      body: ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          return FutureBuilder(
            future: Provider.of<Servicerlist>(
              context,
            ).getServicer(orders[index].servicer),
            builder: (context, servicer) {
              if (servicer.connectionState == ConnectionState.waiting) {
                return Container();
              } else {
                return FutureBuilder(
                  future: Provider.of<Profileuserlist>(
                    context,
                  ).getProfile(orders[index].user),
                  builder: (context, profiler) {
                    if (profiler.connectionState == ConnectionState.waiting) {
                      return Container();
                    } else {
                      return Orderlisttile(
                        order: orders[index],
                        servicer: servicer.data!,
                        user: profiler.data!,
                      );
                    }
                  },
                );
              }
            },
          );
        },
      ),
    );
  }
}

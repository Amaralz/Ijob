import 'package:flutter/material.dart';
import 'package:ijob/Components/orderListTile.dart';
import 'package:ijob/Core/Entities/orderService.dart';
import 'package:ijob/Core/Entities/profileUser.dart';
import 'package:ijob/Core/Entities/servicer.dart';
import 'package:ijob/Core/services/geralUse/profileUserList.dart';
import 'package:ijob/Core/services/geralUse/servicerList.dart';
import 'package:provider/provider.dart';

class Ordersfuture extends StatefulWidget {
  final OrderService order;

  Ordersfuture({required this.order});

  @override
  State<Ordersfuture> createState() => _OrdersfutureState();
}

class _OrdersfutureState extends State<Ordersfuture> {
  late Future<List<dynamic>> _dados;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _dados = Future.wait([
      Provider.of<Servicerlist>(
        context,
        listen: false,
      ).getServicer(widget.order.servicer),
      Provider.of<Profileuserlist>(
        context,
        listen: false,
      ).getProfile(widget.order.user),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return FutureBuilder(
      future: _dados,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container();
        } else {
          if (snapshot.hasError || !snapshot.hasData) {
            return const Text("Houve um erro");
          }

          final Servicer servicer = snapshot.data![0] as Servicer;
          final Profileuser profiler = snapshot.data![1] as Profileuser;

          return Orderlisttile(
            order: widget.order,
            servicer: servicer,
            user: profiler,
          );
        }
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:ijob/Components/activeOrderTile.dart';

import 'package:ijob/Core/Entities/categor.dart';
import 'package:ijob/Core/services/geralUse/categorList.dart';
import 'package:ijob/Core/Entities/orderService.dart';
import 'package:ijob/Core/Entities/profileUser.dart';
import 'package:ijob/Core/Entities/servicer.dart';
import 'package:ijob/Core/Entities/userRole.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Orderlisttile extends StatelessWidget {
  final OrderService order;
  final Servicer servicer;
  final Profileuser user;

  Orderlisttile({
    required this.order,
    required this.servicer,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(
      locale: 'pt_BR',
      symbol: 'R\$',
    );
    final role = Provider.of<Userrole>(context, listen: false);

    Categor? categor = Provider.of<Categorlist>(
      context,
      listen: false,
    ).categoryById(order.categor);
    switch (order.status) {
      case 0:
        return Activeordertile(
          checker: role.isServicer,
          format: currencyFormat,
          msg: "Cancelado",
          order: order,
          primaryColor: Colors.blueGrey,
          servicer: servicer,
          categor: categor,
          user: user,
        );
      case 1:
        return Activeordertile(
          checker: role.isServicer,
          format: currencyFormat,
          msg: "Pendente",
          order: order,
          primaryColor: Colors.orange,
          servicer: servicer,
          categor: categor,
          user: user,
        );

      case 2:
        return Activeordertile(
          checker: role.isServicer,
          format: currencyFormat,
          msg: "Confirmado",
          order: order,
          primaryColor: Colors.green,
          servicer: servicer,
          categor: categor,
          user: user,
        );

      case 3:
        return Activeordertile(
          checker: role.isServicer,
          format: currencyFormat,
          msg: "Concluído",
          order: order,
          primaryColor: Colors.blue,
          servicer: servicer,
          categor: categor,
          user: user,
        );

      case 4:
        return Activeordertile(
          checker: role.isServicer,
          format: currencyFormat,
          msg: "Atrasado",
          order: order,
          primaryColor: Colors.red,
          servicer: servicer,
          categor: categor,
          user: user,
        );
      default:
        return Container();
    }
  }
}

import 'package:flutter/material.dart';
import 'package:ijob/Components/orderListTileDialog.dart';
import 'package:ijob/Core/Entities/categor.dart';
import 'package:ijob/Core/Entities/categorList.dart';
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

  _boxTileActive({
    required Color primaryColor,
    required Color secondaryColor,
    required String? categorName,
    required bool checker,
    required String msg,
    required BuildContext context,
  }) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            return Orderlisttiledialog(
              order: order,
              servicer: servicer,
              user: user,
              isServicer: checker,
            );
          },
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            border: BoxBorder.fromLTRB(
              left: BorderSide(color: primaryColor, width: 5),
            ),
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(15),
              bottomRight: Radius.circular(15),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 10,
                  children: [
                    Text(
                      'Serviço de ${categorName}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      spacing: 5,
                      children: [
                        Text("Marcado para:"),
                        Text(
                          DateFormat.yMd('pt_BR').format(order.definedAt),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          DateFormat.Hm().format(order.definedAt),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    if (checker)
                      SizedBox(
                        width: 200,
                        child: Text(
                          "Local: ${user.endereco?.neighborhood}, ${user.endereco?.route}, ${user.endereco?.number}",
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                  ],
                ),
                Spacer(),
                Container(
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 5.0,
                      horizontal: 8,
                    ),
                    child: Text(msg, style: TextStyle(color: secondaryColor)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _boxTile({
    required Color primaryColor,
    required Color secondaryColor,
    required String? categorName,
    required String msg,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          border: BoxBorder.fromLTRB(
            left: BorderSide(color: primaryColor, width: 5),
          ),
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(15),
            bottomRight: Radius.circular(15),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 10,
                children: [
                  Text(
                    'Serviço de ${categorName}',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    spacing: 5,
                    children: [
                      Text("Marcado para:"),
                      Text(
                        DateFormat.yMd('pt_BR').format(order.definedAt),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        DateFormat.Hm().format(order.definedAt),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
              Spacer(),
              Container(
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 5.0,
                    horizontal: 8,
                  ),
                  child: Text(msg, style: TextStyle(color: secondaryColor)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final role = Provider.of<Userrole>(context, listen: false);

    Categor? categor = Provider.of<Categorlist>(
      context,
      listen: false,
    ).categoryById(order.categor);
    switch (order.status) {
      case 0:
        return _boxTile(
          primaryColor: const Color.fromARGB(255, 47, 61, 68),
          secondaryColor: const Color.fromARGB(255, 22, 29, 32),
          categorName: categor?.name,
          msg: "Cancelado",
        );

      case 1:
        return _boxTileActive(
          context: context,
          primaryColor: Colors.yellow,
          secondaryColor: const Color.fromARGB(255, 206, 186, 4),
          categorName: categor?.name,
          checker: role.isServicer,
          msg: "Pendente",
        );
      case 2:
        return _boxTileActive(
          context: context,
          primaryColor: Colors.green,
          secondaryColor: Colors.greenAccent,
          categorName: categor?.name,
          checker: role.isServicer,
          msg: "Confirmado",
        );
      case 3:
        return _boxTile(
          primaryColor: Theme.of(context).secondaryHeaderColor,
          secondaryColor: Colors.blueAccent,
          categorName: categor?.name,
          msg: "Concluído",
        );
      case 4:
        return _boxTileActive(
          context: context,
          primaryColor: Colors.red,
          secondaryColor: Colors.redAccent,
          categorName: categor?.name,
          checker: role.isServicer,
          msg: "Atrasado",
        );
      default:
        return Container();
    }
  }
}

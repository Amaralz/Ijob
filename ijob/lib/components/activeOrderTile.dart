import 'package:flutter/material.dart';
import 'package:ijob/Components/orderListTileDialog.dart';
import 'package:ijob/Core/Entities/categor.dart';
import 'package:ijob/Core/Entities/orderService.dart';
import 'package:ijob/Core/Entities/profileUser.dart';
import 'package:ijob/Core/Entities/servicer.dart';
import 'package:ijob/Core/Entities/userRole.dart';
import 'package:ijob/Core/utils/icnoMap.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Activeordertile extends StatelessWidget {
  final Color primaryColor;
  final Categor? categor;
  final bool checker;
  final String msg;
  final NumberFormat format;
  final OrderService order;
  final Servicer servicer;
  final Profileuser user;

  const Activeordertile({
    this.categor,
    required this.checker,
    required this.format,
    required this.msg,
    required this.order,
    required this.primaryColor,
    required this.servicer,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    final role = Provider.of<Userrole>(context, listen: false);
    // TODO: implement build
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
            borderRadius: BorderRadius.all(const Radius.circular(15)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: 200,
                  child: Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          role.isUsu
                              ? Container(
                                  height: 20,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    spacing: 5,
                                    children: [
                                      CircleAvatar(
                                        backgroundImage: servicer.url != null
                                            ? NetworkImage(servicer.url!)
                                            : null,
                                        maxRadius: 10,
                                      ),
                                      Text(
                                        servicer.nome ?? 'servidor',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Container(
                                  height: 20,
                                  child: Row(
                                    spacing: 5,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      CircleAvatar(
                                        backgroundImage: user.url != null
                                            ? NetworkImage(user.url!)
                                            : null,
                                        maxRadius: 10,
                                      ),
                                      Text(
                                        user.nome ?? 'cliente',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                          Text(
                            DateFormat.yMd('pt_BR').format(order.orderedAt),
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        spacing: 3,
                        children: [
                          Icon(Icnomap.getIconData(categor?.icon ?? 'default')),
                          Text(
                            categor?.name ?? 'categoria',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const Icon(
                            Icons.circle,
                            size: 5,
                            color: Colors.blueGrey,
                          ),
                          Text(
                            format.format(order.value / 100),
                            style: const TextStyle(
                              color: Colors.lightBlue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      order.status == 2 || order.status == 3
                          ? Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: Row(
                                spacing: 5,
                                children: [
                                  Text(
                                    DateFormat.yMd(
                                      'pt_BR',
                                    ).format(order.finishedAt!),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: order.status == 3
                                          ? Colors.blue
                                          : Colors.green,
                                    ),
                                  ),
                                  Text(
                                    DateFormat.Hm().format(order.finishedAt!),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: order.status == 3
                                          ? Colors.blue
                                          : Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: Row(
                                spacing: 5,
                                children: [
                                  Text(
                                    DateFormat.yMd(
                                      'pt_BR',
                                    ).format(order.definedAt),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    DateFormat.Hm().format(order.definedAt),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    ],
                  ),
                ),
                const Spacer(),
                Container(
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 5.0,
                      horizontal: 8,
                    ),
                    child: Text(
                      msg,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

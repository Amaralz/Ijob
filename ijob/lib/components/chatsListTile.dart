import 'package:flutter/material.dart';
import 'package:ijob/Core/Entities/chat.dart';
import 'package:ijob/Core/Entities/servicer.dart';
import 'package:ijob/Core/Entities/userRole.dart';
import 'package:ijob/Core/utils/routes.dart';
import 'package:provider/provider.dart';

class Chatslisttile extends StatelessWidget {
  final Chat chat;
  final Servicer servicer;

  Chatslisttile({required this.chat, required this.servicer});

  @override
  Widget build(BuildContext context) {
    final role = Provider.of<Userrole>(context);

    // TODO: implement build
    return GestureDetector(
      onTap: () =>
          Navigator.of(context).pushNamed(Routes.INNERCHAT, arguments: chat),
      child: Card(
        child: ListTile(
          title: Text(role.isUsu ? servicer.nome! : chat.userName),
        ),
      ),
    );
  }
}

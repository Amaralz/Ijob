import 'package:flutter/material.dart';
import 'package:ijob/Components/messageStream.dart';
import 'package:ijob/Components/newMessage.dart';
import 'package:ijob/Core/Entities/chat.dart';
import 'package:ijob/Core/Entities/userRole.dart';
import 'package:provider/provider.dart';

class Innerchatpage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final role = Provider.of<Userrole>(context);
    Chat info = ModalRoute.of(context)?.settings.arguments as Chat;
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(
          role.isUsu ? info.servicerName : info.userName,
          style: TextStyle(color: Theme.of(context).secondaryHeaderColor),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(child: Messagestream(chat: info)),
          ),
          Newmessage(chat: info),
        ],
      ),
    );
  }
}

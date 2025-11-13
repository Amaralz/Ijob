import 'package:flutter/material.dart';
import 'package:ijob/Components/messageBuble.dart';
import 'package:ijob/Core/Entities/chat.dart';
import 'package:ijob/Core/Entities/chatMessage.dart';
import 'package:ijob/Core/Entities/profileUserList.dart';
import 'package:ijob/Core/Entities/servicerList.dart';
import 'package:ijob/Core/Entities/userRole.dart';
import 'package:ijob/Core/services/chat/messageServices.dart';
import 'package:provider/provider.dart';

class Messagestream extends StatelessWidget {
  final Chat chat;

  Messagestream({required this.chat});

  @override
  Widget build(BuildContext context) {
    final role = Provider.of<Userrole>(context, listen: false);

    final currentUser = role.isUsu
        ? Provider.of<Profileuserlist>(context, listen: false).profile.id
        : Provider.of<Servicerlist>(context, listen: false).servicerUser.id;
    // TODO: implement build
    return StreamBuilder<List<Chatmessage>>(
      stream: Messageservices().loadMessageStream(chat.id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text("Sem mensagens"));
        } else {
          final msgs = snapshot.data!;
          return ListView.builder(
            reverse: true,
            itemCount: msgs.length,
            itemBuilder: (context, index) {
              return Messagebuble(
                text: msgs[index].text,
                belongs: msgs[index].userId == currentUser,
              );
            },
          );
        }
      },
    );
  }
}

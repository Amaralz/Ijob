import 'package:flutter/material.dart';
import 'package:ijob/Core/Entities/chat.dart';
import 'package:ijob/Core/Entities/chatMessage.dart';
import 'package:ijob/Core/Entities/servicer.dart';
import 'package:ijob/Core/Entities/userRole.dart';
import 'package:ijob/Core/services/chat/messageServices.dart';
import 'package:ijob/Core/utils/routes.dart';
import 'package:intl/intl.dart';
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
        child: StreamBuilder<List<Chatmessage>>(
          stream: Messageservices().loadMessageStream(chat.id),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return ListTile(
                title: Text(
                  role.isUsu ? servicer.nome! : chat.userName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text("Sem conversas"),
              );
            } else {
              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 12,
                ),
                child: Column(
                  spacing: 5,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      spacing: 3,
                      children: [
                        Text(
                          role.isUsu ? servicer.nome! : chat.userName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          DateFormat.Hm().format(
                            snapshot.data!.first.createdAt,
                          ),
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                        snapshot.data!.first.text,
                        style: const TextStyle(color: Colors.grey),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

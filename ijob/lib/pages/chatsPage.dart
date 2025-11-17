import 'package:flutter/material.dart';
import 'package:ijob/Components/chatsListTile.dart';
import 'package:ijob/Components/side_bar.dart';
import 'package:ijob/Core/Entities/chat.dart';
import 'package:ijob/Core/services/geralUse/servicerList.dart';
import 'package:ijob/Core/services/chat/chatServices.dart';
import 'package:provider/provider.dart';

class Chatspage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Chat> _list = Provider.of<Chatservices>(context).chats;
    // TODO: implement build
    return Scaffold(
      drawer: Sidebar(),
      body: ListView.builder(
        itemCount: _list.length,
        itemBuilder: (context, index) {
          if (_list.isEmpty || _list == []) {
            return Center(child: Text("Sem conversas ainda"));
          } else {
            return FutureBuilder(
              future: Provider.of<Servicerlist>(
                context,
                listen: false,
              ).getServicer(_list[index].servicerId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container();
                } else {
                  return Chatslisttile(
                    chat: _list[index],
                    servicer: snapshot.data!,
                  );
                }
              },
            );
          }
        },
      ),
    );
  }
}

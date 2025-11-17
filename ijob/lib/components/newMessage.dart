import 'package:flutter/material.dart';
import 'package:ijob/Core/Entities/chat.dart';
import 'package:ijob/Core/Entities/chatMessage.dart';
import 'package:ijob/Core/services/geralUse/profileUserList.dart';
import 'package:ijob/Core/services/geralUse/servicerList.dart';
import 'package:ijob/Core/Entities/userRole.dart';
import 'package:ijob/Core/services/chat/messageServices.dart';
import 'package:provider/provider.dart';

class Newmessage extends StatefulWidget {
  final Chat chat;

  Newmessage({required this.chat});
  @override
  State<Newmessage> createState() => _NewmessageState();
}

class _NewmessageState extends State<Newmessage> {
  String _enterMessage = '';
  TextEditingController _controller = TextEditingController();

  Future<void> _sendMessage() async {
    final role = Provider.of<Userrole>(context, listen: false);
    final userId = role.isUsu
        ? Provider.of<Profileuserlist>(context, listen: false).profile.id
        : Provider.of<Servicerlist>(context, listen: false).servicerUser.id;

    if (userId != null) {
      Messageservices().newMessage(
        widget.chat.id,
        Chatmessage(
          id: '',
          text: _enterMessage,
          createdAt: DateTime.now(),
          userId: userId,
        ),
      );
      _controller.clear();

      setState(() {
        _enterMessage = '';
      });
    }
    if (mounted) FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Row(
      children: [
        Expanded(
          child: TextField(
            selectAllOnFocus: false,
            autofocus: false,
            clipBehavior: Clip.antiAlias,
            keyboardType: TextInputType.multiline,
            maxLines: null,
            controller: _controller,

            onChanged: (msg) {
              setState(() {
                _enterMessage = msg;
              });
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(
                  color: Theme.of(context).secondaryHeaderColor,
                ),
              ),
              hintText: "Mensagem",
            ),
          ),
        ),
        IconButton(
          onPressed: _enterMessage.trim().isEmpty ? null : _sendMessage,
          icon: Icon(Icons.send),
          style: IconButton.styleFrom(
            foregroundColor: Theme.of(context).secondaryHeaderColor,
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:ijob/Core/Entities/chatMessage.dart';
import 'package:intl/intl.dart';

class Messagebuble extends StatelessWidget {
  final Chatmessage msg;
  final bool belongs;

  Messagebuble({required this.msg, required this.belongs, Key? key})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        crossAxisAlignment: belongs
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              constraints: BoxConstraints.loose(
                Size(
                  MediaQuery.sizeOf(context).width * 0.6,
                  MediaQuery.sizeOf(context).height,
                ),
              ),
              decoration: BoxDecoration(
                color: belongs
                    ? Theme.of(context).secondaryHeaderColor
                    : Colors.grey,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                  bottomLeft: belongs ? Radius.circular(12) : Radius.zero,
                  bottomRight: belongs ? Radius.zero : Radius.circular(12),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  msg.text,
                  style: TextStyle(color: Colors.black),
                  overflow: TextOverflow.clip,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              DateFormat.Hm().format(msg.createdAt),
              style: const TextStyle(color: Colors.grey, fontSize: 10),
            ),
          ),
        ],
      ),
    );
  }
}

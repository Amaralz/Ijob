import 'package:flutter/material.dart';

class Messagebuble extends StatelessWidget {
  final String text;
  final bool belongs;

  Messagebuble({required this.text, required this.belongs, Key? key})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Row(
      mainAxisAlignment: belongs
          ? MainAxisAlignment.end
          : MainAxisAlignment.start,
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
                text,
                style: TextStyle(color: Colors.black),
                overflow: TextOverflow.clip,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

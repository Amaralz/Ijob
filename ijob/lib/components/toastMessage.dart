import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class Toastmessage {
  final String title;
  final String subtitle;
  final Color primaryColor;
  final Icon icon;

  Toastmessage({
    required this.title,
    required this.subtitle,
    required this.primaryColor,
    required this.icon,
  });

  void toast(BuildContext context) {
    toastification.show(
      context: context,
      type: ToastificationType.success,
      style: ToastificationStyle.minimal,
      title: Text(title, style: TextStyle(color: Colors.white)),
      description: Text(subtitle, style: TextStyle(color: Colors.white)),
      alignment: Alignment.topCenter,
      autoCloseDuration: const Duration(seconds: 4),
      animationBuilder: (context, animation, alignment, child) {
        return FadeTransition(opacity: animation, child: child);
      },
      primaryColor: primaryColor,
      backgroundColor: Colors.black,
      foregroundColor: Colors.black,
      icon: icon,
      borderRadius: BorderRadius.circular(12.0),
      boxShadow: lowModeShadow,
    );
  }
}

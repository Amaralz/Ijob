import 'package:flutter/material.dart';
import 'package:ijob/components/side_bar.dart';

class NotificacaoPage extends StatelessWidget {
  const NotificacaoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notificações'),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      drawer: Sidebar(),
    );
  }
}

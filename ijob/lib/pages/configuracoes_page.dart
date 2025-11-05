import 'package:flutter/material.dart';
import 'package:ijob/Components/side_bar.dart';

class ConfiguracoesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Configurações",
          style: TextStyle(color: Theme.of(context).secondaryHeaderColor),
        ),
        centerTitle: true,
      ),
      drawer: Sidebar(),
      body: Column(children: []),
    );
  }
}

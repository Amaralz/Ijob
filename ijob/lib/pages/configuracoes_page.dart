import 'package:flutter/material.dart';
import 'package:ijob/Components/side_bar.dart';

class ConfiguracoesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Configurações"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      drawer: Sidebar(),
    );
  }
}

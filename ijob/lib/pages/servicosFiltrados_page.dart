import 'package:flutter/material.dart';
import 'package:ijob/Entities/categor.dart';

class ServicosfiltradosPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final categoria = ModalRoute.of(context)!.settings.arguments as Categor;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(categoria.name.toString()),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(child: Column(children: <Widget>[
          
        ],
      )),
    );
  }
}

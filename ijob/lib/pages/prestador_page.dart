import 'package:flutter/material.dart';
import 'package:ijob/Entities/servicer.dart';

class Prestadorpage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Servicer servicer =
        ModalRoute.of(context)!.settings.arguments as Servicer;
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(servicer.nome.toString()),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
    );
  }
}

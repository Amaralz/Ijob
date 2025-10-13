import 'package:flutter/material.dart';
import 'package:ijob/Components/middleListServices.dart';
import 'package:ijob/Entities/categor.dart';
import 'package:ijob/Entities/servicer.dart';
import 'package:ijob/Entities/servicerList.dart';
import 'package:provider/provider.dart';

class ServicosfiltradosPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final categoria = ModalRoute.of(context)!.settings.arguments as Categor;
    final provider = Provider.of<Servicerlist>(context);
    final List<Servicer> servicers = provider.servicersByCategorie(categoria);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(categoria.name.toString()),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[Container(child: Middlelistservices(servicers))],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:ijob/Components/middleGridPrimaryPage.dart';
import 'package:ijob/Components/middleListServices.dart';
import 'package:ijob/Entities/categor.dart';
import 'package:ijob/Entities/servicer.dart';

class Middleprimarypage extends StatelessWidget {
  final List<Categor> categories;
  final List<Servicer> servicers;

  Middleprimarypage(this.categories, this.servicers);

  Widget placerText(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 15, top: 2),
      child: Text(
        text,
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          placerText("Escolha por Categoria"),
          SizedBox(height: 100, child: Middlegridprimarypage(categories)),
          placerText("Top Serviços"),
          Expanded(child: Middlelistservices(servicers)),
        ],
      ),
    );
  }
}

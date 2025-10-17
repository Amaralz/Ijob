import 'package:flutter/material.dart';
import 'package:ijob/Components/categoryGridPrimaryPage.dart';
import 'package:ijob/Components/topServicersList.dart';

class Bodyprimarypage extends StatelessWidget {
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
          SizedBox(height: 100, child: Categorygridprimarypage()),
          placerText("Top Serviços"),
          Expanded(child: Topservicerslist()),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:ijob/Components/categoryGridTile.dart';
import 'package:ijob/Entities/categor.dart';
import 'package:ijob/Entities/categorList.dart';
import 'package:provider/provider.dart';

class Categorygridprimarypage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Categor> categories = Provider.of<Categorlist>(context).categories;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      height: 100,
      child: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (ctx, index) {
          return Categorygridtile(categoria: categories[index]);
        },
        scrollDirection: Axis.horizontal,
      ),
    );
  }
}

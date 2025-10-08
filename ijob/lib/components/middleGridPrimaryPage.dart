import 'package:flutter/material.dart';
import 'package:ijob/Components/categoryGridTile.dart';
import 'package:ijob/Entities/categor.dart';

class Middlegridprimarypage extends StatelessWidget {
  final List<Categor> categories;

  Middlegridprimarypage(this.categories);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      height: 100,
      child: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (ctx, index) {
          final categoria = categories[index];
          return Categorygridtile(categoria: categoria);
        },
        scrollDirection: Axis.horizontal,
      ),
    );
  }
}

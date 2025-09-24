import 'package:flutter/material.dart';
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
          return Card(
            elevation: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(categoria.icon, size: 40),
                Container(
                  alignment: Alignment.center,
                  width: 90,
                  child: Text(
                    categoria.name![0].toUpperCase() +
                        categoria.name!.substring(1),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
              ],
            ),
          );
        },
        scrollDirection: Axis.horizontal,
      ),
    );
  }
}

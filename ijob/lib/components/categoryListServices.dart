import 'package:flutter/material.dart';
import 'package:ijob/components/servicerListTile.dart';
import 'package:ijob/Entities/categor.dart';
import 'package:ijob/Entities/servicer.dart';
import 'package:ijob/Entities/servicerList.dart';
import 'package:provider/provider.dart';

class Categorylistservices extends StatelessWidget {
  final bool? toSearch;
  final String? whatSearch;
  final Categor? category;

  const Categorylistservices({this.toSearch, this.whatSearch, this.category});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<Servicerlist>(context);

    List<Servicer> servicers = toSearch!
        ? provider.searchServicerServicersByCategorie(category!, whatSearch!)
        : provider.servicersByCategorie(category!);

    return Container(
      width: double.maxFinite,

      height: 300,
      child: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: servicers.length,
        itemBuilder: (ctx, index) {
          return Servicerlisttile(servicer: servicers[index]);
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:ijob/Components/servicerListTile.dart';
import 'package:ijob/Core/Entities/categor.dart';
import 'package:ijob/Core/Entities/servicer.dart';
import 'package:ijob/Core/services/geralUse/servicerList.dart';
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

    List<Servicer> trueServicers = servicers
        .where((serv) => serv.active == true)
        .toList();

    return Container(
      width: double.maxFinite,

      height: 300,
      child: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: trueServicers.length,
        itemBuilder: (ctx, index) {
          return Servicerlisttile(servicer: trueServicers[index]);
        },
      ),
    );
  }
}

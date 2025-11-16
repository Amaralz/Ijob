import 'package:flutter/material.dart';
import 'package:ijob/Components/servicerListTile.dart';
import 'package:ijob/Core/Entities/servicer.dart';
import 'package:ijob/Core/Entities/servicerList.dart';
import 'package:provider/provider.dart';

class Listservices extends StatelessWidget {
  final bool? toSearch;
  final String? whatSearch;

  const Listservices({this.toSearch, this.whatSearch});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<Servicerlist>(context);

    List<Servicer> servicers = toSearch!
        ? provider.searchServicer(whatSearch!)
        : provider.servicers;

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

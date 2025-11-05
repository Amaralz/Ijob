import 'package:flutter/material.dart';
import 'package:ijob/Components/servicerListTile.dart';
import 'package:ijob/Entities/servicer.dart';
import 'package:ijob/Entities/servicerList.dart';
import 'package:provider/provider.dart';

class Topservicerslist extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<Servicer> servicers = Provider.of<Servicerlist>(
      context,
    ).servicers;

    final int count = servicers.length;
    // TODO: implement build
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: count < 6 ? count : 6,
      itemBuilder: (ctx, index) {
        return Servicerlisttile(servicer: servicers[index]);
      },
    );
  }
}

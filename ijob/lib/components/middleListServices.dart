import 'package:flutter/material.dart';
import 'package:ijob/Components/servicerListTile.dart';
import 'package:ijob/Entities/servicer.dart';
import 'package:provider/provider.dart';

class Middlelistservices extends StatelessWidget {
  final List<Servicer> servicers;

  Middlelistservices(this.servicers);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,

      height: 300,
      child: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: servicers.length,
        itemBuilder: (ctx, index) {
          final servicer = servicers[index];
          return ChangeNotifierProvider.value(
            value: servicer,
            child: Servicerlisttile(),
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:ijob/Components/barSearchPrimaryPage.dart';
import 'package:ijob/Entities/servicer.dart';
import 'package:ijob/Components/middleListServices.dart';
import 'package:ijob/Entities/servicerList.dart';
import 'package:provider/provider.dart';

class ServicosPage extends StatelessWidget {
  void test(String string) {}
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<Servicerlist>(context, listen: false);
    List<Servicer> services = provider.servicers;

    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(width: double.maxFinite, child: barSearchPrimaryPage(test)),
          Expanded(child: Middlelistservices(services)),
        ],
      ),
    );
  }
}

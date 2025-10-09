import 'package:flutter/material.dart';
import 'package:ijob/Components/barSearchPrimaryPage.dart';
//import 'package:ijob/Components/side_bar.dart';
import 'package:ijob/Entities/categor.dart';
import 'package:ijob/Entities/servicer.dart';
import 'package:ijob/Components/middleListServices.dart';

class ServicosPage extends StatefulWidget {
  @override
  State<ServicosPage> createState() => _ServicosPageState();
}

class _ServicosPageState extends State<ServicosPage> {
  final List<Servicer> services = [
    Servicer(
      id: '1',
      nome: 'Jorge',
      category: Categor(id: '1', name: "Eletricista"),
      url:
          "https://thumbs.dreamstime.com/b/eletricista-nos-macac%C3%B5es-cercados-com-fontes-e-ferramentas-da-eletricidade-103748791.jpg",
    ),
  ];

  test(String objeto) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Serviços'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Column(
          spacing: 20,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Container(
                width: double.maxFinite,
                child: barSearchPrimaryPage(test),
              ),
            ),
            Middlelistservices(services),
          ],
        ),
      ),
    );
  }
}

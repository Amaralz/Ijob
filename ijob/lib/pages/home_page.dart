import 'package:flutter/material.dart';
import 'package:ijob/Components/middlePrimaryPage.dart';
import 'package:ijob/Components/topBarPrimaryPage.dart';
import 'package:ijob/Entities/categor.dart';
import 'package:ijob/Entities/servicer.dart';
import 'package:ijob/components/side_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Categor> _categories = [
    Categor(id: '1', name: "Eletricista", icon: Icons.electric_bolt_outlined),
    Categor(id: '2', name: "Pintura", icon: Icons.format_paint),
    Categor(id: '3', name: "Encanação", icon: Icons.bathroom),
    Categor(id: '4', name: "Limpeza", icon: Icons.water_drop_outlined),
    Categor(id: '5', name: "Tutoria", icon: Icons.menu_book),
    Categor(id: '6', name: "Mudança", icon: Icons.fire_truck_sharp),
  ];

  final List<Servicer> _services = [
    Servicer(
      id: '1',
      nome: 'Jorge',
      category: Categor(id: '1', name: "Eletricista"),
      url:
          "https://thumbs.dreamstime.com/b/eletricista-nos-macac%C3%B5es-cercados-com-fontes-e-ferramentas-da-eletricidade-103748791.jpg",
    ),
  ];

  _test(String objeto) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ijob'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        automaticallyImplyLeading: true,
      ),
      drawer: const Sidebar(), //adicionar lugares para navegar futuramente
      body: SingleChildScrollView(
        child: Column(
          spacing: 20,
          children: <Widget>[
            Container(width: double.maxFinite, child: topBarPrimaryPage(_test)),
            Middleprimarypage(_categories, _services),
          ],
        ),
      ),
    );
  }
}

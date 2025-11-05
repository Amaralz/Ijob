import 'package:flutter/material.dart';
import 'package:ijob/Components/categoryListServices.dart';
import 'package:ijob/Components/searchServicesBar.dart';
import 'package:ijob/Entities/categor.dart';

class ServicosfiltradosPage extends StatefulWidget {
  @override
  State<ServicosfiltradosPage> createState() => _ServicosfiltradosPageState();
}

class _ServicosfiltradosPageState extends State<ServicosfiltradosPage> {
  String _searcher = '';
  bool _search = false;
  late TextEditingController _barController;

  @override
  void initState() {
    super.initState();
    _barController = TextEditingController();
  }

  @override
  void dispose() {
    _barController = TextEditingController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categoria = ModalRoute.of(context)!.settings.arguments as Categor;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          categoria.name.toString(),
          style: TextStyle(color: Theme.of(context).secondaryHeaderColor),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          children: <Widget>[
            SearchServicesbar(
              controller: _barController,
              pressed: () {
                setState(() {
                  _searcher = _barController.text;
                  _search = _searcher.isNotEmpty;
                });
              },
            ),
            Expanded(
              child: Categorylistservices(
                category: categoria,
                toSearch: _search,
                whatSearch: _searcher,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

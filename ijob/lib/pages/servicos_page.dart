import 'package:flutter/material.dart';
import 'package:ijob/Components/searchServicesBar.dart';
import 'package:ijob/Components/ListServices.dart';

class ServicosPage extends StatefulWidget {
  @override
  State<ServicosPage> createState() => _ServicosPageState();
}

class _ServicosPageState extends State<ServicosPage> {
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
    return Scaffold(
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
              child: Listservices(toSearch: _search, whatSearch: _searcher),
            ),
          ],
        ),
      ),
    );
  }
}

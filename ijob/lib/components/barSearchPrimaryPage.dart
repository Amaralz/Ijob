import 'package:flutter/material.dart';
import 'package:ijob/Components/searchBar.dart';

class barSearchPrimaryPage extends StatefulWidget {
  void _funct() {}

  @override
  State<barSearchPrimaryPage> createState() => _SearchbarState();
}

class _SearchbarState extends State<barSearchPrimaryPage> {
  final _searchController = TextEditingController();

  // void _selected(String search) {
  //   Navigator.of(context).popAndPushNamed(Routes.SERVICOS, arguments: search);
  // }

  _pressed() {
    final searchText = _searchController.text;

    if (searchText.isEmpty) {
      return;
    } else {
      widget._funct();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Searchbar(controller: _searchController, pressed: _pressed());
  }
}

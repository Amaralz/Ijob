import 'package:flutter/material.dart';

class barSearchPrimaryPage extends StatefulWidget {
  final void Function(String) _funct;

  barSearchPrimaryPage(this._funct);

  @override
  State<barSearchPrimaryPage> createState() => _SearchbarState();
}

class _SearchbarState extends State<barSearchPrimaryPage> {
  final _searchController = TextEditingController();

  _pressed() {
    final searchText = _searchController.text;

    if (searchText.isEmpty) {
      return;
    } else {
      widget._funct(searchText);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 370,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(10),
        ),
        child: TextField(
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 20,
            ),
            border: InputBorder.none,
            hintText: "Pesquisar",
            suffixIcon: IconButton(
              icon: const Icon(Icons.search),
              onPressed: _pressed,
            ),
          ),
          controller: _searchController,
          onSubmitted: (_) => _pressed(),
        ),
      ),
    );
  }
}

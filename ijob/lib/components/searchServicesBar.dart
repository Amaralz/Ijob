import 'package:flutter/material.dart';

class SearchServicesbar extends StatelessWidget {
  final Function? pressed;
  final TextEditingController? controller;

  const SearchServicesbar({this.pressed, this.controller});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
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
              onPressed: () => pressed!(),
            ),
          ),
          controller: controller,
          onSubmitted: (_) => pressed!(),
        ),
      ),
    );
  }
}

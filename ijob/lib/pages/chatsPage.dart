import 'package:flutter/material.dart';
import 'package:ijob/Components/side_bar.dart';

class Chatspage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(drawer: Sidebar(), body: SingleChildScrollView());
  }
}

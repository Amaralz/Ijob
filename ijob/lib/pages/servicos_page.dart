import 'package:flutter/material.dart';
import 'package:ijob/Components/side_bar.dart';

class ServicosPage extends StatefulWidget {
  const ServicosPage({super.key});

  @override
  State<ServicosPage> createState() => _ServicosPageState();
}

class _ServicosPageState extends State<ServicosPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('serviços'),
        backgroundColor: Colors.black,
      ),
      drawer: Sidebar(),
    );
  }
}

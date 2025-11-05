import 'package:flutter/material.dart';
import 'package:ijob/components/side_bar.dart';
import 'package:ijob/pages/home_page.dart';
import 'package:ijob/pages/servicos_page.dart';

class Tabspage extends StatefulWidget {
  @override
  State<Tabspage> createState() => _TabspageState();
}

class _TabspageState extends State<Tabspage> {
  int _selectedPageIndex = 0;

  final List<Map<String, Object>> _pages = [
    {'title': 'Ijob', 'page': HomePage()},
    {'title': 'Serviços', 'page': ServicosPage()},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        title: Text(_pages[_selectedPageIndex]['title'] as String),
      ),
      drawer: Sidebar(),

      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (index) {
          setState(() {
            _selectedPageIndex = index;
          });
        },
        selectedIndex: _selectedPageIndex,
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: "Início",
          ),
          NavigationDestination(
            icon: Icon(Icons.search_outlined),
            selectedIcon: Icon(Icons.search),
            label: "Serviços",
          ),
        ],
      ),
      body: _pages[_selectedPageIndex]['page'] as Widget,
    );
  }
}

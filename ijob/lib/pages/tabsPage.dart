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

  List<Map<String, Object>>? _pages;

  void initState() {
    super.initState();
    _pages = [
      {'title': 'Ijob', 'page': HomePage()},
      {'title': 'Serviços', 'page': ServicosPage()},
    ];
  }

  _selectedPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blue,
        title: Text(_pages![_selectedPageIndex]['title'] as String),
      ),
      drawer: Sidebar(),
      body: _pages![_selectedPageIndex]['page'] as Widget,
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectedPage,
        currentIndex: _selectedPageIndex,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              _selectedPageIndex == 0 ? Icons.home : Icons.home_outlined,
            ),
            label: "Início",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              _selectedPageIndex == 1
                  ? Icons.person_search
                  : Icons.person_search_outlined,
            ),
            label: "Serviços",
          ),
        ],
      ),
    );
  }
}

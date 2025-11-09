import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ijob/Components/side_bar.dart';
import 'package:ijob/Core/Entities/servicerList.dart';
import 'package:ijob/Core/Entities/userRole.dart';
import 'package:ijob/pages/chatsPage.dart';
import 'package:ijob/pages/dashboardPage.dart';
import 'package:ijob/Core/services/auth_services.dart';
import 'package:provider/provider.dart';

class Tabsservicer extends StatefulWidget {
  @override
  State<Tabsservicer> createState() => _TabsservicerState();
}

class _TabsservicerState extends State<Tabsservicer> {
  int _selectedPageIndex = 0;

  final List<Map<String, Object>> _pages = [
    {'title': 'Mensagens', 'page': Chatspage()},
    {'title': 'Métricas', 'page': Dashboardpage()},
  ];

  @override
  void initState() {
    super.initState();
    User? user = Provider.of<AuthService>(context, listen: false).usuario;
    Provider.of<Servicerlist>(context, listen: false).loadServicerUser(user!);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        Provider.of<Userrole>(context, listen: false).changeToServicer();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          _pages[_selectedPageIndex]['title'] as String,
          style: TextStyle(color: Theme.of(context).secondaryHeaderColor),
        ),
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
            icon: Icon(Icons.chat_outlined),
            selectedIcon: Icon(Icons.chat),
            label: "Conversas",
          ),
          NavigationDestination(
            icon: Icon(Icons.data_thresholding_outlined),
            selectedIcon: Icon(Icons.data_thresholding),
            label: "Métricas",
          ),
        ],
      ),
      body: _pages[_selectedPageIndex]['page'] as Widget,
    );
  }
}

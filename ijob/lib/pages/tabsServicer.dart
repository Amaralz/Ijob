import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ijob/Components/side_bar.dart';
import 'package:ijob/Core/Entities/servicerList.dart';
import 'package:ijob/Core/Entities/userRole.dart';
import 'package:ijob/Core/services/chat/chatServices.dart';
import 'package:ijob/Core/utils/routes.dart';
import 'package:ijob/pages/chatsPage.dart';
import 'package:ijob/pages/dashboardPage.dart';
import 'package:ijob/Core/services/auth/authServices.dart';
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

  void _carregarDados() async {
    final authProvider = Provider.of<AuthService>(context, listen: false);
    final serviceProvider = Provider.of<Servicerlist>(context, listen: false);
    final chatProvider = Provider.of<Chatservices>(context, listen: false);
    final roleProvider = Provider.of<Userrole>(context, listen: false);

    User? user = authProvider.usuario;

    if (user == null) {
      Navigator.of(context).pushReplacementNamed(Routes.AUTHCHECK);
      return;
    }

    await serviceProvider.loadServicerUser(user);

    final servicerId = serviceProvider.servicerUser.id;

    if (servicerId != null) {
      await chatProvider.loadChats(servicerId);
    }

    roleProvider.changeToServicer();
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _carregarDados();
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

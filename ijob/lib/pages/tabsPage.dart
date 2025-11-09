import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ijob/Core/Entities/profileUserList.dart';
import 'package:ijob/Core/Entities/servicerList.dart';
import 'package:ijob/Core/Entities/userRole.dart';
import 'package:ijob/components/side_bar.dart';
import 'package:ijob/pages/chatsPage.dart';
import 'package:ijob/pages/home_page.dart';
import 'package:ijob/pages/servicos_page.dart';
import 'package:ijob/Core/services/auth_services.dart';
import 'package:provider/provider.dart';

class Tabspage extends StatefulWidget {
  @override
  State<Tabspage> createState() => _TabspageState();
}

class _TabspageState extends State<Tabspage> {
  int _selectedPageIndex = 0;

  final List<Map<String, Object>> _pages = [
    {'title': "Ijob", 'page': HomePage()},
    {'title': 'Serviços', 'page': ServicosPage()},
    {'title': 'Conversas', 'page': Chatspage()},
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    User? user = Provider.of<AuthService>(context, listen: false).usuario;
    Provider.of<Profileuserlist>(context, listen: false).loadProfileUser(user!);
    Provider.of<Servicerlist>(context, listen: false).loadServicers();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        Provider.of<Userrole>(context, listen: false).changeToClient();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: "Início",
          ),
          NavigationDestination(
            icon: Icon(Icons.search_outlined),
            selectedIcon: Icon(Icons.search),
            label: "Serviços",
          ),
          NavigationDestination(
            icon: Icon(Icons.chat_outlined),
            selectedIcon: Icon(Icons.chat),
            label: "Conversas",
          ),
        ],
      ),
      body: _pages[_selectedPageIndex]['page'] as Widget,
    );
  }
}

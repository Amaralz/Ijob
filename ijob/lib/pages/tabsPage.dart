import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ijob/Core/services/geralUse/profileUserList.dart';
import 'package:ijob/Core/services/geralUse/servicerList.dart';
import 'package:ijob/Core/Entities/userRole.dart';
import 'package:ijob/Core/services/chat/chatServices.dart';
import 'package:ijob/Core/utils/routes.dart';
import 'package:ijob/components/side_bar.dart';
import 'package:ijob/pages/chatsPage.dart';
import 'package:ijob/pages/home_page.dart';
import 'package:ijob/pages/servicos_page.dart';
import 'package:ijob/Core/services/auth/authServices.dart';
import 'package:provider/provider.dart';

class Tabspage extends StatefulWidget {
  @override
  State<Tabspage> createState() => _TabspageState();
}

class _TabspageState extends State<Tabspage> {
  int _selectedPageIndex = 0;

  Future<void> _refresh(BuildContext context) async {
    User? user = Provider.of<AuthService>(context, listen: false).usuario;
    if (user == null) {
      return await null;
    }
    return Provider.of<Profileuserlist>(
      context,
      listen: false,
    ).loadProfileUser(user);
  }

  final List<Map<String, Object>> _pages = [
    {'title': "Ijob", 'page': HomePage()},
    {'title': 'Serviços', 'page': ServicosPage()},
    {'title': 'Conversas', 'page': Chatspage()},
  ];

  void _carregarDados() async {
    final authProvider = Provider.of<AuthService>(context, listen: false);
    final userProvider = Provider.of<Profileuserlist>(context, listen: false);
    final chatProvider = Provider.of<Chatservices>(context, listen: false);
    final roleProvider = Provider.of<Userrole>(context, listen: false);
    final servicersProvider = Provider.of<Servicerlist>(context, listen: false);

    User? user = authProvider.usuario;

    if (user == null) {
      Navigator.of(context).pushReplacementNamed(Routes.AUTHCHECK);
      return;
    }

    await userProvider.loadProfileUser(user);

    await servicersProvider.loadServicers();

    final userId = userProvider.profile.id;

    if (userId != null) {
      await chatProvider.loadChats(userId);
    }

    roleProvider.changeToClient();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _carregarDados();
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
      body: RefreshIndicator(
        onRefresh: () => _refresh(context),
        child: _pages[_selectedPageIndex]['page'] as Widget,
      ),
    );
  }
}

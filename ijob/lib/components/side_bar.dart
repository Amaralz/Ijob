import 'package:flutter/material.dart';
import 'package:ijob/utils/routes.dart';

class Sidebar extends StatefulWidget {
  const Sidebar({super.key});

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  int _selectedIndex = 0;

  void _navigateAndSelect(BuildContext context, int index, String route) {
    if (ModalRoute.of(context)?.settings.name == route) {
      Navigator.pop(context);
    } else {
      setState(() {
        _selectedIndex = index;
      });
      Navigator.pop(context);
      Navigator.pushReplacementNamed(context, route);
    }
  }

  void _selected(String rota) {
    Navigator.of(context).popAndPushNamed(rota);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final currentRoute = ModalRoute.of(context)?.settings.name;
      setState(() {
        if (currentRoute == '/homepage') {
          _selectedIndex = 0;
        } else if (currentRoute == '/servicos') {
          _selectedIndex = 1;
        } else if (currentRoute == '/notificacao') {
          _selectedIndex = 2;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            accountName: Text(
              'User',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            accountEmail: Text("email@gmail.com"),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 40, color: Colors.blue),
            ),
          ),

          //botão home
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text("Home"),
            selected: _selectedIndex == 0,
            selectedTileColor: Color.fromRGBO(0, 0, 255, 0.1),
            onTap: () => _navigateAndSelect(context, 0, Routes.HOME),
          ),

          //botão serviços
          ListTile(
            leading: const Icon(Icons.build),
            title: const Text('Serviços'),
            selected: _selectedIndex == 1,
            selectedTileColor: Color.fromRGBO(0, 0, 255, 0.1),
            onTap: () => _selected(Routes.SERVICOS),
          ),

          //botão notificação
          ListTile(
            leading: const Icon(Icons.add_alert),
            title: const Text('Notificações'),
            selected: _selectedIndex == 2,
            selectedTileColor: Color.fromRGBO(0, 0, 255, 0.1),
            onTap: () => _navigateAndSelect(context, 2, Routes.NOTIFICACOES),
          ),
        ],
      ),
    );
  }
}

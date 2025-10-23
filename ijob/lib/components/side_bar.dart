import 'package:flutter/material.dart';

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
              'Lael Amaral',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            accountEmail: Text("lael.amaral@gmail.com"),
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
            onTap: () => _navigateAndSelect(context, 0, '/homepage'),
          ),

          //botão serviços
          ListTile(
            leading: const Icon(Icons.build),
            title: const Text('serviços'),
            selected: _selectedIndex == 1,
            selectedTileColor: Color.fromRGBO(0, 0, 255, 0.1),
            onTap: () => _navigateAndSelect(context, 1, '/servicos'),
          ),

          //botão notificação
          ListTile(
            leading: const Icon(Icons.add_alert),
            title: const Text('notificações'),
            selected: _selectedIndex == 2,
            selectedTileColor: Color.fromRGBO(0, 0, 255, 0.1),
            onTap: () => _navigateAndSelect(context, 2, '/notificacao'),
          ),

          // Expansion Item (adicionado após o último ListTile)
          ExpansionTile(
            leading: const Icon(Icons.filter_b_and_w_outlined),
            title: const Text('Mais'),
            onExpansionChanged: (expanded) {
              print('Expansion Item expanded: $expanded');
            },

            children: [
              // Subitem 1
              ListTile(
                leading: const Icon(Icons.home, size: 20),
                title: const Text('Dashboard'),
                selected: _selectedIndex == 3,
                selectedTileColor: Color.fromRGBO(0, 0, 255, 0.1),
                onTap: () {
                  setState(() {
                    _selectedIndex = 3;
                  });
                  Navigator.pop(context);
                  print('Expansion Item 1 tapped');
                },
              ),

              // Subitem 2
              ListTile(
                leading: const Icon(Icons.contact_mail, size: 20),
                title: const Text('exportar'),
                selected: _selectedIndex == 4,
                selectedTileColor: Color.fromRGBO(0, 0, 255, 0.1),
                onTap: () {
                  setState(() {
                    _selectedIndex = 4;
                  });
                  Navigator.pop(context);
                  print('Expansion Item 2 tapped');
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

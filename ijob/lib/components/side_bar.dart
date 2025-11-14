import 'package:flutter/material.dart';
import 'package:ijob/services/auth_services.dart';
import 'package:ijob/services/database_helper.dart';
import 'package:ijob/utils/routes.dart';
import 'package:provider/provider.dart';

class Sidebar extends StatefulWidget {
  const Sidebar({super.key});

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  String _nome = 'Carregando..';
  int _selectedIndex = 0;

  Future<void> _carregarNome() async {
    if (!mounted) return;

    final user = Provider.of<AuthService>(context, listen: false).usuario;

    if (user != null) {
      final perfil = await DatabaseHelper().buscarPerfil(user.uid);

      if (mounted && perfil != null) {
        setState(() {
          _nome = perfil['nome'] ?? 'Usuário';
        });
      }
    }
  }

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
    Future.microtask(() => _carregarNome());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final currentRoute = ModalRoute.of(context)?.settings.name;
      if (!mounted) return;

      setState(() {
        _selectedIndex = switch (currentRoute) {
          Routes.HOME => 0,
          Routes.EDITARPERFIL => 1,
          Routes.NOTIFICACOES => 2,
          Routes.DASHBOARDCONTRATANTES => 3,
          _ => 0,
        };
      });
    });
  }

  void _onItemTapped(int index, String route) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.pop(context);
    if (ModalRoute.of(context)?.settings.name != route) {
      Navigator.pushNamed(context, route);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            accountName: Text(
              _nome,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            accountEmail: Text(
              Provider.of<AuthService>(context).usuario?.email ?? '',
            ),
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

          //botão perfil
          ListTile(
            leading: const Icon(Icons.account_box),
            title: const Text('Perfil'),
            selected: _selectedIndex == 1,
            selectedTileColor: Color.fromRGBO(0, 0, 255, 0.1),
            onTap: () async {
              setState(() => _selectedIndex = 1);
              Navigator.pop(context);
              Navigator.pushNamed(context, Routes.EDITARPERFIL);
            },
          ),

          //botão notificação
          ListTile(
            leading: const Icon(Icons.add_alert),
            title: const Text('notificações'),
            selected: _selectedIndex == 2,
            selectedTileColor: Color.fromRGBO(0, 0, 255, 0.1),
            onTap: () => _navigateAndSelect(context, 2, Routes.NOTIFICACOES),
          ),

          // Expansion Item (adicionado após o último ListTile)
          ExpansionTile(
            leading: const Icon(Icons.filter_b_and_w_outlined),
            title: const Text('Mais'),
            initiallyExpanded: _selectedIndex >= 3,
            onExpansionChanged: (expanded) {
              if (!expanded && _selectedIndex >= 3) {
                setState(() => _selectedIndex = 0);
              }
            },

            children: [
              // Subitem Dashboard
              ListTile(
                leading: const Icon(Icons.home, size: 20),
                title: const Text('Dashboard'),
                tileColor: _selectedIndex == 3
                    ? Colors.blue.withOpacity(0.1)
                    : null,
                onTap: () {
                  setState(() => _selectedIndex = 3);
                  Navigator.pop(context);
                  Navigator.of(
                    context,
                    rootNavigator: true,
                  ).pushNamed(Routes.DASHBOARDCONTRATANTES);
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
          //LOGOUT
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: OutlinedButton(
              onPressed: () async {
                await Provider.of<AuthService>(context, listen: false).logout();
              },
              style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.all(14.0),
                    child: Text('Sair do App', style: TextStyle(fontSize: 14)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

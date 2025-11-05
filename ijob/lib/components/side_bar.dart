import 'package:flutter/material.dart';
import 'package:ijob/Entities/profileUserList.dart';
import 'package:ijob/services/auth_services.dart';
import 'package:ijob/utils/routes.dart';
import 'package:provider/provider.dart';

class Sidebar extends StatefulWidget {
  const Sidebar({super.key});

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  String _nome = 'Carregando...';

  void _carregarNome() {
    final user = Provider.of<AuthService>(context, listen: false).usuario;
    if (user != null) {
      if (mounted) {
        setState(
          () => _nome = Provider.of<Profileuserlist>(
            context,
            listen: false,
          ).searchProfiler(user.uid)!.nome!,
        );
      }
    }
  }

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
    _carregarNome();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final currentRoute = ModalRoute.of(context)?.settings.name;
      setState(() {
        if (currentRoute == Routes.HOME) {
          _selectedIndex = 0;
        } else if (currentRoute == Routes.CONFIGURACOES) {
          _selectedIndex = 1;
        } else if (currentRoute == Routes.NOTIFICACOES) {
          _selectedIndex = 2;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
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

          //botão configuração
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Configurações'),
            selected: _selectedIndex == 1,
            selectedTileColor: Color.fromRGBO(0, 0, 255, 0.1),
            onTap: () => _navigateAndSelect(context, 1, Routes.CONFIGURACOES),
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
          Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: OutlinedButton(
              onPressed: () async {
                await Provider.of<AuthService>(context, listen: false).logout();
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  Routes.LOGIN,
                  (previousRoutes) => false,
                );
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

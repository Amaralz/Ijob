import 'package:flutter/material.dart';
import 'package:ijob/Core/Entities/profileUser.dart';
import 'package:ijob/Core/Entities/profileUserList.dart';
import 'package:ijob/Core/Entities/servicer.dart';
import 'package:ijob/Core/Entities/servicerList.dart';
import 'package:ijob/Core/Entities/userRole.dart';
import 'package:ijob/Core/services/auth/authServices.dart';
import 'package:ijob/Core/utils/routes.dart';
import 'package:provider/provider.dart';

class Sidebar extends StatefulWidget {
  const Sidebar({super.key});

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  //
  Future<String> _carregarNome(Userrole role) async {
    final user = Provider.of<AuthService>(context, listen: false).usuario;
    if (user == null) return "Visitante";
    try {
      if (role.isUsu) {
        Profileuser? userName = await Provider.of<Profileuserlist>(
          context,
          listen: false,
        ).getProfile(user.uid);
        return userName?.nome ?? "Usuário";
      } else if (role.isServicer) {
        print(Provider.of<Userrole>(context, listen: false).isServicer);
        Servicer? servicerName = await Provider.of<Servicerlist>(
          context,
          listen: false,
        ).getServicer(user.uid);
        return servicerName?.nome ?? "Servidor";
      }
      return "Usuário";
    } catch (e) {
      return "Error";
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
    final role = Provider.of<Userrole>(context);
    final auth = Provider.of<AuthService>(context);
    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            accountName: FutureBuilder<String>(
              future: _carregarNome(role),
              builder: (context, snapshot) {
                String name = "";
                if (snapshot.connectionState == ConnectionState.done) {
                  name = snapshot.data ?? "Usuário";
                }
                if (snapshot.hasError) {
                  name = "Erro ao carregar";
                }
                return Text(
                  name,
                  style: TextStyle(fontWeight: FontWeight.bold),
                );
              },
            ),
            accountEmail: Text(auth.usuario?.email ?? ''),
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
            onTap: () => _navigateAndSelect(
              context,
              0,
              role.isUsu ? Routes.HOME : Routes.SERVICERHOME,
            ),
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

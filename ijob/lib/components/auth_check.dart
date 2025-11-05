import 'package:flutter/material.dart';
import 'package:ijob/Entities/profileUserList.dart';
import 'package:ijob/pages/perfil_page.dart';
import 'package:ijob/pages/tabsPage.dart';
import 'package:ijob/services/auth_services.dart';
import 'package:provider/provider.dart';
import 'package:ijob/pages/login_component.dart';

class AuthCheck extends StatelessWidget {
  AuthCheck({super.key});

  @override
  Widget build(BuildContext context) {
    Future<bool> _perfilExiste(String? userId) async {
      if (userId == null) return false;
      try {
        final perfil = Provider.of<Profileuserlist>(
          context,
          listen: false,
        ).searchProfiler(userId);
        if (perfil == null) {
          return false;
        } else {
          return true;
        }
      } catch (e) {
        print('Erro ao verificar perfil: $e');
        return false;
      }
    }

    return Consumer<AuthService>(
      builder: (context, auth, child) {
        if (auth.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (auth.usuario == null) {
          return const LoginComponent();
        }
        final userId = auth.usuario!.uid;
        return FutureBuilder<bool>(
          future: _perfilExiste(userId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }
            if (snapshot.hasData && !snapshot.data!) {
              return const PerfilPage();
            }
            return Tabspage();
          },
        );
      },
    );
  }
}

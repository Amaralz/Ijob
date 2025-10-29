import 'package:flutter/material.dart';
import 'package:ijob/pages/home_page.dart';
import 'package:ijob/pages/perfil_page.dart';
import 'package:ijob/services/auth_services.dart';
import 'package:provider/provider.dart';
import 'package:ijob/pages/login_component.dart';

class AuthCheck extends StatelessWidget {
  const AuthCheck({super.key});

  Future<bool> _perfilExiste(String? userId) async {
    if (userId == null) return false;
    // Comente por enquanto, pois você não tem a página de perfil
    return true; // TEMPORÁRIO: sempre vai pra HomePage
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthService>(
      builder: (context, auth, child) {
        print(
          'AuthCheck rebuild: isLoading=${auth.isLoading}, usuario=${auth.usuario?.email}',
        );

        if (auth.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (auth.usuario == null) {
          return const LoginComponent();
        }

        // TEMPORÁRIO: vai direto pra HomePage
        return const HomePage();

        // QUANDO TIVER PERFIL:
        // final userId = auth.usuario!.uid;
        // return FutureBuilder<bool>(
        //   future: _perfilExiste(userId),
        //   builder: (context, snapshot) {
        //     if (snapshot.connectionState == ConnectionState.waiting) {
        //       return const Scaffold(body: Center(child: CircularProgressIndicator()));
        //     }
        //     if (snapshot.hasData && !snapshot.data!) {
        //       return const PerfilPage();
        //     }
        //     return const HomePage();
        //   },
        // );
      },
    );
  }
}

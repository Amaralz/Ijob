import 'package:flutter/material.dart';
import 'package:ijob/Core/Entities/userRole.dart';
import 'package:ijob/pages/perfil_page.dart';
import 'package:ijob/pages/tabsPage.dart';
import 'package:ijob/pages/tabsServicer.dart';
import 'package:ijob/Core/services/auth/authServices.dart';
import 'package:provider/provider.dart';
import 'package:ijob/pages/login_component.dart';

class AuthCheck extends StatefulWidget {
  AuthCheck({super.key});

  @override
  State<AuthCheck> createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  Future<int>? _perfilExiste;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final auth = Provider.of<AuthService>(context, listen: false);
    final role = Provider.of<Userrole>(context, listen: false);

    if (auth.usuario != null && _perfilExiste != null) {
      _perfilExiste = auth.defineUserRole(auth.usuario!.uid, role);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthService>(
      child: const Scaffold(body: Center(child: CircularProgressIndicator())),
      builder: (context, auth, child) {
        if (auth.isLoading) {
          return child!;
        }

        if (auth.usuario == null) {
          _perfilExiste == null;
          return const LoginComponent();
        }
        return FutureBuilder<int>(
          future:
              _perfilExiste ??
              auth.defineUserRole(
                auth.usuario!.uid,
                Provider.of<Userrole>(context, listen: false),
              ),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return child!;
            }
            if (snapshot.hasError || !snapshot.hasData || snapshot.data == -1) {
              return const PerfilPage();
            }
            final profileType = snapshot.data;
            switch (profileType) {
              case 0:
                return Tabspage();
              case 1:
                return Tabsservicer();
              default:
                return const PerfilPage();
            }
          },
        );
      },
    );
  }
}

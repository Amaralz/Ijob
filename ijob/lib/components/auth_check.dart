import 'package:cloud_firestore/cloud_firestore.dart';
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
  Future<int> _perfilExiste() async {
    final user = context.read<AuthService>().usuario;
    if (user == null) return -1;

    try {
      final profiler = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (!profiler.exists) return -1;

      final role = profiler.data()?['role'];

      if (role == 0) return 0;
      if (role == 1) return 1;

      return -1;
    } catch (error) {
      return -1;
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
          return const LoginComponent();
        }
        return FutureBuilder<int>(
          future: _perfilExiste(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return child!;
            }
            if (snapshot.hasError || !snapshot.hasData || snapshot.data == -1) {
              return const PerfilPage();
            }
            final profileType = snapshot.data;
            final role = Provider.of<Userrole>(context, listen: false);
            if (profileType == 0) {
              if (!role.isUsu) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted) role.toggleMode();
                });
              }
              return Tabspage();
            } else if (profileType == 1) {
              if (role.isUsu) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted) role.toggleMode();
                });
              }
              return Tabsservicer();
            } else {
              return PerfilPage();
            }
          },
        );
      },
    );
  }
}

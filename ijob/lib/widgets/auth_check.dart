import 'package:flutter/material.dart';
import 'package:ijob/pages/home_page.dart';
import 'package:ijob/services/auth_services.dart';
import 'package:provider/provider.dart';
import 'package:ijob/pages/login_component.dart';

class AuthCheck extends StatefulWidget {
  const AuthCheck({super.key});

  @override
  State<AuthCheck> createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  @override
  Widget build(BuildContext context) {
    AuthService auth = Provider.of<AuthService>(context);
    if (auth.isLoading) {
      return loading();
    } else if (auth.usuario == null) {
      return LoginComponent();
    } else {
      return HomePage();
    }
  }

  loading() {
    return Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}

import 'package:flutter/material.dart';
import 'components/login_component.dart';
import 'components/cadastro_component.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'App de Cadastro',
      initialRoute: '/',
      routes: {
        '/': (context) => LoginComponent(),
        '/cadastro': (context) => CadastroComponent(),
      },
    ),
  );
}

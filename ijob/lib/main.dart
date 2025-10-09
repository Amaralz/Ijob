import 'package:flutter/material.dart';
import 'package:ijob/pages/notificacao_page.dart';
import 'package:ijob/pages/servicos_page.dart';
import 'pages/login_component.dart';
import 'pages/cadastro_component.dart';
import 'pages/home_page.dart';
import 'pages/servicosFiltrados_page.dart';
import 'utils/routes.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'App de Cadastro',

      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
      ),

      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      ),
      themeMode: ThemeMode.system,

      initialRoute: '/',
      routes: {
        Routes.LOGIN: (context) => LoginComponent(),
        Routes.CADASTRO: (context) => CadastroComponent(),
        Routes.HOME: (context) => HomePage(),
        Routes.SERVICOS: (context) => ServicosPage(),
        Routes.NOTIFICACOES: (context) => NotificacaoPage(),
        Routes.SERVICOSFILTRADOS: (context) => ServicosfiltradosPage(),
      },
    ),
  );
}

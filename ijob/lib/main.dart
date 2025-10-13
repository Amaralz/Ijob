import 'package:flutter/material.dart';
import 'package:ijob/Entities/servicerList.dart';
import 'package:ijob/pages/notificacao_page.dart';
import 'package:ijob/pages/tabsPage.dart';
import 'package:provider/provider.dart';
import 'pages/login_component.dart';
import 'pages/cadastro_component.dart';
import 'pages/servicosFiltrados_page.dart';
import 'utils/routes.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ChangeNotifierProvider(
      create: (_) => Servicerlist(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
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
          Routes.HOME: (context) => Tabspage(),
          Routes.NOTIFICACOES: (context) => NotificacaoPage(),
          Routes.SERVICOSFILTRADOS: (context) => ServicosfiltradosPage(),
        },
      ),
    );
  }
}

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ijob/Entities/categorList.dart';
import 'package:ijob/Entities/servicerList.dart';
import 'package:ijob/pages/configuracoes_page.dart';
import 'package:ijob/pages/notificacao_page.dart';
import 'package:ijob/pages/perfil_page.dart';
import 'package:ijob/pages/prestador_page.dart';
import 'package:ijob/pages/servicosFiltrados_page.dart';
import 'package:ijob/pages/servicos_page.dart';
import 'package:ijob/pages/tabsPage.dart';
import 'package:ijob/services/database_helper.dart';
import 'package:ijob/utils/routes.dart';
import 'package:ijob/widgets/auth_check.dart';
import 'package:provider/provider.dart';
import 'services/auth_services.dart';
//import 'package:ijob/pages/home_page.dart';
import 'pages/login_component.dart';
import 'pages/cadastro_component.dart';
import 'pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await DatabaseHelper().database;

  final authService = AuthService();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: authService),
        ChangeNotifierProvider(create: (_) => Servicerlist()),
        ChangeNotifierProvider(create: (_) => Categorlist()),
      ],

      child: MaterialApp(
        title: 'Ijob',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.light,
          primarySwatch: Colors.blue,
        ),

        darkTheme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.blue,
        ),
        themeMode: ThemeMode.system,

        initialRoute: '/auth_check',
        routes: {
          Routes.AUTHCHECK: (context) => AuthCheck(),
          Routes.LOGIN: (context) => LoginComponent(),
          Routes.CADASTRO: (context) => CadastroComponent(),
          Routes.PERFIL: (context) => const PerfilPage(),
          Routes.HOME: (context) => Tabspage(),
          Routes.SERVICOSFILTRADOS: (context) => ServicosfiltradosPage(),
          Routes.PRESTADOR: (context) => Prestadorpage(),
          Routes.CONFIGURACOES: (context) => ConfiguracoesPage(),
          Routes.NOTIFICACOES: (context) => NotificacaoPage(),
        },
      ),
    ),
  );
}

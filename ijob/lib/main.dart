import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ijob/Components/auth_check.dart';
import 'package:ijob/Entities/categorList.dart';
import 'package:ijob/Entities/profileUserList.dart';
import 'package:ijob/Entities/servicerList.dart';
import 'package:ijob/pages/configuracoes_page.dart';
import 'package:ijob/pages/notificacao_page.dart';
import 'package:ijob/pages/prestador_page.dart';
import 'package:ijob/pages/tabsPage.dart';
import 'package:ijob/services/auth_services.dart';
import 'package:provider/provider.dart';
import 'pages/login_component.dart';
import 'pages/cadastro_component.dart';
import 'pages/servicosFiltrados_page.dart';
import 'utils/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ChangeNotifierProvider(create: (_) => AuthService(), child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Profileuserlist()),
        ChangeNotifierProvider(create: (_) => Servicerlist()),
        ChangeNotifierProvider(create: (_) => Categorlist()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'App de Cadastro',

        theme: ThemeData(
          brightness: Brightness.light,
          colorSchemeSeed: Colors.blue,
        ),

        darkTheme: ThemeData(
          brightness: Brightness.dark,
          colorSchemeSeed: Colors.blue,
        ),
        themeMode: ThemeMode.system,

        initialRoute: Routes.LOGIN,
        routes: {
          Routes.AUTHCHECK: (context) => AuthCheck(),
          Routes.LOGIN: (context) => LoginComponent(),
          Routes.CADASTRO: (context) => CadastroComponent(),
          Routes.HOME: (context) => Tabspage(),
          Routes.NOTIFICACOES: (context) => NotificacaoPage(),
          Routes.SERVICOSFILTRADOS: (context) => ServicosfiltradosPage(),
          Routes.CONFIGURACOES: (context) => ConfiguracoesPage(),
          Routes.PRESTADOR: (context) => Prestadorpage(),
        },
      ),
    );
  }
}

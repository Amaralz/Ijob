import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ijob/pages/notificacao_page.dart';
import 'package:ijob/pages/servicos_page.dart';
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

  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => AuthService())],

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
          '/auth_check': (context) => AuthCheck(),
          '/cadastro': (context) => CadastroComponent(),
          '/homepage': (context) => HomePage(),
          '/servicos': (context) => ServicosPage(),
          '/notificacao': (context) => NotificacaoPage(),
        },
      ),
    ),
  );
}

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ijob/Components/auth_check.dart';
import 'package:ijob/Core/services/geralUse/categorList.dart';
import 'package:ijob/Core/services/geralUse/profileUserList.dart';
import 'package:ijob/Core/services/geralUse/servicerList.dart';
import 'package:ijob/Core/Entities/userRole.dart';
import 'package:ijob/Core/services/chat/chatServices.dart';
import 'package:ijob/Core/services/chat/requestMessageServices.dart';
import 'package:ijob/Core/services/order/orderServicer.dart';
import 'package:ijob/pages/chatsPage.dart';
import 'package:ijob/pages/configuracoes_page.dart';
import 'package:ijob/pages/dashboardPage.dart';
import 'package:ijob/pages/editar_perfil_page.dart';
import 'package:ijob/pages/innerChatPage.dart';
import 'package:ijob/pages/notificacao_page.dart';
import 'package:ijob/pages/ordersPage.dart';
import 'package:ijob/pages/perfil_page.dart';
import 'package:ijob/pages/prestador_page.dart';
import 'package:ijob/pages/tabsPage.dart';
import 'package:ijob/pages/tabsServicer.dart';
import 'package:ijob/Core/services/auth/authServices.dart';
import 'package:provider/provider.dart';
import 'pages/login_component.dart';
import 'pages/cadastro_component.dart';
import 'pages/servicosFiltrados_page.dart';
import 'Core/utils/routes.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await initializeDateFormatting('pt_BR', null);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => Userrole()),
        ChangeNotifierProvider(create: (_) => Profileuserlist()),
        ChangeNotifierProvider(create: (_) => Servicerlist()),
        ChangeNotifierProvider(create: (_) => Categorlist()),
        ChangeNotifierProvider(create: (_) => Chatservices()),
        ChangeNotifierProvider(create: (_) => Requestmessageservices()),
        ChangeNotifierProvider(create: (_) => Orderservicer()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'App de Cadastro',

        theme: ThemeData(
          brightness: Brightness.light,
          colorSchemeSeed: Colors.red,
          secondaryHeaderColor: Colors.redAccent,
        ),

        darkTheme: ThemeData(
          brightness: Brightness.dark,
          colorSchemeSeed: Colors.blue,
          secondaryHeaderColor: Colors.lightBlue,
          hintColor: const Color.fromARGB(255, 99, 206, 255),
        ),
        themeMode: ThemeMode.system,

        initialRoute: Routes.AUTHCHECK,
        routes: {
          Routes.AUTHCHECK: (context) => AuthCheck(),
          Routes.LOGIN: (context) => LoginComponent(),
          Routes.CADASTRO: (context) => CadastroComponent(),
          Routes.HOME: (context) => Tabspage(),
          Routes.SERVICERHOME: (context) => Tabsservicer(),
          Routes.NOTIFICACOES: (context) => NotificacaoPage(),
          Routes.SERVICOSFILTRADOS: (context) => ServicosfiltradosPage(),
          Routes.CONFIGURACOES: (context) => ConfiguracoesPage(),
          Routes.PRESTADOR: (context) => Prestadorpage(),
          Routes.CHAT: (context) => Chatspage(),
          Routes.PERFIL: (context) => PerfilPage(),
          Routes.INNERCHAT: (context) => Innerchatpage(),
          Routes.ORDERS: (context) => Orderspage(),
          Routes.DASHBOARD: (context) => Dashboardpage(),
          Routes.EDIT: (context) => EditarPerfilPage(),
        },
      ),
    );
  }
}

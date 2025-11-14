import 'package:flutter/material.dart';
import 'package:ijob/services/auth_services.dart';
import 'package:ijob/services/database_helper.dart';
import 'package:ijob/services/perfil_provider.dart';
import 'package:provider/provider.dart';

class topBarPrimaryPage extends StatefulWidget {
  const topBarPrimaryPage({super.key});

  @override
  State<topBarPrimaryPage> createState() => _topBarPrimaryPageState();
}

class _topBarPrimaryPageState extends State<topBarPrimaryPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PerfilProvider>(
      builder: (context, perfilProvider, child) {
        if (perfilProvider.isLoading) {
          return _buildLoading();
        }

        final perfil = perfilProvider.perfil;
        final nome = perfil?['nome'] ?? 'Usuário';
        final genero = perfil?['genero'] ?? 'M';
        final saudacao = genero == 'Feminino' ? 'bem-vinda!' : 'Bem-vindo!';

        return _buildTopBar(saudacao, nome);
      },
    );
  }

  Widget _buildLoading() {
    return Container(
      height: 130,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: const Color.fromARGB(255, 20, 20, 20),
        boxShadow: [
          BoxShadow(color: Colors.black, spreadRadius: 1, blurRadius: 6),
        ],
      ),
      child: Center(
        child: Text('Carregando...', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _buildTopBar(String saudacao, String nome) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: const Color.fromARGB(255, 20, 20, 20),
        boxShadow: [
          BoxShadow(color: Colors.black, spreadRadius: 1, blurRadius: 6),
        ],
      ),
      height: 130,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(7.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 370,
                  height: 100,
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(
                        "https://pt.quizur.com/_image?href=https://img.quizur.com/f/img5f0c80e0bd9d08.31973740.jpg?lastEdited=1594654954&w=600&h=600&f=webp",
                      ),
                    ),
                    title: Text(
                      saudacao,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    subtitle: Text(nome, style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

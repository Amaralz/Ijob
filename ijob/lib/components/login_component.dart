import 'package:flutter/material.dart';

class LoginComponent extends StatelessWidget {
  final TextEditingController usuarioController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: usuarioController,
              decoration: const InputDecoration(labelText: 'Usuário'),
            ),
            TextField(
              controller: senhaController,
              decoration: const InputDecoration(labelText: 'Senha'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // lógica de login
              },
              child: Text('Enviar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/cadastro');
              },
              child: Text('Não sou cadastrado'),
            ),
          ],
        ),
      ),
    );
  }
}

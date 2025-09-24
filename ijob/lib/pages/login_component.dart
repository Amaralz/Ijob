import 'package:flutter/material.dart';

class LoginComponent extends StatefulWidget {
  @override
  _LoginComponentState createState() => _LoginComponentState();
}

class _LoginComponentState extends State<LoginComponent> {
  final TextEditingController usuarioController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();

  void _login() {
    String usuario = usuarioController.text;
    String senha = senhaController.text;

    if (usuario == 'admin' && senha == '123') {
      Navigator.pushNamed(context, '/homepage');
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('usuario ou senha invalidos!')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(''), centerTitle: true), //iperson
      body: Padding(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset(
                'assets/images/trabalhadores.png',
                height: 120,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
              ),
              SizedBox(height: 40),
              Text(
                'LOGIN',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),

              TextField(
                controller: usuarioController,
                decoration: const InputDecoration(labelText: 'Usuário'),
                onSubmitted: (_) => _login(),
              ),
              TextField(
                controller: senhaController,
                decoration: const InputDecoration(labelText: 'Senha'),
                obscureText: true,
                onSubmitted: (_) => _login(),
              ),
              SizedBox(height: 20),

              ElevatedButton(
                onPressed: () {
                  _login();
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
      ),
    );
  }
}

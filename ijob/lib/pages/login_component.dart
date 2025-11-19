import 'package:flutter/material.dart';
import 'package:ijob/Core/services/auth/authServices.dart';
import 'package:ijob/Core/utils/routes.dart';
import 'package:provider/provider.dart';

/*import 'package:ijob/pages/home_page.dart';
import 'package:ijob/services/auth_services.dart';
*/
class LoginComponent extends StatefulWidget {
  const LoginComponent({Key? key}) : super(key: key);
  @override
  _LoginComponentState createState() => _LoginComponentState();
}

class _LoginComponentState extends State<LoginComponent> {
  final _formkey = GlobalKey<FormState>();
  final usuarioController = TextEditingController();
  final senhaController = TextEditingController();
  bool loading = false;

  Future<void> login() async {
    if (_formkey.currentState!.validate()) {
      setState(() => loading = true);
      try {
        await context.read<AuthService>().login(
          usuarioController.text.trim(),
          senhaController.text,
        );
        if (mounted) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            Routes.AUTHCHECK,
            (route) => false,
          );
        }
      } catch (e) {
        if (mounted) {
          setState(() => loading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                e is AuthException
                    ? e.message
                    : 'Erro inesperado ao fazer login',
              ),
            ),
          );
        }
      }
    }
  }

  @override
  void dispose() {
    usuarioController.dispose();
    senhaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Form(
              key: _formkey,
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
                  const SizedBox(height: 40),
                  const Text(
                    'LOGIN',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  //LOGIN
                  TextFormField(
                    controller: usuarioController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Informe o email corretamente!';
                      }
                      if (!RegExp(
                        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                      ).hasMatch(value)) {
                        return 'informe um email válido!';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  //SENHA
                  TextFormField(
                    controller: senhaController,
                    decoration: const InputDecoration(
                      labelText: 'Senha',
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'informe sua senha!';
                      } else if (value.length < 6) {
                        return 'sua senha deve ter no mínimo 6 caracteres';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  //BOTÃO ENVIAR
                  ElevatedButton(
                    onPressed: loading ? null : login,
                    child: loading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : const Text('LOGIN'),
                  ),
                  //BOTÃO CADASTRAR
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/cadastro');
                    },
                    child: const Text(
                      'Ainda não tem conta? Cadastre-se agora.',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

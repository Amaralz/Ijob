import 'package:flutter/material.dart';
import 'package:ijob/utils/routes.dart';
import 'package:provider/provider.dart';
import 'package:ijob/services/auth_services.dart';

class CadastroComponent extends StatefulWidget {
  const CadastroComponent({super.key});

  @override
  State<CadastroComponent> createState() => _CadastroComponentState();
}

class _CadastroComponentState extends State<CadastroComponent> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final senhaController = TextEditingController();
  bool loading = false;

  Future<void> registrar() async {
    if (_formKey.currentState!.validate()) {
      setState(() => loading = true);
      try {
        await context.read<AuthService>().registrar(
          emailController.text.trim(),
          senhaController.text,
        );
        if (mounted) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            Routes.PERFIL,
            (route) => false,
          );
        }
      } catch (e) {
        if (mounted) {
          setState(() => loading = false);
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                e is AuthException ? e.message : 'Erro inesperado ao cadastrar',
              ),
            ),
          );
        }
      }
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    senhaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
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
                    'CADASTRO',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  //Campo de Email
                  TextFormField(
                    controller: emailController,
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
                        return 'Informe um email válido!';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  //Campo de senha
                  TextFormField(
                    controller: senhaController,
                    decoration: const InputDecoration(
                      labelText: 'Senha',
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Informe sua senha!';
                      } else if (value.length < 6) {
                        return 'Sua senha deve ter no mínimo 6 caracteres';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  //Botão de Cadastrar
                  ElevatedButton(
                    onPressed: loading ? null : registrar,
                    child: loading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : const Text('CADASTRAR'),
                  ),
                  //Botão de voltar ao login
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, Routes.LOGIN);
                    },
                    child: const Text('Já tem conta? Faça login.'),
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

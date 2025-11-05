import 'package:flutter/material.dart';
import 'package:ijob/Entities/profileUser.dart';
import 'package:ijob/Entities/profileUserList.dart';
import 'package:ijob/services/auth_services.dart';
import 'package:ijob/utils/routes.dart';
import 'package:provider/provider.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class PerfilPage extends StatefulWidget {
  const PerfilPage({super.key});

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _cpfController = TextEditingController();
  final _bairroController = TextEditingController();
  final _celularcontroller = TextEditingController();
  String? _genero;

  bool _loading = false;

  final cpfFormatter = MaskTextInputFormatter(
    mask: '###.###.###.##',
    filter: {"#": RegExp(r'[0-9]')},
  );

  final celularFormatter = MaskTextInputFormatter(
    mask: '(##) #####-####',
    filter: {"#": RegExp(r'[0-9]')},
  );

  Future<void> _salvarPerfil() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    final user = Provider.of<AuthService>(context, listen: false).usuario;
    if (user == null) return;

    final Profileuser perfil = Profileuser(
      id: user.uid,
      nome: _nomeController.text.trim(),
      cpf: _cpfController.text.replaceAll(RegExp(r'\D'), ''),
      celular: _celularcontroller.text.replaceAll(RegExp(r'\D'), ''),
      genero: _genero!,
      bairro: _bairroController.text.trim(),
    );

    /* final perfil = {
      'id': user.uid,
      'nome': _nomeController.text.trim(),
      'cpf': _cpfController.text.replaceAll(RegExp(r'\D'), ''),
      'bairro': _bairroController.text.trim(),
      'celular': _celularcontroller.text.replaceAll(RegExp(r'\D'), ''),
      'genero': _genero!,
    };*/

    Provider.of<Profileuserlist>(context, listen: false).addProfiler(perfil);

    /* try {
      await DatabaseHelper().inserirPerfil(perfil);
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/auth_check',
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erro ao salvar perfil: $e')));
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }*/

    setState(() {
      _loading = false;
    });

    Navigator.pushNamedAndRemoveUntil(
      context,
      Routes.AUTHCHECK,
      (route) => false,
    );
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _cpfController.dispose();
    _bairroController.dispose();
    _celularcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Completar Perfil')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Text(
                'Preencha seus dados para continuar ',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),

              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(
                  labelText: 'Nome Completo',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v!.trim().isEmpty ? 'Obrigatorio' : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _cpfController,
                decoration: const InputDecoration(
                  labelText: 'CPF',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [cpfFormatter],
                validator: (v) {
                  final cpf = v!.replaceAll(RegExp(r'\D'), '');
                  if (cpf.length != 11) return 'CPF inválido';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _bairroController,
                decoration: const InputDecoration(
                  labelText: 'Bairro',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v!.trim().isEmpty ? 'Obrigatorio' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _celularcontroller,
                decoration: const InputDecoration(
                  labelText: 'Celular',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                inputFormatters: [celularFormatter],
                validator: (v) {
                  final cel = v!.replaceAll(RegExp(r'\D'), '');
                  if (cel.length < 10) return 'Celular inválido';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _genero,
                decoration: const InputDecoration(
                  labelText: 'Gênero',
                  border: OutlineInputBorder(),
                ),
                items: ['Masculino', 'Feminino', 'Outro']
                    .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                    .toList(),
                onChanged: (v) => setState(() => _genero = v),
                validator: (v) => v == null ? 'Selecione um gênero' : null,
              ),
              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _loading ? null : _salvarPerfil,
                  child: _loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'SALVAR E CONTINUAR',
                          style: TextStyle(fontSize: 16),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

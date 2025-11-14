import 'package:flutter/material.dart';
import 'package:ijob/services/auth_services.dart';
import 'package:ijob/services/database_helper.dart';
import 'package:ijob/utils/routes.dart';
import 'package:provider/provider.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PerfilPage extends StatefulWidget {
  const PerfilPage({super.key});

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _cpfController = TextEditingController();
  final _ruaController = TextEditingController();
  final _numeroController = TextEditingController();
  final _celularcontroller = TextEditingController();
  final _bairroController = TextEditingController();
  final _cidadeController = TextEditingController();
  String? _genero;
  String? _role;
  String? _paisSelecionado;
  String? _estadoSelecionado;

  bool _loading = false;

  final List<Map<String, String>> _paises = [
    {'nome': 'Brasil', 'codigo': 'BR'},
    {'nome': 'Argentina', 'codigo': 'AR'},
    {'nome': 'Estados Unidos', 'codigo': 'US'},
    {'nome': 'México', 'codigo': 'MX'},
    {'nome': 'Chile', 'codigo': 'CL'},
    {'nome': 'Colômbia', 'codigo': 'CO'},
  ];

  final Map<String, List<String>> _estadoPorPais = {
    'BR': ['São Paulo', 'Rio de Janeiro', 'Minas Gerais', 'Bahia', 'Paraná'],
  };

  Future<bool> _verificarCpfUnico(String cpf) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('cpf', isEqualTo: cpf)
        .limit(1)
        .get();
    return snapshot.docs.isEmpty;
  }

  Future<bool> _verificarCelularUnico(String celular) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('celular', isEqualTo: celular)
        .limit(1)
        .get();
    return snapshot.docs.isEmpty;
  }

  final cpfFormatter = MaskTextInputFormatter(
    mask: '###.###.###.##',
    filter: {"#": RegExp(r'[0-9]')},
  );

  final celularFormatter = MaskTextInputFormatter(
    mask: '(##) #####-####',
    filter: {"#": RegExp(r'[0-9]')},
  );

  Future<void> _salvarPerfil() async {
    final cpfLimpo = _cpfController.text.replaceAll(RegExp(r'\D'), '');
    final celularLimpo = _celularcontroller.text.replaceAll(RegExp(r'\D'), '');

    if (await DatabaseHelper().cpfExiste(cpfLimpo)) {
      _showError('CPF já cadastrado localmente!');
      return;
    }

    if (!(await _verificarCpfUnico(cpfLimpo))) {
      _showError('CPF já existe em outra conta!');
      return;
    }

    if (await DatabaseHelper().celularExiste(celularLimpo)) {
      _showError('Celular já cadastrado localmente!');
      return;
    }

    if (!(await _verificarCelularUnico(celularLimpo))) {
      _showError('Celular já existe em outra conta!');
      return;
    }

    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    final user = Provider.of<AuthService>(context, listen: false).usuario;
    if (user == null) return;

    //Salvar no SQFLITE (localmente)
    final perfilLocal = {
      'id': user.uid,
      'nome': _nomeController.text.trim(),
      'cpf': cpfLimpo,
      'rua': _ruaController.text.trim(),
      'numero': _numeroController.text.trim(),
      'bairro': _bairroController.text.trim(),
      'cidade': _cidadeController.text.trim(),
      'estado': _estadoSelecionado ?? '',
      'pais': _paisSelecionado ?? '',
      'celular': celularLimpo,
      'genero': _genero!,
    };

    try {
      //Salvar no SQFLITE (localmente)
      await DatabaseHelper().inserirPerfil(perfilLocal);

      //Salvar no FIRESTORE (Nuvem)
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set(perfilLocal, SetOptions(merge: true));
      //redireciona para authcheck
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          Routes.AUTHCHECK,
          (route) => false,
        );
      }
    } catch (e) {
      _showError('Erro ao salvar perfil: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _showError(String msg) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
      setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _cpfController.dispose();
    _ruaController.dispose();
    _cidadeController.dispose();
    _bairroController.dispose();
    _numeroController.dispose();
    _celularcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Completar Perfil'),
        actions: [
          TextButton(
            onPressed: () async {
              await Provider.of<AuthService>(context, listen: false).logout();
              if (mounted) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  Routes.LOGIN,
                  (route) => false,
                );
              }
            },
            child: Text(
              'voltar ao login',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
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
              //NOME
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(
                  labelText: 'Nome Completo',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v!.trim().isEmpty ? 'Obrigatorio' : null,
              ),
              const SizedBox(height: 16),
              //CPF
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
              //PAÍS
              DropdownButtonFormField(
                value: _paisSelecionado,
                decoration: const InputDecoration(
                  labelText: 'pais',
                  border: OutlineInputBorder(),
                ),
                hint: const Text('Selecione o país'),
                items: _paises.map((pais) {
                  return DropdownMenuItem(
                    value: pais['codigo'],
                    child: Text('${pais['codigo']} (${pais['nome']})'),
                  );
                }).toList(),
                onChanged: (v) => setState(() {
                  _paisSelecionado = v;
                  _estadoSelecionado = null;
                }),
                validator: (v) => v == null ? 'Obrigatório' : null,
              ),
              const SizedBox(height: 16),
              //ESTADO
              DropdownButtonFormField<String>(
                value: _estadoSelecionado,
                decoration: const InputDecoration(
                  labelText: 'Estado',
                  border: OutlineInputBorder(),
                ),
                hint: const Text('Selecione o estado'),
                items: (_estadoPorPais[_paisSelecionado] ?? []).map((estado) {
                  return DropdownMenuItem(value: estado, child: Text(estado));
                }).toList(),
                onChanged: _paisSelecionado == 'BR'
                    ? (v) => setState(() => _estadoSelecionado = v)
                    : null,
                validator: (v) => _paisSelecionado == 'BR' && v == null
                    ? 'Obrigatório'
                    : null,
              ),
              const SizedBox(height: 16),
              //CIDADE
              TextFormField(
                controller: _cidadeController,
                decoration: const InputDecoration(
                  labelText: 'Cidade',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v!.trim().isEmpty ? 'Obrigatório' : null,
              ),
              const SizedBox(height: 16),
              //BAIRRO
              TextFormField(
                controller: _bairroController,
                decoration: const InputDecoration(
                  labelText: 'Bairro',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v!.trim().isEmpty ? 'Obrigatorio' : null,
              ),
              const SizedBox(height: 16),
              //RUA
              TextFormField(
                controller: _ruaController,
                decoration: const InputDecoration(
                  labelText: 'Rua',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v!.trim().isEmpty ? 'Obrigatório' : null,
              ),
              const SizedBox(height: 16),
              //NUMERO
              TextFormField(
                controller: _numeroController,
                decoration: const InputDecoration(
                  labelText: 'Numero',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (v) => v!.trim().isEmpty ? 'Obrigatorio' : null,
              ),
              const SizedBox(height: 16),
              //CELULAR
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
              //GENERO
              DropdownButtonFormField<String>(
                value: _genero,
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
              const SizedBox(height: 16),
              //ROLE
              DropdownButtonFormField<String>(
                value: _role,
                decoration: const InputDecoration(
                  labelText: 'tipo de conta',
                  border: OutlineInputBorder(),
                ),
                items: [
                  DropdownMenuItem(value: 'user', child: Text('Cliente')),
                  DropdownMenuItem(value: 'provider', child: Text('prestador')),
                ],
                onChanged: (v) => setState(() => _role = v),
                validator: (v) => v == null ? 'Selecione uma opção' : null,
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

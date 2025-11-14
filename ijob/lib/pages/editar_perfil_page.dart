import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ijob/services/auth_services.dart';
import 'package:ijob/services/database_helper.dart';
import 'package:ijob/services/perfil_provider.dart';
import 'package:ijob/utils/routes.dart';
import 'package:provider/provider.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:sqflite/sqflite.dart';

class EditarPerfilPage extends StatefulWidget {
  const EditarPerfilPage({super.key});

  @override
  State<EditarPerfilPage> createState() => _EditarPerfilPageState();
}

class _EditarPerfilPageState extends State<EditarPerfilPage> {
  final _formKey = GlobalKey<FormState>();
  Map<String, dynamic>? _perfil;

  final _nomeController = TextEditingController();
  final _cpfController = TextEditingController();
  final _ruaController = TextEditingController();
  final _numeroController = TextEditingController();
  final _bairroController = TextEditingController();
  final _cidadeController = TextEditingController();
  final _celularController = TextEditingController();

  String? _role;
  String? _genero;
  String? _paisSelecionado;
  String? _estadoSelecionado;

  bool _loading = false;

  final cpfFormatter = MaskTextInputFormatter(
    mask: '###.###.###.##',
    filter: {"#": RegExp(r'[0-9]')},
  );

  final celularFormatter = MaskTextInputFormatter(
    mask: '(##) #####-####',
    filter: {"#": RegExp(r'[0-9]')},
  );

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

  @override
  void initState() {
    super.initState();
    _carregarPerfil();
  }

  void _preencherFormulario(Map<String, dynamic> perfil) {
    setState(() {
      _perfil = perfil;

      _nomeController.text = perfil['nome'] ?? '';
      _cpfController.text = _formatarCpf(perfil['cpf'] ?? '');
      _ruaController.text = perfil['rua'] ?? '';
      _numeroController.text = perfil['numero'] ?? '';
      _bairroController.text = perfil['bairro'] ?? '';
      _cidadeController.text = perfil['cidade'] ?? '';
      _celularController.text = _formatarCelular(perfil['celular'] ?? '');

      _genero = perfil['genero'];
      _role = perfil['role'];
      _paisSelecionado = perfil['pais'];
      _estadoSelecionado = perfil['estado'];
    });
  }

  Future<void> _carregarPerfil() async {
    final user = Provider.of<AuthService>(context, listen: false).usuario;
    if (user == null) {
      if (mounted) setState(() => _perfil = {});
      return;
    }

    final perfilLocal = await DatabaseHelper().buscarPerfil(user.uid);
    if (perfilLocal != null && mounted) {
      _preencherFormulario(perfilLocal);
      return;
    }

    final perfilFirestore = await DatabaseHelper().getPerfil(user.uid);
    if (perfilFirestore != null && mounted) {
      await DatabaseHelper().inserirPerfil({
        'id': user.uid,
        ...perfilFirestore,
      });
      _preencherFormulario(perfilFirestore);
    } else {
      if (mounted) {
        setState(() {
          _perfil = {};
          _preencherFormulario({});
        });
      }
    }
  }

  String _formatarCpf(String cpf) {
    if (cpf.length != 11) return cpf;
    return '${cpf.substring(0, 3)}.${cpf.substring(3, 6)}.${cpf.substring(6, 9)}-${cpf.substring(9)}';
  }

  String _formatarCelular(String cel) {
    if (cel.length != 11) return cel;
    return '(${cel.substring(0, 2)}) ${cel.substring(2, 7)}-${cel.substring(7)}';
  }

  Future<void> _salvarEdicao() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    final user = Provider.of<AuthService>(context, listen: false).usuario;
    if (user == null) return;

    final cpfLimpo = _cpfController.text.replaceAll(RegExp(r'\D'), '');
    final celularLimpo = _celularController.text.replaceAll(RegExp(r'\D'), '');

    final perfilAtualizado = {
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
      'role': _role!,
    };

    try {
      //SALVAR NO FIRESTORE
      await DatabaseHelper().atualizarPerfil(user.uid, perfilAtualizado);

      //SALVAR NO SQFLITE
      await DatabaseHelper().inserirPerfil(perfilAtualizado);

      context.read<PerfilProvider>().atualizarPerfil(perfilAtualizado);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('perfil atualizado com sucesso!')),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro:$e')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _confirmarExclusao(BuildContext context) async {
    final confirmou = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir conta?'),
        content: const Text(
          'ATENÇÃO: Está ação é IRREVERSíVEL.\n\n'
          'Todos os seus dados serão apagados permanentemente.\n'
          'você será desconectado.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('EXCLUIR PARA SEMPRE!'),
          ),
        ],
      ),
    );

    if (confirmou != true) return;

    await _deletarConta(context);
  }

  Future<void> _deletarConta(BuildContext context) async {
    final user = Provider.of<AuthService>(context, listen: false).usuario;
    if (user == null) return;

    setState(() => _loading = true);

    try {
      //DELETA DO FIREBASE AUTH
      await user.delete();

      //DELETA DO SQFLITE
      await DatabaseHelper().deletarPerfil(user.uid);

      //DELETA DO FIRESTORE
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .delete();

      //FAZ LOGOUT
      await Provider.of<AuthService>(context, listen: false).logout();

      //VOLTA PARA O LOGIN
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          Routes.LOGIN,
          (route) => false,
        );
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Conta excluida com sucesso.')),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text(
                'Para excluir a conta, faça login novamente.',
              ),
              backgroundColor: Colors.orange[700],
              duration: const Duration(seconds: 10),
              action: SnackBarAction(
                label: 'Fazer login',
                textColor: Colors.white,
                onPressed: () async {
                  //FAZ O LOGOUT
                  await Provider.of<AuthService>(
                    context,
                    listen: false,
                  ).logout();
                  //VOLTA PARA O LOGIN
                  if (mounted) {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      Routes.LOGIN,
                      (route) => false,
                    );
                  }
                },
              ),
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erro ao excluir conta: ${e.message}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erro: $e')));
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _cpfController.dispose();
    _ruaController.dispose();
    _numeroController.dispose();
    _bairroController.dispose();
    _cidadeController.dispose();
    _celularController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthService>(context, listen: false).usuario;
    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Editar Perfil')),
        body: const Center(child: Text('Usuário não autenticado')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Perfil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever, color: Colors.red),
            onPressed: () => _confirmarExclusao(context),
            tooltip: 'Excluir conta permanentemente!',
          ),
        ],
      ),
      body: _perfil == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const Text(
                      'Preencha seus dados para continuar ',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
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
                      validator: (v) =>
                          v!.trim().isEmpty ? 'Obrigatorio' : null,
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
                      items: (_estadoPorPais[_paisSelecionado] ?? []).map((
                        estado,
                      ) {
                        return DropdownMenuItem(
                          value: estado,
                          child: Text(estado),
                        );
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
                      validator: (v) =>
                          v!.trim().isEmpty ? 'Obrigatório' : null,
                    ),
                    const SizedBox(height: 16),
                    //BAIRRO
                    TextFormField(
                      controller: _bairroController,
                      decoration: const InputDecoration(
                        labelText: 'Bairro',
                        border: OutlineInputBorder(),
                      ),
                      validator: (v) =>
                          v!.trim().isEmpty ? 'Obrigatório' : null,
                    ),
                    const SizedBox(height: 16),
                    //RUA
                    TextFormField(
                      controller: _ruaController,
                      decoration: const InputDecoration(
                        labelText: 'Rua',
                        border: OutlineInputBorder(),
                      ),
                      validator: (v) =>
                          v!.trim().isEmpty ? 'Obrigatório' : null,
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
                      validator: (v) =>
                          v!.trim().isEmpty ? 'Obrigatorio' : null,
                    ),
                    const SizedBox(height: 16),
                    //CELULAR
                    TextFormField(
                      controller: _celularController,
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
                          .map(
                            (g) => DropdownMenuItem(value: g, child: Text(g)),
                          )
                          .toList(),
                      onChanged: (v) => setState(() => _genero = v),
                      validator: (v) =>
                          v == null ? 'Selecione um gênero' : null,
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
                        DropdownMenuItem(
                          value: 'provider',
                          child: Text('prestador'),
                        ),
                      ],
                      onChanged: (v) => setState(() => _role = v),
                      validator: (v) =>
                          v == null ? 'Selecione uma opção' : null,
                    ),
                    const SizedBox(height: 30),
                    //SALVAR
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _loading ? null : _salvarEdicao,
                        child: _loading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text(
                                'SALVAR ALTERAÇÕES',
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

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ijob/Core/Entities/address.dart';
import 'package:ijob/Core/services/geralUse/categorList.dart';
import 'package:ijob/Core/Entities/profileUser.dart';
import 'package:ijob/Core/services/geralUse/profileUserList.dart';
import 'package:ijob/Core/Entities/servicer.dart';
import 'package:ijob/Core/services/geralUse/servicerList.dart';
import 'package:ijob/Core/Entities/userRole.dart';
import 'package:ijob/Core/data/addressData.dart';
import 'package:ijob/Core/services/auth/authServices.dart';
import 'package:ijob/Core/utils/locationUtil.dart';
import 'package:ijob/Core/utils/routes.dart';
import 'package:provider/provider.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class EditarPerfilPage extends StatefulWidget {
  const EditarPerfilPage({super.key});

  @override
  State<EditarPerfilPage> createState() => _EditarPerfilPageState();
}

class _EditarPerfilPageState extends State<EditarPerfilPage> {
  final _formKey = GlobalKey<FormState>();

  final _nomeController = TextEditingController();
  final _cpfController = TextEditingController();
  final _ruaController = TextEditingController();
  final _numeroController = TextEditingController();
  final _bairroController = TextEditingController();
  final _cidadeController = TextEditingController();
  final _celularController = TextEditingController();
  String? _categor;
  String? _categorSecond;
  List<String> _selectedCategor = [];

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

  final List<Map<String, String>> _paises = paises;

  final Map<String, List<String>> _estadoPorPais = estadoPorPais;

  String _nameFormatter(String string) {
    return string.substring(0, 1).toUpperCase() +
        string.substring(1).toLowerCase();
  }

  Future<void> _salvarEdicao() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    final role = Provider.of<Userrole>(context, listen: false);
    final user = Provider.of<AuthService>(context, listen: false).usuario;
    if (user == null) return;

    final cpfLimpo = _cpfController.text.replaceAll(RegExp(r'\D'), '');
    final celularLimpo = _celularController.text.replaceAll(RegExp(r'\D'), '');

    try {
      LatLng location = await Locationutil.getLatLngFromAdress(
        _ruaController.text,
        _numeroController.text,
        _bairroController.text,
        _cidadeController.text,
        _estadoSelecionado!,
        _paisSelecionado!,
      );

      Address endereco = Address(
        _ruaController.text,
        _numeroController.text,
        _bairroController.text,
        _cidadeController.text,
        _estadoSelecionado!,
        _paisSelecionado!,
        location.latitude,
        location.longitude,
      );

      if (role.isUsu) {
        //cliente
        final old = Provider.of<Profileuserlist>(
          context,
          listen: false,
        ).profile;

        final usuario = Profileuser(
          id: old.id,
          email: user.email,
          nome: _nameFormatter(_nomeController.text),
          cpf: cpfLimpo,
          celular: celularLimpo,
          genero: _genero!,
          endereco: endereco,
          url: old.url,
          role: old.role,
        );
        await Provider.of<Profileuserlist>(
          context,
          listen: false,
        ).updateProfile(usuario);
        setState(() => _loading = false);
      } else if (role.isServicer) {
        //prestador
        final serv = Provider.of<Servicerlist>(
          context,
          listen: false,
        ).servicerUser;

        _selectedCategor.clear();
        _selectedCategor.add(_categor!);
        _selectedCategor.add(_categorSecond!);

        final servicer = Servicer(
          id: serv.id,
          email: user.email,
          nome: _nameFormatter(_nomeController.text),
          category: _selectedCategor,
          cpf: cpfLimpo,
          endereco: endereco,
          celular: celularLimpo,
          role: serv.role,
          url: serv.url,
          rating: serv.rating,
        );
        await Provider.of<Servicerlist>(
          context,
          listen: false,
        ).updateServicer(servicer);
        setState(() => _loading = false);
      } else {
        setState(() => _loading = false);
        return;
      }

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

    final role = Provider.of<Userrole>(context, listen: false);

    setState(() => _loading = true);

    try {
      await user.delete();
      if (role.isUsu) {
        final profiler = Provider.of<Profileuserlist>(
          context,
          listen: false,
        ).profile;
        await Provider.of<Profileuserlist>(
          context,
          listen: false,
        ).deactivateUser(profiler);
      } else {
        final servicer = Provider.of<Servicerlist>(
          context,
          listen: false,
        ).servicerUser;
        await Provider.of<Servicerlist>(
          context,
          listen: false,
        ).deactivateServicer(servicer);
      }
      await Provider.of<AuthService>(context, listen: false).logout();

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
  void initState() {
    super.initState();

    _preencherDados();
  }

  void _preencherDados() {
    final role = Provider.of<Userrole>(context, listen: false);

    if (role.isUsu) {
      final profile = Provider.of<Profileuserlist>(
        context,
        listen: false,
      ).profile;

      _nomeController.text = profile.nome!;
      _cpfController.text = profile.cpf!;
      _celularController.text = profile.celular!;
      _ruaController.text = profile.endereco!.route;
      _numeroController.text = profile.endereco!.number;
      _bairroController.text = profile.endereco!.neighborhood;
      _cidadeController.text = profile.endereco!.locality;

      _genero = profile.genero;
      _paisSelecionado = profile.endereco!.country;
      _estadoSelecionado = profile.endereco!.state;
    } else if (role.isServicer) {
      final servicer = Provider.of<Servicerlist>(
        context,
        listen: false,
      ).servicerUser;

      _nomeController.text = servicer.nome!;
      _cpfController.text = servicer.cpf!;
      _celularController.text = servicer.celular!;
      _ruaController.text = servicer.endereco!.route;
      _numeroController.text = servicer.endereco!.number;
      _bairroController.text = servicer.endereco!.neighborhood;
      _cidadeController.text = servicer.endereco!.locality;

      _paisSelecionado = servicer.endereco!.country;
      _estadoSelecionado = servicer.endereco!.state;

      if (servicer.category!.isNotEmpty) {
        _categor = servicer.category![0];
        _selectedCategor.add(_categor!);
      }
      if (servicer.category!.length > 1) {
        _categorSecond = servicer.category![1];
        _selectedCategor.add(_categorSecond!);
      }
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
    final role = Provider.of<Userrole>(context, listen: false);
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
                initialValue: _paisSelecionado,
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
                initialValue: _estadoSelecionado,
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
                validator: (v) => v!.trim().isEmpty ? 'Obrigatório' : null,
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
              if (role.isUsu)
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

              const SizedBox(height: 16),
              if (role.isServicer)
                //CATEGOR
                DropdownButtonFormField<String>(
                  initialValue: _categor,
                  decoration: const InputDecoration(
                    labelText: 'Categorias Prestadas',
                    border: OutlineInputBorder(),
                  ),
                  items: Provider.of<Categorlist>(context, listen: false)
                      .categories
                      .map(
                        (cat) => DropdownMenuItem(
                          value: cat.id,
                          child: Text(cat.name!),
                        ),
                      )
                      .toList(),
                  onChanged: (v) => setState(() {
                    _categor = v;
                    if (v != null) {
                      _selectedCategor.add(v);
                    }
                  }),
                  validator: (v) => v == null ? 'Selecione uma opção' : null,
                ),
              const SizedBox(height: 16),
              if (role.isServicer && _selectedCategor.length > 0)
                //CATEGOR
                DropdownButtonFormField<String>(
                  initialValue: _categorSecond,
                  decoration: const InputDecoration(
                    labelText: 'Categorias Prestadas',
                    border: OutlineInputBorder(),
                  ),
                  items: Provider.of<Categorlist>(context, listen: false)
                      .categories
                      .map(
                        (cat) => DropdownMenuItem(
                          value: cat.id,
                          child: Text(cat.name!),
                        ),
                      )
                      .toList(),
                  onChanged: (v) => setState(() {
                    _categorSecond = v;
                  }),
                  validator: (v) => v == null ? 'Selecione uma opção' : null,
                ),
              //SALVAR
              SizedBox(height: 15),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _loading ? null : _salvarEdicao,
                  child: _loading
                      ? const CircularProgressIndicator(color: Colors.white)
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

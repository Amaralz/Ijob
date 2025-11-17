import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ijob/Core/Entities/address.dart';
import 'package:ijob/Core/services/geralUse/categorList.dart';
import 'package:ijob/Core/Entities/profileUser.dart';
import 'package:ijob/Core/services/geralUse/profileUserList.dart';
import 'package:ijob/Core/Entities/servicer.dart';
import 'package:ijob/Core/services/geralUse/servicerList.dart';
import 'package:ijob/Core/data/addressData.dart';
import 'package:ijob/Core/services/auth/authServices.dart';
import 'package:ijob/Core/utils/locationUtil.dart';
import 'package:ijob/Core/utils/routes.dart';
import 'package:location/location.dart';
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
  final _cidadeController = TextEditingController();
  final _bairroController = TextEditingController();
  final _celularcontroller = TextEditingController();
  final _ruaController = TextEditingController();
  final _numeroController = TextEditingController();
  String? _genero;
  String? _paisSelecionado;
  String? _estadoSelecionado;
  String? _role;
  String? _categor;
  String? _categorSecond;
  List<String> _selectedCategor = [];
  String _standardUrl =
      "https://thumbs.dreamstime.com/b/default-profile-picture-avatar-photo-placeholder-vector-illustration-default-profile-picture-avatar-photo-placeholder-vector-189495158.jpg";

  final _paises = paises;
  final _estadoPorPais = estadoPorPais;

  bool _loading = false;
  bool _locLoading = false;

  final cpfFormatter = MaskTextInputFormatter(
    mask: '###.###.###.##',
    filter: {"#": RegExp(r'[0-9]')},
  );

  final celularFormatter = MaskTextInputFormatter(
    mask: '(##) #####-####',
    filter: {"#": RegExp(r'[0-9]')},
  );

  String _nameFormatter(String string) {
    return string.substring(0, 1).toUpperCase() +
        string.substring(1).toLowerCase();
  }

  Future<void> _salvarPerfil() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    final user = Provider.of<AuthService>(context, listen: false).usuario;
    if (user == null) return;
    int decider = int.parse(_role!);

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

      if (decider == 0) {
        //Usuario
        final usuario = Profileuser(
          id: user.uid,
          email: user.email,
          nome: _nameFormatter(_nomeController.text),
          cpf: _cpfController.text.replaceAll(RegExp(r'\D'), ''),
          celular: _celularcontroller.text.replaceAll(RegExp(r'\D'), ''),
          genero: _genero!,
          endereco: endereco,
          role: decider,
        );

        await Provider.of<Profileuserlist>(
          context,
          listen: false,
        ).createUserProfile(user, usuario);
      } else if (decider == 1) {
        _selectedCategor.clear();
        _selectedCategor.add(_categor!);
        _selectedCategor.add(_categorSecond!);
        //prestador
        final servicer = Servicer(
          id: user.uid,
          email: user.email,
          nome: _nameFormatter(_nomeController.text),
          category: _selectedCategor,
          cpf: _cpfController.text.replaceAll(RegExp(r'\D'), ''),
          endereco: endereco,
          celular: _celularcontroller.text.replaceAll(RegExp(r'\D'), ''),
          role: decider,
          url: _standardUrl,
          rating: 5.0,
        );
        await Provider.of<Servicerlist>(
          context,
          listen: false,
        ).createServicer(user, servicer);
      } else {
        setState(() => _loading = false);
        return;
      }
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          Routes.AUTHCHECK,
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _loading = false;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Falha ao salvar dados")));
      }
    }
  }

  @override
  void initState() {
    Provider.of<Categorlist>(context, listen: false).loadCategors();
    super.initState();
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

              //nome
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(
                  labelText: 'Nome Completo',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v!.trim().isEmpty ? 'Obrigatorio' : null,
              ),
              const SizedBox(height: 16),

              //cpf
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

              _locLoading
                  ? CircularProgressIndicator()
                  : TextButton.icon(
                      onPressed: () async {
                        setState(() {
                          _locLoading = true;
                        });
                        try {
                          final position = await Location().getLocation();

                          if (position.latitude == null ||
                              position.longitude == null) {
                            throw 'Erro ao tentar conseguir posição';
                          }

                          final address = await Locationutil()
                              .getAdressFromLatLng(
                                LatLng(position.latitude!, position.longitude!),
                              );

                          if (address == null) {
                            throw 'Erro ao tentar conseguir endereço';
                          }
                          String? paisCod;
                          try {
                            final paisMap = _paises.firstWhere(
                              (pais) => pais['nome'] == address.country,
                            );
                            paisCod = paisMap['codigo'];
                          } catch (erro) {
                            throw 'País não suportado';
                          }

                          setState(() {
                            _ruaController.text = address.route;
                            _numeroController.text = address.number;
                            _bairroController.text = address.neighborhood;
                            _cidadeController.text = address.locality;
                            _paisSelecionado = paisCod;
                            _estadoSelecionado = address.state;
                          });
                        } catch (erro) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Erro: ${erro.toString()} '),
                            ),
                          );
                        } finally {
                          if (mounted) {
                            setState(() {
                              _locLoading = false;
                            });
                          }
                        }
                      },
                      label: Text("Selecionar localização atual"),
                      icon: Icon(Icons.add_location),
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

              //Cidade
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

              //CELULAR
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

              //GENERO
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

              //ROLE
              DropdownButtonFormField<String>(
                initialValue: _role,
                decoration: const InputDecoration(
                  labelText: 'tipo de conta',
                  border: OutlineInputBorder(),
                ),
                items: [
                  DropdownMenuItem(value: '0', child: Text('Cliente')),
                  DropdownMenuItem(value: '1', child: Text('Prestador')),
                ],
                onChanged: (v) => setState(() => _role = v),
                validator: (v) => v == null ? 'Selecione uma opção' : null,
              ),
              const SizedBox(height: 16),
              if (_role == "1")
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
              if (_role == "1" && _selectedCategor.length > 0)
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
              const SizedBox(height: 16),

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

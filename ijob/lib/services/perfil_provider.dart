// lib/providers/perfil_provider.dart
import 'package:flutter/material.dart';
import 'package:ijob/services/database_helper.dart';
import 'package:ijob/services/auth_services.dart';
import 'package:provider/provider.dart';

class PerfilProvider extends ChangeNotifier {
  Map<String, dynamic>? _perfil;
  bool _isLoading = true;

  Map<String, dynamic>? get perfil => _perfil;
  bool get isLoading => _isLoading;

  Future<void> carregarPerfil(BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    final user = Provider.of<AuthService>(context, listen: false).usuario;
    if (user == null) {
      _perfil = null;
      _isLoading = false;
      notifyListeners();
      return;
    }

    final perfilLocal = await DatabaseHelper().buscarPerfil(user.uid);
    if (perfilLocal != null) {
      _perfil = perfilLocal;
    } else {
      final perfilFirestore = await DatabaseHelper().getPerfil(user.uid);
      _perfil = perfilFirestore;
      if (perfilFirestore != null) {
        await DatabaseHelper().inserirPerfil({
          'id': user.uid,
          ...perfilFirestore,
        });
      }
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> atualizarPerfil(Map<String, dynamic> novoPerfil) async {
    _perfil = novoPerfil;
    notifyListeners(); // ATUALIZA TODOS OS CONSUMERS
  }
}

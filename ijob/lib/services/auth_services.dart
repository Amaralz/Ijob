import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthException implements Exception {
  final String message;
  AuthException(this.message);
}

class AuthService extends ChangeNotifier {
  FirebaseAuth _auth = FirebaseAuth.instance;
  User? usuario;
  bool isLoading = true;
  bool _pendingDelete = false;
  bool get pendingDelete => _pendingDelete;

  void setPendingDelete(bool value) {
    _pendingDelete = value;
    notifyListeners();
  }

  AuthService() {
    _authCheck();
  }

  void _authCheck() {
    _auth.authStateChanges().listen((User? user) {
      usuario = user;
      isLoading = false;
      print('authStateChanges: usuário = ${user?.email}, isLoading = false');
      Future.microtask(() => notifyListeners());
    });
  }

  Future<void> login(String email, String password) async {
    try {
      setStateLoading(true);
      print('Tentando login com $email');
      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .timeout(const Duration(seconds: 10));
      print('Login bem sucedido');
    } on FirebaseAuthException catch (e) {
      setStateLoading(false);
      String message;
      switch (e.code) {
        case 'user-not-found':
          message = 'Usuário não encontrado. Cadastre-se';
          break;
        case 'wrong-password':
          message = 'Senha incorreta. Tente novamente';
          break;
        case 'invalid-email':
          message = 'email inválido.';
          break;
        default:
          message = 'Erro ao fazer login: ${e.message}';
      }
      throw AuthException(message);
    } catch (e) {
      print('Erro no login: $e');
      setStateLoading(false);
      throw AuthException('Erro inesperado ao fazer login: $e');
    }
  }

  Future<void> registrar(String email, String password) async {
    try {
      setStateLoading(true);
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .timeout(const Duration(seconds: 10));
    } on FirebaseAuthException catch (e) {
      setStateLoading(false);
      String message;
      switch (e.code) {
        case 'email-already-in-use':
          message = 'Este email já está cadastrado.';
          break;
        case 'invalid-email':
          message = 'Email inválido.';
          break;
        case 'weak-password':
          message = 'A senha é muito fraca.';
          break;
        default:
          message = 'Erro ao cadastrar: ${e.message}';
      }
      throw AuthException(message);
    } catch (e) {
      setStateLoading(false);
      throw AuthException('Erro inesperado ao cadastrar: $e');
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    print('Logout realizado');
  }

  void setStateLoading(bool value) {
    if (isLoading != value) {
      isLoading = value;
      notifyListeners();
    }
  }
}

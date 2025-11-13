/*import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ijob/Core/Entities/address.dart';
import 'package:ijob/Core/Entities/profileUser.dart';
import 'package:ijob/Core/Entities/servicer.dart';

enum UserMode { Servicer, User, Other }

abstract class Personuser {
  final String id;
  final String email;
  final String nome;
  final String celular;
  final String cpf;
  final String url;
  final UserMode role;

  Personuser({
    required this.id,
    required this.email,
    required this.nome,
    required this.celular,
    required this.cpf,
    required this.url,
    required this.role,
  });

  //recebimento
  factory Personuser.fromSnapshot(DocumentSnapshot docu) {
    final String docId = docu.id;
    final data = docu.data() as Map<String, dynamic>?;

    if (data == null) {
      throw Exception("Documento não encontrado ou vazio");
    }

    UserMode uRole;
    switch (data['role']) {
      case 'User':
        uRole = UserMode.User;
        break;
      case 'Servicer':
        uRole = UserMode.Servicer;
        break;
      default:
        uRole = UserMode.Other;
    }

    if (uRole == UserMode.User) {
      return Profileuser(
        id: docId,
        email: data['email'],
        nome: data['nome'],
        cpf: data['cpf'],
        celular: data['celular'],
        genero: data['genero'],
        url: data['url'],
        endereco: Address.fromMap(data['endereco']),
      );
    } else if (uRole == UserMode.Servicer) {
      return Servicer(
        id: docId,
        nome: data["nome"],
        category: List<String>.from(data["category"]),
        cpf: data["cpf"],
        endereco: Address.fromMap(data["endereco"]),
        email: data["email"],
        url: data["url"],
        rating: (data['rating'] as num?)?.toDouble() ?? 5.0,
        celular: data["celular"],
      );
    } else {
      throw Exception("Usuário com role desconhecido");
    }
  }

  Map<String, dynamic> toJson();
}
*/

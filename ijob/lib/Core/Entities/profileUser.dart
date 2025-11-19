import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ijob/Core/Entities/address.dart';

class Profileuser {
  final String? id;
  final String? email;
  final String? nome;
  final String? cpf;
  final String? celular;
  final String? genero;
  final Address? endereco;
  final bool active;
  final String? url;
  final int role;

  const Profileuser({
    required this.id,
    required this.email,
    required this.nome,
    required this.cpf,
    required this.celular,
    required this.genero,
    required this.endereco,
    required this.url,
    this.active = true,
    required this.role,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'nome': nome,
      'cpf': cpf,
      'celular': celular,
      'genero': genero,
      'endereco': endereco?.toJson(),
      'url': url,
      'active': active,
      'role': role,
    };
  }

  factory Profileuser.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> docu,
  ) {
    final data = docu.data();
    return Profileuser(
      id: docu.id,
      email: data!['email'],
      nome: data['nome'],
      cpf: data['cpf'],
      celular: data['celular'],
      genero: data['genero'],
      endereco: Address.fromMap(data['endereco']),
      url: data['url'],
      active: data['active'],
      role: data['role'],
    );
  }
  /*
  String? get id {
    return _id;
  }

  String? get cpf {
    return _cpf;
  }

  String? get celular {
    return _celular;
  }

  int? get role {
    return _role;
  }

  String? get nome {
    return _nome;
  }
  */
}

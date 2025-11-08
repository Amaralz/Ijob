import 'package:ijob/Entities/address.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Servicer {
  final String? id;
  final String? nome;
  final String? url;
  final List<String>? category;
  final String? email;
  final String? cpf;
  final String? celular;
  final Address? endereco;
  final double rating;
  final int role;

  Servicer({
    required this.id,
    required this.nome,
    required this.category,
    required this.cpf,
    required this.endereco,
    this.celular,
    this.email,
    this.url =
        "https://thumbs.dreamstime.com/b/eletricista-nos-macac%C3%B5es-cercados-com-fontes-e-ferramentas-da-eletricidade-103748791.jpg",
    this.rating = 5.0,
    this.role = 1,
  });

  //enviar
  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'category': category,
      'cpf': cpf,
      'email': email,
      'url': url,
      'endereco': endereco?.toJson(),
      'rating': rating,
      'celular': celular,
      'role': role,
    };
  }

  //receber
  factory Servicer.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> docu) {
    final data = docu.data();
    return Servicer(
      id: docu.id,
      nome: data!["nome"],
      category: List<String>.from(data["category"]),
      cpf: data["cpf"],
      endereco: Address.fromMap(data["endereco"]),
      email: data["email"],
      url: data["url"],
      rating: (data['rating'] as num?)?.toDouble() ?? 5.0,
      celular: data["celular"],
      role: data["role"],
    );
  }
}

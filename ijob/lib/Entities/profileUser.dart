//import 'package:ijob/Entities/address.dart';

class Profileuser {
  String? id;
  String? nome;
  String? cpf;
  String? bairro;
  String? celular;
  String? genero;

  Profileuser({
    required this.id,
    required this.nome,
    required this.cpf,
    required this.celular,
    required this.genero,
    this.bairro,
  });
}

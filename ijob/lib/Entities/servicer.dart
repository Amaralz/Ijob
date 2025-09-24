import 'package:ijob/Entities/categor.dart';

class Servicer {
  final String? id;
  final String? nome;
  final String? url;
  final Categor? category;

  Servicer({
    required this.id,
    required this.nome,
    required this.category,
    this.url,
  });
}

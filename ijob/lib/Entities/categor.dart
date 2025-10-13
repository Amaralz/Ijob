import 'package:flutter/widgets.dart';

class Categor extends ChangeNotifier {
  final String? id;
  final String? name;
  final IconData? icon;

  Categor({required this.id, required this.name, this.icon});
}

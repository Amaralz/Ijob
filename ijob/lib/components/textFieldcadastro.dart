import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class Textfieldcadastro extends StatelessWidget {
  final TextEditingController? controller;
  final List<MaskTextInputFormatter>? mask;
  final TextInputType? type;
  final String? label;

  const Textfieldcadastro({
    @required this.controller,
    this.mask,
    this.type,
    @required this.label,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return TextField(
      controller: controller,
      inputFormatters: mask,
      keyboardType: type,
      decoration: InputDecoration(labelText: label),
    );
  }
}

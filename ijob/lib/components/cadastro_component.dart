import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class CadastroComponent extends StatelessWidget {
  final cpfFormatter = MaskTextInputFormatter(mask: '###.###.###-##');
  final celularFormatter = MaskTextInputFormatter(mask: '(##) #####-####');

  final TextEditingController cpfController = TextEditingController();
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController bairroController = TextEditingController();
  final TextEditingController generoController = TextEditingController();
  final TextEditingController celularController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cadastro')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: cpfController,
              inputFormatters: [cpfFormatter],
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'CPF'),
            ),
            TextField(
              controller: nomeController,
              decoration: InputDecoration(labelText: 'Nome'),
            ),
            TextField(
              controller: bairroController,
              decoration: InputDecoration(labelText: 'Bairro'),
            ),
            TextField(
              controller: generoController,
              decoration: InputDecoration(labelText: 'Gênero'),
            ),
            TextField(
              controller: celularController,
              inputFormatters: [celularFormatter],
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(labelText: 'Celular'),
            ),
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // lógica de cadastro
              },
              child: Text('Cadastrar'),
            ),
          ],
        ),
      ),
    );
  }
}

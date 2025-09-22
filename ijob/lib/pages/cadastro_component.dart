import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class CadastroComponent extends StatelessWidget {
  final cpfFormatter = MaskTextInputFormatter(mask: '###.###.###-##');
  final celularFormatter = MaskTextInputFormatter(mask: '(##) #####-####');

  final TextEditingController servicoController = TextEditingController();
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
              controller: servicoController,
              decoration: InputDecoration(labelText: 'Serviço'),
            ),
            SizedBox(height: 50),
            TextField(
              controller: cpfController,
              inputFormatters: [cpfFormatter],
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'CPF'),
            ),
            SizedBox(height: 50),
            TextField(
              controller: nomeController,
              decoration: InputDecoration(labelText: 'Nome'),
            ),
            SizedBox(height: 50),
            TextField(
              controller: bairroController,
              decoration: InputDecoration(labelText: 'Bairro'),
            ),
            SizedBox(height: 50),
            TextField(
              controller: generoController,
              decoration: InputDecoration(labelText: 'Gênero'),
            ),
            SizedBox(height: 50),
            TextField(
              controller: celularController,
              inputFormatters: [celularFormatter],
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(labelText: 'Celular'),
            ),
            SizedBox(height: 50),
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

import 'package:flutter/material.dart';
import 'package:ijob/Components/textFieldcadastro.dart';
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
      appBar: AppBar(title: const Text('Cadastro')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: ListView(
          children: <Widget>[
            Textfieldcadastro(controller: servicoController, label: "Serviço"),
            SizedBox(height: 50),
            Textfieldcadastro(
              controller: cpfController,
              mask: [cpfFormatter],
              type: TextInputType.number,
              label: "CPF",
            ),
            SizedBox(height: 50),
            Textfieldcadastro(controller: nomeController, label: "Nome"),
            SizedBox(height: 50),
            Textfieldcadastro(controller: bairroController, label: "Bairro"),
            SizedBox(height: 50),
            Textfieldcadastro(controller: generoController, label: "Gênero"),
            SizedBox(height: 50),
            Textfieldcadastro(
              controller: celularController,
              label: "Celular",
              mask: [celularFormatter],
              type: TextInputType.phone,
            ),
            SizedBox(height: 50),
            Textfieldcadastro(
              controller: emailController,
              label: "Email",
              type: TextInputType.emailAddress,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // lógica de cadastro
              },
              child: const Text('Cadastrar'),
            ),
          ],
        ),
      ),
    );
  }
}

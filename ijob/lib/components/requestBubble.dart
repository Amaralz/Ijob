import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ijob/Components/toastMessage.dart';
import 'package:ijob/Core/Entities/categorList.dart';
import 'package:ijob/Core/Entities/profileUserList.dart';
import 'package:ijob/Core/Entities/requestMessage.dart';
import 'package:ijob/Core/services/chat/requestMessageServices.dart';
import 'package:provider/provider.dart';
import 'package:date_time_picker/date_time_picker.dart';

class Requestbubble extends StatefulWidget {
  final bool isServicer;
  final bool owner;
  final List<String> categor;
  final String servicerId;
  final String chatId;

  Requestbubble({
    required this.categor,
    required this.isServicer,
    required this.owner,
    required this.servicerId,
    required this.chatId,
  });

  @override
  State<Requestbubble> createState() => _RequestbubbleState();
}

class _RequestbubbleState extends State<Requestbubble> {
  final _key = GlobalKey<FormState>();

  final CurrencyTextInputFormatter _format =
      CurrencyTextInputFormatter.currency(
        symbol: 'R\$',
        locale: 'br',
        decimalDigits: 2,
      );

  DateTime _selectedDate = DateTime.now();
  String? _selectedCategor;
  int _value = 0;

  _pressed() async {
    final isValid = _key.currentState?.validate() ?? false;
    if (!isValid) {
      return;
    }

    if (_value == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Insira um valor maior que R\$ 0,00'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final userId = Provider.of<Profileuserlist>(
      context,
      listen: false,
    ).profile.id;

    final msg = Requestmessage(
      categor: _selectedCategor!,
      createdAt: DateTime.now(),
      definedAt: _selectedDate,
      id: '',
      servicerId: widget.servicerId,
      state: false,
      userId: userId!,
      value: _value * 100,
    );

    await Provider.of<Requestmessageservices>(
      context,
      listen: false,
    ).newMessage(widget.chatId, msg);

    Navigator.of(context).pop();

    Toastmessage(
      title: "Requisição criada!",
      subtitle: "Sua requisição foi criada com sucesso!",
      primaryColor: Theme.of(context).secondaryHeaderColor,
      icon: Icon(Icons.celebration),
    ).toast(context);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Form(
      key: _key,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                DropdownButtonFormField<String?>(
                  initialValue: _selectedCategor,
                  decoration: const InputDecoration(
                    labelText: 'Escolha a categoria do pedido',
                    border: OutlineInputBorder(),
                  ),
                  items: widget.categor
                      .map((catId) {
                        return Provider.of<Categorlist>(
                          context,
                          listen: false,
                        ).categoryById(catId);
                      })
                      .toList()
                      .map(
                        (cat) => DropdownMenuItem(
                          value: cat!.id,
                          child: Text(cat.name!),
                        ),
                      )
                      .toList(),
                  onChanged: (v) => setState(() {
                    _selectedCategor = v;
                  }),
                  validator: (v) => v == null ? 'Selecione uma opção' : null,
                ),
                SizedBox(height: 10),
                DateTimePicker(
                  type: DateTimePickerType.dateTimeSeparate,
                  dateMask: 'dd/MM/yyyy',
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(DateTime.now().year + 2),
                  icon: Icon(Icons.event_note_outlined),
                  dateLabelText: "Data",
                  timeLabelText: "Hora",
                  onChanged: (value) => setState(() {
                    _selectedDate = DateTime.parse(value);
                  }),
                  validator: (value) {
                    if (value == null) {
                      return 'Selecionar data e hora';
                    } else if (DateTime.tryParse(value) == null) {
                      return 'erro ao tentar dar parse';
                    } else {
                      return null;
                    }
                  },
                  onSaved: (value) => _selectedDate = DateTime.parse(value!),
                ),
                SizedBox(height: 10),
                Container(
                  width: double.maxFinite,
                  child: TextFormField(
                    inputFormatters: <TextInputFormatter>[_format],
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(label: Text("Insira o valor")),
                    onChanged: (value) {
                      setState(() {
                        _value = _format.getUnformattedValue().toInt();
                      });
                    },
                    validator: (value) {
                      if (_value == 0) {
                        return 'Insira um valor';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: double.maxFinite,
                  child: ElevatedButton(
                    onPressed: _pressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).secondaryHeaderColor,
                    ),
                    child: Text(
                      "Enviar pedido",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

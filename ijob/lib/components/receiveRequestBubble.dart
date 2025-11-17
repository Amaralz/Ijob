import 'package:flutter/material.dart';
import 'package:ijob/Components/toastMessage.dart';
import 'package:ijob/Core/Entities/categor.dart';
import 'package:ijob/Core/services/geralUse/categorList.dart';
import 'package:ijob/Core/Entities/requestMessage.dart';
import 'package:ijob/Core/Entities/userRole.dart';
import 'package:ijob/Core/services/chat/requestMessageServices.dart';
import 'package:ijob/Core/services/order/orderServicer.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:ijob/Core/Entities/orderService.dart';

class Receiverequestbubble extends StatefulWidget {
  final Requestmessage request;
  final String chatId;

  Receiverequestbubble({required this.request, required this.chatId});

  @override
  State<Receiverequestbubble> createState() => _ReceiverequestbubbleState();
}

class _ReceiverequestbubbleState extends State<Receiverequestbubble> {
  bool _isLoading = false;

  _unboderedContainer(String title) {
    return Container(
      alignment: Alignment.center,
      width: double.maxFinite,
      decoration: BoxDecoration(
        border: BoxBorder.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(
          title,
          style: TextStyle(color: Colors.blueGrey, fontSize: 20),
        ),
      ),
    );
  }

  _borderContainer(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        border: BoxBorder.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          spacing: 10,
          mainAxisAlignment: MainAxisAlignment.center,
          children: children,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final role = Provider.of<Userrole>(context, listen: false);

    Categor _categor = Provider.of<Categorlist>(
      context,
    ).categoryById(widget.request.categor)!;

    final currencyFormat = NumberFormat.currency(
      locale: 'pt_BR',
      symbol: 'R\$',
    );

    // TODO: implement build
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        spacing: 20,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //categoria
          _borderContainer([
            Text(
              "Categoria selecionada:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              "${_categor.name}",
              style: TextStyle(
                fontSize: 20,
                color: Theme.of(context).secondaryHeaderColor,
              ),
            ),
          ]),

          //data/hora
          _borderContainer([
            Icon(Icons.event),
            Text(DateFormat.yMd('pt_BR').format(widget.request.definedAt)),
            Text(DateFormat.Hm().format(widget.request.definedAt)),
          ]),

          //valor
          Container(
            height: 100,
            width: 500,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: BoxBorder.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Text(
              currencyFormat.format(widget.request.value / 100),
              style: TextStyle(
                fontSize: 30,
                color: Theme.of(context).secondaryHeaderColor,
              ),
            ),
          ),

          //botões
          role.isServicer
              ? !widget.request.state
                    ? Flexible(
                        child: Row(
                          children: [
                            Flexible(
                              fit: FlexFit.tight,
                              child: Container(
                                height: 80,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Provider.of<Requestmessageservices>(
                                      context,
                                      listen: false,
                                    ).messageAccepted(
                                      widget.request,
                                      false,
                                      widget.chatId,
                                    );
                                    Navigator.of(context).pop();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadiusGeometry.circular(10),
                                    ),
                                    backgroundColor: Colors.blueGrey,
                                  ),
                                  child: Text(
                                    "Recusar",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            Flexible(
                              fit: FlexFit.tight,
                              child: Container(
                                height: 80,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    setState(() {
                                      _isLoading = true;
                                    });

                                    await Provider.of<Requestmessageservices>(
                                      context,
                                      listen: false,
                                    ).messageAccepted(
                                      widget.request,
                                      true,
                                      widget.chatId,
                                    );

                                    await Provider.of<Orderservicer>(
                                      context,
                                      listen: false,
                                    ).createOrder(
                                      OrderService(
                                        id: '',
                                        user: widget.request.userId,
                                        servicer: widget.request.servicerId,
                                        categor: widget.request.categor,
                                        value: widget.request.value,
                                        orderedAt: DateTime.now(),
                                        definedAt: widget.request.definedAt,
                                        initiatedIn: widget.chatId,
                                        requestedIn: widget.request.id,
                                        status: 1,
                                      ),
                                    );

                                    setState(() {
                                      _isLoading = false;
                                    });

                                    Navigator.of(context).pop();

                                    Toastmessage(
                                      title: "Requisição aceita",
                                      subtitle:
                                          "Requisição de servico ${_categor.name} foi aceita",
                                      primaryColor: Theme.of(
                                        context,
                                      ).secondaryHeaderColor,
                                      icon: Icon(Icons.check),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadiusGeometry.circular(10),
                                    ),
                                    backgroundColor: Theme.of(
                                      context,
                                    ).secondaryHeaderColor,
                                  ),
                                  child: _isLoading
                                      ? CircularProgressIndicator()
                                      : Text(
                                          "Aceitar",
                                          style: TextStyle(color: Colors.black),
                                        ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : _unboderedContainer("Pedido aceito")
              : widget.request.state
              ? _unboderedContainer("Pedido aceito")
              : _unboderedContainer("Aguardando confirmação"),
        ],
      ),
    );
  }
}

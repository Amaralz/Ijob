import 'package:flutter/material.dart';
import 'package:ijob/Core/Entities/categor.dart';
import 'package:ijob/Core/Entities/categorList.dart';
import 'package:ijob/Core/Entities/orderService.dart';
import 'package:ijob/Core/Entities/profileUser.dart';
import 'package:ijob/Core/Entities/servicer.dart';
import 'package:ijob/Core/services/chat/requestMessageServices.dart';
import 'package:ijob/Core/services/order/orderServicer.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Orderlisttiledialog extends StatefulWidget {
  final OrderService order;
  final Servicer servicer;
  final Profileuser user;
  final bool isServicer;

  Orderlisttiledialog({
    required this.order,
    required this.servicer,
    required this.user,
    required this.isServicer,
  });

  @override
  State<Orderlisttiledialog> createState() => _OrderlisttiledialogState();
}

class _OrderlisttiledialogState extends State<Orderlisttiledialog> {
  _confirmFinalize(BuildContext context) {
    Provider.of<Requestmessageservices>(
      context,
      listen: false,
    ).deleteRequest(widget.order.initiatedIn, widget.order.requestedIn);

    OrderService updated = OrderService(
      categor: widget.order.categor,
      definedAt: widget.order.definedAt,
      id: widget.order.id,
      initiatedIn: widget.order.initiatedIn,
      orderedAt: widget.order.orderedAt,
      servicer: widget.order.servicer,
      user: widget.order.user,
      value: widget.order.value,
      finishedAt: widget.order.finishedAt,
      requestedIn: "Consumed",
      status: 3,
    );

    Provider.of<Orderservicer>(context, listen: false).updateOrder(updated);
    Navigator.of(context).pop();
  }

  _finalize(BuildContext context) {
    OrderService updated = OrderService(
      categor: widget.order.categor,
      definedAt: widget.order.definedAt,
      id: widget.order.id,
      initiatedIn: widget.order.initiatedIn,
      orderedAt: widget.order.orderedAt,
      servicer: widget.order.servicer,
      user: widget.order.user,
      value: widget.order.value,
      finishedAt: DateTime.now(),
      requestedIn: widget.order.requestedIn,
      status: 2,
    );

    Provider.of<Orderservicer>(context, listen: false).updateOrder(updated);
    Navigator.of(context).pop();
  }

  _cancel(BuildContext context) {
    Provider.of<Requestmessageservices>(
      context,
      listen: false,
    ).deleteRequest(widget.order.initiatedIn, widget.order.requestedIn);

    OrderService updated = OrderService(
      categor: widget.order.categor,
      definedAt: widget.order.definedAt,
      id: widget.order.id,
      initiatedIn: widget.order.initiatedIn,
      orderedAt: widget.order.orderedAt,
      servicer: widget.order.servicer,
      user: widget.order.user,
      value: widget.order.value,
      finishedAt: null,
      requestedIn: "Consumed",
      status: 0,
    );

    Provider.of<Orderservicer>(context, listen: false).updateOrder(updated);
    Navigator.of(context).pop();
  }

  _confirmationButtons(BuildContext context) {
    if (widget.order.status == 1) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 20,
          children: [
            Flexible(
              fit: FlexFit.tight,
              child: ElevatedButton(
                onPressed: () => _cancel(context),
                child: Padding(
                  padding: const EdgeInsets.all(3),
                  child: Text("Cancelar"),
                ),
              ),
            ),
            if (widget.isServicer)
              Flexible(
                fit: FlexFit.tight,
                child: ElevatedButton(
                  onPressed: () => _finalize(context),
                  child: Padding(
                    padding: const EdgeInsets.all(3),
                    child: Text("Confirmar"),
                  ),
                ),
              ),
          ],
        ),
      );
    } else if (widget.order.status == 2) {
      if (!widget.isServicer) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 20,
            children: [
              Flexible(
                fit: FlexFit.tight,
                child: ElevatedButton(
                  onPressed: () => _cancel(context),
                  child: Padding(
                    padding: const EdgeInsets.all(3),
                    child: Text("Cancelar"),
                  ),
                ),
              ),
              Flexible(
                fit: FlexFit.tight,
                child: ElevatedButton(
                  onPressed: () => _confirmFinalize(context),
                  child: Padding(
                    padding: const EdgeInsets.all(3),
                    child: Text("Confirmar"),
                  ),
                ),
              ),
            ],
          ),
        );
      } else {
        return Container();
      }
    } else if (widget.order.status == 4) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 20,
          children: [
            Flexible(
              fit: FlexFit.tight,
              child: ElevatedButton(
                onPressed: () => _cancel(context),
                child: Padding(
                  padding: const EdgeInsets.all(3),
                  child: Text("Cancelar"),
                ),
              ),
            ),
            if (widget.isServicer)
              Flexible(
                fit: FlexFit.tight,
                child: ElevatedButton(
                  onPressed: () => _finalize(context),
                  child: Padding(
                    padding: const EdgeInsets.all(3),
                    child: Text("Confirmar"),
                  ),
                ),
              ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(
      locale: 'pt_BR',
      symbol: 'R\$',
    );

    Categor? categor = Provider.of<Categorlist>(
      context,
      listen: false,
    ).categoryById(widget.order.categor);
    // TODO: implement build
    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(15),
          border: BoxBorder.all(color: Theme.of(context).secondaryHeaderColor),
        ),
        height: MediaQuery.of(context).size.height * 0.5,
        width: MediaQuery.of(context).size.width * 0.9,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Serviço de ${categor?.name}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Row(
                spacing: 5,
                children: [
                  Text("Marcado para:"),
                  Text(
                    DateFormat.yMd('pt_BR').format(widget.order.definedAt),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    DateFormat.Hm().format(widget.order.definedAt),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              if (widget.order.finishedAt != null)
                Row(
                  spacing: 5,
                  children: [
                    Text("Finalizado em:"),
                    Text(
                      DateFormat.yMd('pt_BR').format(widget.order.finishedAt!),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      DateFormat.Hm().format(widget.order.finishedAt!),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              Row(
                spacing: 10,
                children: [
                  Text("Valor acordado: "),
                  Text(currencyFormat.format(widget.order.value / 100)),
                ],
              ),
              if (widget.isServicer)
                Text(
                  "Endereço: ${widget.user.endereco!.neighborhood}, ${widget.user.endereco!.route}, ${widget.user.endereco!.number}",
                  overflow: TextOverflow.clip,
                ),
              Spacer(),
              _confirmationButtons(context),
            ],
          ),
        ),
      ),
    );
  }
}

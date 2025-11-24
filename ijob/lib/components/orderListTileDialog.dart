import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ijob/Components/toastMessage.dart';
import 'package:ijob/Core/Entities/categor.dart';
import 'package:ijob/Core/services/geralUse/categorList.dart';
import 'package:ijob/Core/Entities/orderService.dart';
import 'package:ijob/Core/Entities/profileUser.dart';
import 'package:ijob/Core/Entities/servicer.dart';
import 'package:ijob/Core/services/chat/requestMessageServices.dart';
import 'package:ijob/Core/services/order/orderServicer.dart';
import 'package:ijob/Core/utils/routes.dart';
import 'package:ijob/pages/mapPage.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
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
    if (mounted) {
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
      Toastmessage(
        icon: const Icon(Icons.handshake_outlined),
        primaryColor: Theme.of(context).secondaryHeaderColor,
        subtitle: "Pedido confirmado e concluído!",
        title: "Pedido concluído",
      ).toast(context);
      Navigator.of(context).pop();
    } else {
      return;
    }
  }

  _finalize(BuildContext context) {
    if (mounted) {
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
      Toastmessage(
        icon: const Icon(Icons.check),
        primaryColor: Colors.green,
        subtitle:
            "Aguarde a confirmação de ${widget.user.nome} para o pedido ser concluído",
        title: "Pedido finalizado",
      ).toast(context);
      Navigator.of(context).pop();
    } else {
      return;
    }
  }

  _cancel(BuildContext context) {
    if (mounted) {
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
      Toastmessage(
        icon: const Icon(Icons.cancel),
        primaryColor: const Color.fromARGB(255, 47, 61, 68),
        subtitle: "Seu pedido com ${widget.servicer} foi cancelado",
        title: "Pedido cancelado",
      ).toast(context);
      Navigator.of(context).pop();
    } else {
      return;
    }
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
                  child: const Text("Cancelar"),
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
                    child: const Text("Confirmar"),
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
                    child: const Text("Cancelar"),
                  ),
                ),
              ),
              Flexible(
                fit: FlexFit.tight,
                child: ElevatedButton(
                  onPressed: () => _confirmFinalize(context),
                  child: Padding(
                    padding: const EdgeInsets.all(3),
                    child: const Text("Confirmar"),
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
                  child: const Text("Cancelar"),
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
                    child: const Text("Confirmar"),
                  ),
                ),
              ),
          ],
        ),
      );
    } else {
      return Container();
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
              if (!widget.isServicer)
                TextButton(
                  onPressed: () {
                    Navigator.of(
                      context,
                    ).pushNamed(Routes.PRESTADOR, arguments: widget.servicer);
                  },
                  style: TextButton.styleFrom(padding: const EdgeInsets.all(0)),
                  child: Text(
                    "Por: ${widget.servicer.nome}",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              Row(
                spacing: 5,
                children: [
                  const Text("Marcado para:"),
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
                    const Text("Finalizado em:"),
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
                  const Text("Valor acordado: "),
                  Text(currencyFormat.format(widget.order.value / 100)),
                ],
              ),
              if (widget.isServicer && widget.order.status == 1 ||
                  widget.order.status == 2 ||
                  widget.order.status == 4)
                TextButton(
                  onPressed: () async {
                    final position = await Location().getLocation();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => Mappage(
                          userp: widget.user.endereco!.latilong,
                          initial: LatLng(
                            position.latitude!,
                            position.longitude!,
                          ),
                        ),
                      ),
                    );
                  },
                  child: Text(
                    "Endereço: ${widget.user.endereco!.neighborhood}, ${widget.user.endereco!.route}, ${widget.user.endereco!.number}",
                    overflow: TextOverflow.clip,
                    style: const TextStyle(color: Colors.white),
                  ),
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

import 'package:flutter/material.dart';
import 'package:ijob/Core/Entities/orderService.dart';
import 'package:ijob/Core/services/geralUse/categorList.dart';
import 'package:ijob/Core/services/geralUse/profileUserList.dart';

import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';

class Pdforder {
  List<List<String>> _orderlist = [];

  final currencyFormat = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

  Future<void> exportToPdf(
    List<OrderService> orders,
    BuildContext wcontext,
  ) async {
    final pdf = pw.Document();

    _orderlist.add(<String>[
      'Requerinte',
      'Telefone',
      'Categoria',
      'Data marcada',
      'Data Finalização',
      'Valor',
    ]);

    for (OrderService order in orders) {
      final user = await Provider.of<Profileuserlist>(
        wcontext,
        listen: false,
      ).getProfile(order.user);

      final categor = Provider.of<Categorlist>(
        wcontext,
        listen: false,
      ).categoryById(order.categor);

      List<String> middleList = [
        user!.nome!,
        user.celular!,
        categor!.name!,
        DateFormat.yMd('pt_BR').format(order.definedAt),
        order.finishedAt != null
            ? DateFormat.yMd('pt_BR').format(order.finishedAt!)
            : "A finalizar",
        currencyFormat.format(order.value / 100),
      ];

      _orderlist.add(middleList);
    }

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Header(level: 0, child: pw.Text("Relatório de pedidos")),
              pw.SizedBox(height: 20),
              pw.TableHelper.fromTextArray(data: _orderlist),
              pw.SizedBox(height: 20),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }
}

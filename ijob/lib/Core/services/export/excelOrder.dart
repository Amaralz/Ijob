import 'dart:io';

import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:ijob/Core/Entities/orderService.dart';
import 'package:ijob/Core/Entities/profileUser.dart';
import 'package:ijob/Core/services/geralUse/categorList.dart';
import 'package:ijob/Core/services/geralUse/profileUserList.dart';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class Excelorder {
  Future<void> excelExport(
    List<OrderService> orders,
    BuildContext context,
  ) async {
    var excel = Excel.createExcel();

    excel.rename('Sheet1', 'Tabela de pedidos');

    Sheet sheet = excel['Tabela de pedidos'];

    sheet.appendRow([
      TextCellValue('Requerinte'),
      TextCellValue('Telefone'),
      TextCellValue('Categoria'),
      TextCellValue('Valor'),
      TextCellValue('Data Marcada'),
      TextCellValue('Data de finalização'),
      TextCellValue('Atrasado'),
      TextCellValue('Concluído'),
    ]);

    final currencyFormat = NumberFormat.currency(
      locale: 'pt_BR',
      symbol: 'R\$',
    );

    for (OrderService order in orders) {
      Profileuser? user = await Provider.of<Profileuserlist>(
        context,
        listen: false,
      ).getProfile(order.user);

      sheet.appendRow([
        TextCellValue(user!.nome!),
        TextCellValue(user.celular!),
        TextCellValue(
          Provider.of<Categorlist>(
            context,
            listen: false,
          ).categoryById(order.categor)!.name!,
        ),
        TextCellValue(currencyFormat.format(order.value / 100)),
        TextCellValue(DateFormat.yMd('pt_BR').format(order.definedAt)),
        TextCellValue(
          order.finishedAt != null
              ? DateFormat.yMd('pt_BR').format(order.finishedAt!)
              : "A finalizar",
        ),
        TextCellValue(order.status == 4 ? "Sim" : "Não"),
        TextCellValue(order.status == 3 ? "Sim" : "Não"),
      ]);
    }

    var filebytes = excel.save();
    var directory = await getApplicationDocumentsDirectory();

    File file = File('${directory.path}/relatorio_pedidos.xlsx');

    await file.writeAsBytes(filebytes!);

    await OpenFilex.open(file.path);
  }
}

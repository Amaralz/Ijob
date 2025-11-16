import 'package:ijob/Core/Entities/categorList.dart';
import 'package:ijob/Core/Entities/orderService.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:ijob/Core/Entities/profileUserList.dart';
import 'package:ijob/Core/Entities/servicerList.dart';
import 'package:ijob/Core/Entities/userRole.dart';
import 'package:ijob/Core/services/order/orderServicer.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Dashboardpage extends StatefulWidget {
  const Dashboardpage({super.key});

  @override
  State<Dashboardpage> createState() => _DashboardpageState();
}

class _DashboardpageState extends State<Dashboardpage> {
  bool _initialized = false;

  String _categorTitle(String id) {
    final categor = Provider.of<Categorlist>(context).categoryById(id);
    if (categor != null) {
      return categor.name!;
    }

    return '';
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final role = Provider.of<Userrole>(context, listen: false);

      String? userId = role.isUsu
          ? Provider.of<Profileuserlist>(context, listen: false).profile.id
          : Provider.of<Servicerlist>(context, listen: false).servicerUser.id;

      if (userId == null) {
        return;
      }

      Provider.of<Orderservicer>(context, listen: false).loadOrders(userId);

      _initialized = true;
    }
  }

  List<Widget> _buildCards(List<OrderService> order) {
    return [
      _buildCard(
        icon: Icons.hourglass_empty,
        titulo: 'Atrasados',
        valor: order.where(((order) => order.status == 4)).length.toString(),
        cor: Colors.red,
      ),

      _buildCard(
        icon: Icons.timelapse,
        titulo: 'Em Andamento',
        valor: order.where(((order) => order.status == 1)).length.toString(),
        cor: Colors.orange,
      ),

      _buildCard(
        icon: Icons.check,
        titulo: 'Finalizados',
        valor: order.where(((order) => order.status == 2)).length.toString(),
        cor: Colors.green,
      ),

      _buildCard(
        icon: Icons.handshake_outlined,
        titulo: 'Concluídos',
        valor: order.where(((order) => order.status == 3)).length.toString(),
        cor: Colors.blue,
      ),

      _buildCard(
        icon: Icons.cancel_outlined,
        titulo: 'Cancelados',
        valor: order.where(((order) => order.status == 0)).length.toString(),
        cor: Colors.blueGrey,
      ),
    ];
  }

  Widget _buildCard({
    required IconData icon,
    required String titulo,
    required String valor,
    required Color cor,
  }) {
    return Card(
      elevation: 4,
      child: Container(
        decoration: BoxDecoration(
          border: BoxBorder.fromLTRB(bottom: BorderSide(color: cor, width: 5)),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: cor),
              const SizedBox(height: 8),
              Text(titulo, style: const TextStyle(fontSize: 14)),
              const SizedBox(height: 6),
              Text(
                valor,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: cor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<String> _gerarUltimos6Meses() {
    final now = DateTime.now();
    final List<String> meses = [];
    final formatter = DateFormat.MMM('pt_BR');
    for (var i = 0; i < 6; i++) {
      final date = DateTime(now.year, now.month - (5 - i));
      meses.add(formatter.format(date));
    }
    return meses;
  }

  List<FlSpot> _graphData(List<OrderService> orders) {
    final now = DateTime.now();
    final List<FlSpot> spots = [];

    final completed = orders.where((order) => order.status == 3);

    for (int i = 0; i < 6; i++) {
      final target = DateTime(now.year, now.month - (5 - i));

      final count = completed.where((order) {
        if (order.finishedAt == null) {
          return false;
        }

        return order.finishedAt!.year == target.year &&
            order.finishedAt!.month == target.month;
      }).length;

      spots.add(FlSpot(i.toDouble(), count.toDouble()));
    }
    return spots;
  }

  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<Orderservicer>(context).orders;

    final servicer = Provider.of<Servicerlist>(context).servicerUser;

    final spots = _graphData(orders);

    double _getCategorQuant(int index) {
      return orders
          .where((order) => order.categor == servicer.category![index])
          .length
          .toDouble();
    }

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                SizedBox(
                  height: 180,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _buildCards(orders).map((card) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 3),
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(minWidth: 140),
                            child: card,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),

                const SizedBox(height: 24),
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Serviços concluidos',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 200,
                          child: LineChart(
                            LineChartData(
                              minX: 0,
                              maxX: 5,
                              minY: 0,
                              maxY: 10,
                              gridData: const FlGridData(show: true),
                              titlesData: FlTitlesData(
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 30,
                                    interval: 2,
                                    getTitlesWidget: (value, meta) {
                                      if (value % 2 == 0) {
                                        return Text(
                                          value.toInt().toString(),
                                          style: const TextStyle(fontSize: 12),
                                        );
                                      }
                                      return const Text('');
                                    },
                                  ),
                                ),
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    interval: 1,
                                    getTitlesWidget: (value, meta) {
                                      final meses = _gerarUltimos6Meses();
                                      if (value.toInt() < meses.length) {
                                        return Text(
                                          meses[value.toInt()],
                                          style: const TextStyle(fontSize: 12),
                                        );
                                      }
                                      return const Text('');
                                    },
                                  ),
                                ),
                                topTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                rightTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                              ),
                              borderData: FlBorderData(show: true),
                              lineBarsData: [
                                LineChartBarData(
                                  spots: spots,
                                  isCurved: true,
                                  color: Colors.blue,
                                  barWidth: 3,
                                  dotData: const FlDotData(show: true),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Serviços por categorias",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 300,
                          child: PieChart(
                            PieChartData(
                              centerSpaceRadius: 80,
                              sectionsSpace: 2,
                              sections: [
                                PieChartSectionData(
                                  title: _getCategorQuant(0).toString(),
                                  value: _getCategorQuant(0),
                                  color: Colors.blue,
                                  radius: 50,
                                  titleStyle: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                PieChartSectionData(
                                  title: _getCategorQuant(1).toString(),
                                  value: _getCategorQuant(1),
                                  color: Colors.orange,
                                  radius: 50,
                                  titleStyle: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            spacing: 5,
                            children: [
                              Row(
                                spacing: 5,
                                children: [
                                  Text(
                                    _categorTitle(servicer.category![0]),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Container(
                                    height: 10,
                                    width: 10,
                                    decoration: BoxDecoration(
                                      color: Colors.blue,
                                      border: BoxBorder.all(
                                        color: Colors.black,
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                spacing: 5,
                                children: [
                                  Text(
                                    _categorTitle(servicer.category![1]),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Container(
                                    height: 10,
                                    width: 10,
                                    decoration: BoxDecoration(
                                      color: Colors.orange,
                                      border: BoxBorder.all(
                                        color: Colors.black,
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

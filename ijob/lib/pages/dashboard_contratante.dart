import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class DashboardContratante extends StatefulWidget {
  const DashboardContratante({super.key});

  @override
  State<DashboardContratante> createState() => _DashboardContratanteState();
}

class _DashboardContratanteState extends State<DashboardContratante> {
  List<FlSpot> _dadosGrafico = [
    const FlSpot(0, 3),
    const FlSpot(1, 5),
    const FlSpot(2, 4),
    const FlSpot(3, 7),
    const FlSpot(4, 6),
    const FlSpot(5, 9),
  ];

  List<Widget> _buildCards() {
    return [
      _buildCard(
        icon: Icons.shopping_cart,
        titulo: 'contratados',
        valor: '15',
        cor: Colors.blue,
      ),
      _buildCard(
        icon: Icons.timelapse,
        titulo: 'Em Andamento',
        valor: '8',
        cor: Colors.orange,
      ),
      _buildCard(
        icon: Icons.check_circle,
        titulo: 'Finalizados',
        valor: '7',
        cor: Colors.green,
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
    );
  }

  List<String> _gerarUltimos6Meses() {
    final now = DateTime.now();
    final List<String> meses = [];
    for (var i = 5; i >= 0; i--) {
      final date = DateTime(now.year, now.month - i);
      meses.add(_formatarMes(date.month));
    }
    return meses;
  }

  String _formatarMes(int mes) {
    const nomes = [
      'Jan',
      'Fev',
      'Mar',
      'Abr',
      'Mai',
      'Jun',
      'Jul',
      'Ago',
      'Set',
      'Out',
      'Nov',
      'Dez',
    ];
    return nomes[mes - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
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
                      children: _buildCards().map((card) {
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
                          'Serviços concluidos (Últimos 6 meses)',
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
                                      return Text(
                                        value.toInt().toString(),
                                        style: const TextStyle(fontSize: 12),
                                      );
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
                                  spots: _dadosGrafico,
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
              ],
            ),
          );
        },
      ),
    );
  }
}

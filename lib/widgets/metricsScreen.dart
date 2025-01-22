import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:atletec/provider/manager.dart';
import 'package:atletec/model/metricModel.dart';

class MetricsScreen extends StatelessWidget {
  const MetricsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final manager = Provider.of<Manager>(context);
    final metrics = manager.metrics;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Métricas em tempo de execução'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          // Responsivo: quantas colunas couberem
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 250, // Ajuste conforme desejar
            childAspectRatio: 1.2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: metrics.length,
          itemBuilder: (context, index) {
            final metric = metrics[index];
            return MetricCard(metric: metric);
          },
        ),
      ),
    );
  }
}

class MetricCard extends StatelessWidget {
  final MetricModel metric;

  const MetricCard({Key? key, required this.metric}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Ao clicar no card, abrimos um pop-up com o gráfico
        showDialog(
          context: context,
          builder: (_) => MetricGraphDialog(metric: metric),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.blueGrey[900],
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(color: Colors.black45, blurRadius: 4),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              metric.name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Atual: ${metric.lastValue.toStringAsFixed(2)}",
              style: const TextStyle(fontSize: 14, color: Colors.white),
            ),
            const SizedBox(height: 4),
            Text(
              "Anterior: ${metric.previousValue?.toStringAsFixed(2) ?? '-'}",
              style: const TextStyle(fontSize: 14, color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}

class MetricGraphDialog extends StatelessWidget {
  final MetricModel metric;

  const MetricGraphDialog({Key? key, required this.metric}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Converter cada registro em um FlSpot
    // Eixo X: timestamp em milissegundos
    // Eixo Y: value
    final spots = metric.history.map((record) {
      final x = record.timestamp.millisecondsSinceEpoch.toDouble();
      final y = record.value;
      return FlSpot(x, y);
    }).toList();

    // Ordenar por tempo (caso alguma atualização fora de ordem)
    spots.sort((a, b) => a.x.compareTo(b.x));

    // Se quiser converter o eixo X para datas, precisamos formatar
    // Exemplo: mostra rótulos a cada 5 segundos, etc.
    return AlertDialog(
      backgroundColor: Colors.blueGrey[900],
      title: Text(
        'Histórico de ${metric.name}',
        style: const TextStyle(color: Colors.white),
      ),
      content: SizedBox(
        width: 400,
        height: 300,
        child: LineChart(
          LineChartData(
            lineBarsData: [
              LineChartBarData(
                spots: spots,
                isCurved: false,
                barWidth: 2,
                color: Colors.purpleAccent,
                dotData: const FlDotData(show: false),
              ),
            ],
            gridData: const FlGridData(show: true),
            borderData: FlBorderData(show: false),
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 5 * 1000, // ex.: 5s (em ms)
                  getTitlesWidget: (value, meta) {
                    final date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
                    // Formatar como quiser (mm:ss por ex.)
                    final text = "${date.minute}:${date.second.toString().padLeft(2,'0')}";
                    return Text(text, style: const TextStyle(color: Colors.white70, fontSize: 10));
                  },
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 40,
                  getTitlesWidget: (value, meta) => Text(
                    value.toStringAsFixed(1),
                    style: const TextStyle(color: Colors.white70, fontSize: 10),
                  ),
                ),
              ),
              topTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              rightTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Fechar'),
        )
      ],
    );
  }
}

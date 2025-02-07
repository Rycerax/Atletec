import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:atletec/provider/manager.dart';
import 'package:atletec/model/metricModel.dart';


double getNiceInterval(double interval){
  // Intervalos em ms (60.000 * minutos):
  List<double> niceInterval = 
  [1*1000,10*1000, 20*1000,1*60000,60000*2, 60000*5, 60000*10, 60000*15
  , 60000*20, 60000*25, 60000*30, 60000*35, 60000*40, 
  60000*45, 60000*50, 60000*55, 60000*60];

  double closest = niceInterval.first;
  double minDif = interval - closest;

  for(final candidate in niceInterval){
    final diff = (interval-candidate).abs();
    if(diff < minDif){
      minDif = diff;
      closest = candidate;
    }
  }
  return closest;
}


String formatLabel(DateTime date, double rangeMs) {
  if (rangeMs <= 60000) {
    // Menos de 1 min total
    return "${date.second}s";
  } else {
    // Menos de 1 hora
    return "${date.minute}:${date.second.toString().padLeft(2, '0')}";
  }
}

class MetricsScreen extends StatelessWidget {
  const MetricsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final manager = Provider.of<Manager>(context);
    final metrics = manager.metrics;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        // Ajuste o delegate como quiser
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 250,
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
    );
  }
}

class MetricCard extends StatelessWidget {
  final MetricModel metric;

  const MetricCard({super.key, required this.metric});

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
          borderRadius: BorderRadius.circular(10),
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
              "Atual: ${metric.lastValue.toStringAsFixed(2)} ${metric.unitMeasure}",
              style: const TextStyle(fontSize: 14, color: Colors.white),
            ),
            const SizedBox(height: 4),
            Text(
              "Anterior: ${metric.previousValue?.toStringAsFixed(2) ?? '-'} ${metric.unitMeasure}",
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

  const MetricGraphDialog({super.key, required this.metric});

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
    final double minX = spots.isEmpty ? 0 : spots.first.x;
    final double maxX = spots.isEmpty ? 0 : spots.last.x;
    final double rangeX = maxX - minX;
    const int numLabelsX = 5;
    double niceInterval = rangeX == 0 ? 1 : rangeX/(numLabelsX-1);
    niceInterval = getNiceInterval(niceInterval);
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
            minX: minX,
            maxX: maxX,
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: niceInterval,
                  getTitlesWidget: (value, meta) {
                    if (value < minX || value > maxX) {
                      return const SizedBox();
                    }
                    final date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
                    // Formatar como quiser (mm:ss por ex.)
                    final text = formatLabel(date, rangeX);
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
              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            gridData: const FlGridData(show: true),
            borderData: FlBorderData(show: false),
            lineBarsData: [
              LineChartBarData(
                spots: spots,
                isCurved: false,
                barWidth: 2,
                color: Colors.purpleAccent,
                dotData: const FlDotData(show: false),
              ),
            ],

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

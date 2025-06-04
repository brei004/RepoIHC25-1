import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ProgressScreen extends StatelessWidget {
  final int buenas;
  final int malas;

  const ProgressScreen({
    super.key,
    required this.buenas,
    required this.malas,
  });

  @override
  Widget build(BuildContext context) {
    final int total = buenas + malas;
    final double porcentajeBuenas = total > 0 ? (buenas / total) * 100 : 0;
    final double porcentajeMalas = 100 - porcentajeBuenas;

    return Scaffold(
      appBar: AppBar(title: const Text('Tu progreso')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Text(
              'Ideas evaluadas',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            AspectRatio(
              aspectRatio: 1.3,
              child: PieChart(
                PieChartData(
                  centerSpaceRadius: 60,
                  sectionsSpace: 2,
                  sections: [
                    PieChartSectionData(
                      value: porcentajeBuenas,
                      color: Colors.green,
                      title: '${porcentajeBuenas.toStringAsFixed(1)}%',
                      titleStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    PieChartSectionData(
                      value: porcentajeMalas,
                      color: Colors.red,
                      title: '${porcentajeMalas.toStringAsFixed(1)}%',
                      titleStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _Legend(color: Colors.green, label: 'Buenas (${buenas})'),
                const SizedBox(width: 16),
                _Legend(color: Colors.red, label: 'Malas (${malas})'),
              ],
            ),
            const SizedBox(height: 32),
            Text(
              'Has compartido $total ideas\n¡Sigue así! 💡',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            )
          ],
        ),
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  final Color color;
  final String label;

  const _Legend({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(radius: 6, backgroundColor: color),
        const SizedBox(width: 8),
        Text(label),
      ],
    );
  }
}

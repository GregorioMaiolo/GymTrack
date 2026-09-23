import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../controllers/statistics_controller.dart';

class StatisticsScreen extends StatefulWidget {
  final int exerciseId;
  final String exerciseName;

  const StatisticsScreen({
    super.key,
    required this.exerciseId,
    required this.exerciseName,
  });

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  final StatisticsController controller = StatisticsController();

  @override
  void initState() {
    super.initState();
    loadWorkoutSets();
  }

  Future<void> loadWorkoutSets() async {
    await controller.loadWorkoutSets(widget.exerciseId);

    if (!mounted) return;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final workoutSets = controller.workoutSets;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistik'),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: ListView(
          children: [
            Text(
              widget.exerciseName,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            Card(
              child: ListTile(
                title: const Text('Trainingssätze'),
                trailing: Text('${workoutSets.length}'),
              ),
            ),

            Card(
              child: ListTile(
                title: const Text('Höchstes Gewicht'),
                trailing: Text(
                  '${controller.getHighestWeight().toStringAsFixed(1)} kg',
                ),
              ),
            ),

            Card(
              child: ListTile(
                title: const Text('Durchschnittliches Gewicht'),
                trailing: Text(
                  '${controller.getAverageWeight().toStringAsFixed(1)} kg',
                ),
              ),
            ),

            Card(
              child: ListTile(
                title: const Text('Meiste Wiederholungen'),
                trailing: Text('${controller.getHighestRepetitions()}'),
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              'Gewichtsverlauf',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            if (workoutSets.length >= 2)
              SizedBox(
                height: 250,

                child: LineChart(
                  LineChartData(
                    minY: 0,

                    lineBarsData: [
                      LineChartBarData(
                        spots: [
                          for (int i = 0; i < workoutSets.length; i++)
                            FlSpot(
                              i.toDouble(),
                              workoutSets[i].weight,
                            ),
                        ],

                        isCurved: false,

                        dotData: const FlDotData(
                          show: true,
                        ),
                      ),
                    ],

                    gridData: const FlGridData(
                      show: true,
                    ),

                    titlesData: FlTitlesData(
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: false,
                        ),
                      ),

                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: false,
                        ),
                      ),

                      leftTitles: const AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 40,
                        ),
                      ),

                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 1,
                          reservedSize: 35,

                          getTitlesWidget: (value, meta) {
                            final index = value.toInt();

                            if (value != index.toDouble()) {
                              return const SizedBox();
                            }

                            if (index < 0 || index >= workoutSets.length) {
                              return const SizedBox();
                            }

                            final date = workoutSets[index].date;

                            if (index > 0) {
                              final previousDate = workoutSets[index - 1].date;

                              if (date.substring(0, 10) ==
                                  previousDate.substring(0, 10)) {
                                return const SizedBox();
                              }
                            }

                            return Text(
                              '${date.substring(8, 10)}.'
                              '${date.substring(5, 7)}',

                              style: const TextStyle(
                                fontSize: 10,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              )
            else
              const Text(
                'Mindestens 2 Trainings für die Statistik nötig.',
              ),
          ],
        ),
      ),
    );
  }
}
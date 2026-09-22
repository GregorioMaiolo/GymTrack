import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../database/database_helper.dart';
import '../models/workout_set.dart';

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
  List<WorkoutSet> workoutSets = [];

  @override
  void initState() { //wird aufgerufen, wenn der State initialisiert wird
    super.initState();
    loadWorkoutSets(); //wenn initialisiert, lade die WorkoutSets
  }

  Future<void> loadWorkoutSets() async {
    final data = await DatabaseHelper.getWorkoutSets(widget.exerciseId);

    setState(() {
      workoutSets = data.reversed.toList();
    });
  }

  double getHighestWeight() {
    if (workoutSets.isEmpty) {
      return 0;
    }

    double highest = 0;

    for (final set in workoutSets) {
      if (set.weight > highest) {
        highest = set.weight;
      }
    }

    return highest;
  }

  double getAverageWeight() {
    if (workoutSets.isEmpty) {
      return 0;
    }

    double total = 0;

    for (final set in workoutSets) {
      total += set.weight;
    }

    return total / workoutSets.length;
  }

  int getHighestRepetitions() {
    int highest = 0;

    for (final set in workoutSets) {
      if (set.repetitions > highest) {
        highest = set.repetitions;
      }
    }

    return highest;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Statistik'),
      ),

      body: Padding(
        padding: EdgeInsets.all(16),

        child: ListView(
          children: [
            Text(
              widget.exerciseName,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 20),

            Card(
              child: ListTile(
                title: Text('Trainingssätze'),
                trailing: Text('${workoutSets.length}'),
              ),
            ),

            Card(
              child: ListTile(
                title: Text('Höchstes Gewicht'),
                trailing: Text(
                  '${getHighestWeight().toStringAsFixed(1)} kg',
                ),
              ),
            ),

            Card(
              child: ListTile(
                title: Text('Durchschnittliches Gewicht'),
                trailing: Text(
                  '${getAverageWeight().toStringAsFixed(1)} kg',
                ),
              ),
            ),

            Card(
              child: ListTile(
                title: Text('Meiste Wiederholungen'),
                trailing: Text('${getHighestRepetitions()}'),
              ),
            ),

            SizedBox(height: 30),

            Text(
              'Gewichtsverlauf',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 20),

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
                        dotData: FlDotData(
                          show: true,
                        ),
                      ),
                    ],

                    gridData: FlGridData(
                      show: true,
                    ),

                    titlesData: FlTitlesData(
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: false,
                        ),
                      ),

                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: false,
                        ),
                      ),

                      leftTitles: AxisTitles(
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
                            int index = value.toInt();

                            if (value != index.toDouble()) {
                              return SizedBox();
                            }

                            if (index < 0 || index >= workoutSets.length) {
                              return SizedBox();
                            }

                            String date = workoutSets[index].date;

                            // Datum des vorherigen Punktes
                            if (index > 0) {
                              String previousDate = workoutSets[index - 1].date;

                              if (date.substring(0, 10) ==
                                  previousDate.substring(0, 10)) {
                                return SizedBox();
                              }
                            }

                            return Text(
                              '${date.substring(8, 10)}.${date.substring(5, 7)}',
                              style: TextStyle(
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
              Text(
                'Mindestens 2 Trainings für die Statistik nötig.',
              ),
          ],
        ),
      ),
    );
  }
}

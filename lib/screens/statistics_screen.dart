import 'package:flutter/material.dart';

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
      workoutSets = data;
    });
  }

  double getHighestWeight() {
    if (workoutSets.isEmpty) {
      return 0;
    }

    double highest = 0;

    for (final workoutSet in workoutSets) {
      if (workoutSet.weight > highest) {
        highest = workoutSet.weight;
      }
    }

    return highest;
  }

  double getAverageWeight() {
    if (workoutSets.isEmpty) {
      return 0;
    }

    double total = 0;

    for (final workoutSet in workoutSets) {
      total += workoutSet.weight;
    }

    return total / workoutSets.length;
  }

  int getHighestRepetitions() {
    if (workoutSets.isEmpty) {
      return 0;
    }

    int highest = 0;

    for (final workoutSet in workoutSets) {
      if (workoutSet.repetitions > highest) {
        highest = workoutSet.repetitions;
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

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

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
                trailing: Text(
                  '${workoutSets.length}',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            Card(
              child: ListTile(
                title: Text('Höchstes Gewicht'),
                trailing: Text(
                  '${getHighestWeight().toStringAsFixed(1)} kg',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            Card(
              child: ListTile(
                title: Text('Durchschnittliches Gewicht'),
                trailing: Text(
                  '${getAverageWeight().toStringAsFixed(1)} kg',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            Card(
              child: ListTile(
                title: Text('Meiste Wiederholungen'),
                trailing: Text(
                  '${getHighestRepetitions()}',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
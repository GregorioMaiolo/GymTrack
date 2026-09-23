import 'package:flutter/material.dart';

import '../database/database_helper.dart';
import '../models/workout_set.dart';

import 'statistics_screen.dart';

class WorkoutScreen extends StatefulWidget {
  final int exerciseId;
  final String exerciseName;

  const WorkoutScreen({
    super.key, //IDE motzt ohne das
    required this.exerciseId,
    required this.exerciseName,
  });

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  final weightController = TextEditingController();
  final repetitionsController = TextEditingController();

  List<WorkoutSet> workoutSets = [];

  @override
  void initState() {
    super.initState();
    loadWorkoutSets();
  }

  Future<void> loadWorkoutSets() async {
    final data = await DatabaseHelper.getWorkoutSets(widget.exerciseId);

    setState(() {
      workoutSets = data;
    });
  }

  Map<String, List<WorkoutSet>> groupSetsByDate() {
    Map<String, List<WorkoutSet>> groupedSets = {};

    for (final workoutSet in workoutSets) {
      final date = workoutSet.date.substring(0, 10);

      if (!groupedSets.containsKey(date)) {
        groupedSets[date] = [];
      }

      groupedSets[date]!.add(workoutSet);
    }

    return groupedSets;
  }

  Future<void> saveWorkoutSet() async {
    if (weightController.text.isEmpty || repetitionsController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Bitte Gewicht und Wiederholungen eingeben.'),
        ),
      );
      return;
    }

    final weight = double.tryParse(weightController.text);
    final repetitions = int.tryParse(repetitionsController.text);

    if (weight == null || repetitions == null) {
      return;
    }

    await DatabaseHelper.addWorkoutSet(
      widget.exerciseId,
      weight,
      repetitions,
    );

    weightController.clear();
    repetitionsController.clear();

    loadWorkoutSets();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.exerciseName),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => StatisticsScreen(
                    exerciseId: widget.exerciseId,
                    exerciseName: widget.exerciseName,
                  ),
                ),
              );
            },
            icon: Icon(Icons.bar_chart),
          ),
        ],
      ),

      body: Padding(
        padding: EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Text(
              'Neuer Satz',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: weightController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Gewicht (kg)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),

                SizedBox(width: 12),

                Expanded(
                  child: TextField(
                    controller: repetitionsController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Wiederholungen',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: saveWorkoutSet,
                child: Text('Satz speichern'),
              ),
            ),

            SizedBox(height: 30),

            Text(
              'Trainingsverlauf',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 12),

            Expanded(
              child: Builder(
                builder: (context) {
                  final groupedSets = groupSetsByDate();
                  final dates = groupedSets.keys.toList();

                  return ListView.builder(
                    itemCount: dates.length,
                    itemBuilder: (context, index) {
                      final date = dates[index];
                      final sets = groupedSets[date]!;

                      return Card(
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                date,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              SizedBox(height: 8),

                              for (final workoutSet in sets)
                                Padding(
                                  padding: EdgeInsets.only(bottom: 4),
                                  child: Text(
                                    '${workoutSet.weight} kg × ${workoutSet.repetitions}',
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

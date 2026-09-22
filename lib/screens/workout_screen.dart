import 'package:flutter/material.dart';

import '../database/database_helper.dart';
import '../models/workout_set.dart';

class WorkoutScreen extends StatefulWidget {
  final int exerciseId;
  final String exerciseName;

  const WorkoutScreen({
    super.key,//IDE motzt ohne das
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

  Future<void> saveWorkoutSet() async {
    if (weightController.text.isEmpty || repetitionsController.text.isEmpty) {
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
            onPressed: () {},
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

            TextField(
              controller: weightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Gewicht (kg)',
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 12),

            TextField(
              controller: repetitionsController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Wiederholungen',
                border: OutlineInputBorder(),
              ),
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
              child: ListView.builder(
                itemCount: workoutSets.length,
                itemBuilder: (context, index) {
                  final workoutSet = workoutSets[index];

                  return Card(
                    child: ListTile(
                      title: Text(
                        '${workoutSet.weight} kg × ${workoutSet.repetitions}',
                      ),
                      subtitle: Text(
                        workoutSet.date.substring(0, 10),
                      ),
                    ),
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
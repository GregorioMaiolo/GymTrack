import 'package:flutter/material.dart';

import 'database/database_helper.dart';
import 'models/exercise.dart';
import 'screens/workout_screen.dart';
import 'screens/create_exercise_screen.dart';

void main() {
  runApp(
    MaterialApp(
      theme: ThemeData.dark(),
      home: ExerciseListScreen(),
    ),
  );
}

class ExerciseListScreen extends StatefulWidget {
  const ExerciseListScreen({super.key});

  @override
  State<ExerciseListScreen> createState() => _ExerciseListScreenState();
}

class _ExerciseListScreenState extends State<ExerciseListScreen> {
  List<Exercise> exercises = [];

  @override
  void initState() {
    super.initState();
    loadExercises();
  }

  Future<void> loadExercises() async {
    final data = await DatabaseHelper.getExercises();

    setState(() {
      exercises = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GymTracker'),
      ),

      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: exercises.length,
        itemBuilder: (context, index) {
          final exercise = exercises[index];

          return Card(
            child: ListTile(
              title: Text(
                exercise.name,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              subtitle: Text(
                '${exercise.description}\n0 Trainings',
              ),

              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WorkoutScreen(
                      exerciseName: exercise.name,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateExerciseScreen(),
            ),
          );

          loadExercises();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

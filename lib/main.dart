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
  Map<int, int> workoutCounts = {};

  final GlobalKey<AnimatedListState> listKey =
      GlobalKey<AnimatedListState>();

  bool loaded = false;

  @override
  void initState() {
    super.initState();
    loadExercises();
  }

  Future<void> loadExercises() async {
    final data = await DatabaseHelper.getExercises();

    Map<int, int> counts = {};

    for (final exercise in data) {
      counts[exercise.id] = await DatabaseHelper.getWorkoutCount(exercise.id);
    }

    setState(() {
      exercises = data;
      workoutCounts = counts;
      loaded = true;
    });
  }

  Future<void> addNewExerciseToList() async {
    final data = await DatabaseHelper.getExercises();

    if (data.length > exercises.length) {
      final newExercise = data.last;
      final newIndex = exercises.length;

      setState(() {
        exercises.add(newExercise);
        workoutCounts[newExercise.id] = 0;
      });

      listKey.currentState?.insertItem(
        newIndex,
        duration: Duration(milliseconds: 1000),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!loaded) {
      return Scaffold(
        appBar: AppBar(
          title: Text('GymTracker'),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('GymTracker'),
      ),

      body: AnimatedList(
        key: listKey,
        padding: EdgeInsets.all(16),
        initialItemCount: exercises.length,

        itemBuilder: (context, index, animation) {
          final exercise = exercises[index];

          return SizeTransition(
            sizeFactor: animation,

            child: FadeTransition(
              opacity: animation,

              child: Card(
                child: ListTile(
                  title: Text(
                    exercise.name,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  subtitle: Text(
                    '${exercise.description}\n'
                    '${workoutCounts[exercise.id] ?? 0} Trainings',
                  ),

                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WorkoutScreen(
                          exerciseId: exercise.id,
                          exerciseName: exercise.name,
                        ),
                      ),
                    );

                    loadExercises();
                  },
                ),
              ),
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

          addNewExerciseToList();
        },

        child: Icon(Icons.add),
      ),
    );
  }
}
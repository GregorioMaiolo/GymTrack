import 'package:flutter/material.dart';

import '../database/database_helper.dart';
import '../models/exercise.dart';
import '../widgets/exercise_card.dart';
import 'create_exercise_screen.dart';

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
      counts[exercise.id] =
          await DatabaseHelper.getWorkoutCount(exercise.id);
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
        duration: Duration(milliseconds: 800),
      );
    }
  }

  Future<void> deleteExercise(int index) async {
    final exercise = exercises[index];

    // Aus SQLite löschen
    await DatabaseHelper.deleteExercise(exercise.id);

    // Aus Listen entfernen
    exercises.removeAt(index);
    workoutCounts.remove(exercise.id);

    // AnimatedList über das Löschen informieren
    listKey.currentState?.removeItem(
      index,
      (context, animation) {
        return SizeTransition(
          sizeFactor: animation,
          child: FadeTransition(
            opacity: animation,
            child: Card(
              child: ListTile(
                title: Text(exercise.name),
                subtitle: Text(exercise.description),
              ),
            ),
          ),
        );
      },
      duration: Duration(milliseconds: 400),
    );

    setState(() {});
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

      body: exercises.isEmpty
          ? Center(
              child: Padding(
                padding: EdgeInsets.all(30),

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    Icon(
                      Icons.fitness_center,
                      size: 60,
                    ),

                    SizedBox(height: 20),

                    Text(
                      'Noch keine Übungen vorhanden.',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    SizedBox(height: 10),

                    Text(
                      'Klicke auf +, um deine erste Übung zu erstellen.',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            )
          : AnimatedList(
              key: listKey,
              padding: EdgeInsets.all(16),
              initialItemCount: exercises.length,

              itemBuilder: (context, index, animation) {
                final exercise = exercises[index];

                return ExerciseCard(
                  exercise: exercise,
                  workoutCount: workoutCounts[exercise.id] ?? 0,
                  animation: animation,

                  onExerciseUpdated: loadExercises,

                  onDelete: () {
                    deleteExercise(index);
                  },
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
import 'package:flutter/material.dart';

import '../controllers/exercise_list_controller.dart';
import '../models/exercise.dart';
import '../widgets/exercise_card.dart';
import 'create_exercise_screen.dart';

class ExerciseListScreen extends StatefulWidget {
  const ExerciseListScreen({super.key});

  @override
  State<ExerciseListScreen> createState() => _ExerciseListScreenState(); // State-Klasse für die Übungslistenansicht
}

class _ExerciseListScreenState extends State<ExerciseListScreen> {
  final ExerciseListController controller = ExerciseListController();

  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();

  bool loaded = false;

  @override
  void initState() {// einmalige Initialisierung der State-Klasse, um die Übungen zu laden
    super.initState();
    loadExercises();
  }

  Future<void> loadExercises() async {
    await controller.loadExercises();

    if (!mounted) return;

    setState(() {
      loaded = true;
    });
  }

  Future<void> deleteExercise(int index) async {
    final exercise = controller.exercises[index];

    await controller.deleteExercise(exercise);

    if (!mounted) return;

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
                subtitle: Text(
                  exercise.description,
                ),
              ),
            ),
          ),
        );
      },

      duration: const Duration(milliseconds: 400),
    );

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (!loaded) { //wenn noch nicht geladen
      return Scaffold(
        appBar: AppBar(
          title: const Text('GymTracker'),
        ),

        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('GymTracker'),
      ),

      body: controller.exercises.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(30),

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: const [
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
              padding: const EdgeInsets.all(16),
              initialItemCount: controller.exercises.length,

              itemBuilder: (context, index, animation) {
                final Exercise exercise = controller.exercises[index];

                return ExerciseCard(
                  exercise: exercise,

                  workoutCount: controller.workoutCounts[exercise.id] ?? 0,

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
          final newExercise = await Navigator.push<Exercise>(
            context,

            MaterialPageRoute(
              builder: (context) => const CreateExerciseScreen(),
            ),
          );

          if (newExercise == null) {
            return;
          }

          controller.exercises.add(newExercise);
          controller.workoutCounts[newExercise.id] = 0;

          final newIndex = controller.exercises.length - 1;

          setState(() {});

          listKey.currentState?.insertItem(
            newIndex,
            duration: const Duration(
              milliseconds: 800,
            ),
          );
        },

        child: const Icon(Icons.add),
      ),
    );
  }
}
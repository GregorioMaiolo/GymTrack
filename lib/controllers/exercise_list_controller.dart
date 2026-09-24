import '../database/database_helper.dart';
import '../models/exercise.dart';

class ExerciseListController {
  List<Exercise> exercises = [];
  Map<int, int> workoutCounts = {}; // Map, die die Anzahl der Trainingssätze für jede Übung speichert

  Future<void> loadExercises() async {
    final data = await DatabaseHelper.getExercises();

    final Map<int, int> counts = {};

    for (final exercise in data) { // Für jede Übung die Anzahl der Trainingssätze abrufen
      counts[exercise.id] = await DatabaseHelper.getWorkoutCount(
        exercise.id,
      );
    }

    exercises = data;
    workoutCounts = counts;
  }

  Future<void> deleteExercise(Exercise exercise) async {
    await DatabaseHelper.deleteExercise(
      exercise.id,
    );

    exercises.remove(exercise);
    workoutCounts.remove(exercise.id);
  }
}
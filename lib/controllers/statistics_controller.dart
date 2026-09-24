import '../database/database_helper.dart';
import '../models/workout_set.dart';

class StatisticsController {
  List<WorkoutSet> workoutSets = [];

  Future<void> loadWorkoutSets(int exerciseId) async { // Lädt die Trainingssätze für eine bestimmte Übung aus der Datenbank
    final data = await DatabaseHelper.getWorkoutSets(exerciseId);

    workoutSets = data.reversed.toList();
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
    int highest = 0;

    for (final workoutSet in workoutSets) {
      if (workoutSet.repetitions > highest) {
        highest = workoutSet.repetitions;
      }
    }

    return highest;
  }
}
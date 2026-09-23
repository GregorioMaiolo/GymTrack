import '../database/database_helper.dart';
import '../models/workout_set.dart';

class WorkoutController {
  List<WorkoutSet> workoutSets = [];

  int? editingSetId;

  Future<void> loadWorkoutSets(
    int exerciseId,
  ) async {
    workoutSets = await DatabaseHelper.getWorkoutSets(
      exerciseId,
    );
  }

  Map<String, List<WorkoutSet>> groupSetsByDate() {
    final Map<String, List<WorkoutSet>> groupedSets = {};

    for (final workoutSet in workoutSets) {
      final date = workoutSet.date.substring(0, 10);

      if (!groupedSets.containsKey(date)) {
        groupedSets[date] = [];
      }

      groupedSets[date]!.add(workoutSet);
    }

    return groupedSets;
  }

  Future<String?> saveWorkoutSet({
    required int exerciseId,
    required String weightText,
    required String repetitionsText,
  }) async {
    if (weightText.isEmpty || repetitionsText.isEmpty) {
      return 'Bitte Gewicht und Wiederholungen eingeben.';
    }

    // Komma durch Punkt ersetzen, damit z.B. 50,5 auch funktioniert
    final weightString = weightText.replaceAll(',', '.');

    // Prüfen, ob maximal 2 Nachkommastellen vorhanden sind
    final parts = weightString.split('.');

    if (parts.length == 2 && parts[1].length > 2) {
      return 'Das Gewicht darf maximal 2 Nachkommastellen haben.';
    }

    final weight = double.tryParse(weightString);
    final repetitions = int.tryParse(repetitionsText);

    if (weight == null || weight < 0) {
      return 'Bitte ein gültiges Gewicht eingeben.';
    }

    if (weight > 600) {
      return 'Das Gewicht darf maximal 600 kg sein.';
    }

    if (repetitions == null || repetitions <= 0) {
      return 'Bitte gültige Wiederholungen eingeben.';
    }

    try {
      if (editingSetId == null) {
        await DatabaseHelper.addWorkoutSet(
          exerciseId,
          weight,
          repetitions,
        );
      } else {
        await DatabaseHelper.updateWorkoutSet(
          editingSetId!,
          weight,
          repetitions,
        );
      }

      editingSetId = null;

      return null;
    } catch (e) {
      return 'Fehler beim Speichern.';
    }
  }

  void editWorkoutSet(
    WorkoutSet workoutSet,
  ) {
    editingSetId = workoutSet.id;
  }

  Future<void> deleteWorkoutSet(
    WorkoutSet workoutSet,
  ) async {
    await DatabaseHelper.deleteWorkoutSet(
      workoutSet.id,
    );
  }

  void cancelEdit() {
    editingSetId = null;
  }
}
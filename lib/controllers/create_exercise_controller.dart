import '../database/database_helper.dart';
import '../models/exercise.dart';

class CreateExerciseController {
  Future<Exercise?> createExercise(
    String name,
    String description,
  ) async {
    final trimmedName = name.trim();

    if (trimmedName.isEmpty) {
      return null;
    }

    final id = await DatabaseHelper.addExercise(
      trimmedName,
      description,
    );

    return Exercise(
      id: id,
      name: trimmedName,
      description: description,
    );
  }
}
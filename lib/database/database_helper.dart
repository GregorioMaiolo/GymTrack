import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/exercise.dart';
import '../models/workout_set.dart';

class DatabaseHelper {
  static Future<Database> getDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'gymtracker.db');

    return openDatabase(
      path,
      onCreate: (database, version) async {
        await database.execute(
          '''
      CREATE TABLE exercises(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        description TEXT NOT NULL
      )
      ''',
        );

        await database.execute(
          '''
      CREATE TABLE workout_sets(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        exercise_id INTEGER NOT NULL,
        weight REAL NOT NULL,
        repetitions INTEGER NOT NULL,
        date TEXT NOT NULL
      )
      ''',
        );
      },

      onUpgrade: (database, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await database.execute(
            '''
        CREATE TABLE workout_sets(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          exercise_id INTEGER NOT NULL,
          weight REAL NOT NULL,
          repetitions INTEGER NOT NULL,
          date TEXT NOT NULL
        )
        ''',
          );
        }
      },

      version: 2,
    );
  }

  static Future<int> addExercise(String name, String description) async {
    final database = await getDatabase();

    return database.insert(
      'exercises',
      {
        'name': name,
        'description': description,
      },
    );
  }

  static Future<List<Exercise>> getExercises() async {
    final database = await getDatabase();

    final result = await database.query('exercises');

    return result.map((map) => Exercise.fromMap(map)).toList();
  }

  static Future<int> addWorkoutSet(
    int exerciseId,
    double weight,
    int repetitions,
  ) async {
    final database = await getDatabase();

    return database.insert(
      'workout_sets',
      {
        'exercise_id': exerciseId,
        'weight': weight,
        'repetitions': repetitions,
        'date': DateTime.now().toIso8601String(),
        // 'date': '2026-10-29',//für Testen
      },
    );
  }

  static Future<List<WorkoutSet>> getWorkoutSets(int exerciseId) async {
    final database = await getDatabase();

    final result = await database.query(
      'workout_sets',
      where: 'exercise_id = ?',
      whereArgs: [exerciseId],
      orderBy: 'date DESC',
    );

    return result.map((map) => WorkoutSet.fromMap(map)).toList();
  }

  static Future<int> getWorkoutCount(int exerciseId) async {
    final database = await getDatabase();

    final result = await database.rawQuery(
      'SELECT COUNT(*) as count FROM workout_sets WHERE exercise_id = ?',
      [exerciseId],
    );

    return result.first['count'] as int;
  }

  static Future<void> deleteExercise(int exerciseId) async {
    final database = await getDatabase();

    // Alle Trainingssätze dieser Übung löschen
    await database.delete(
      'workout_sets',
      where: 'exercise_id = ?',
      whereArgs: [exerciseId],
    );

    // Danach die Übung selbst löschen
    await database.delete(
      'exercises',
      where: 'id = ?',
      whereArgs: [exerciseId],
    );
  }

  static Future<void> deleteWorkoutSet(int id) async {
    final database = await getDatabase();

    await database.delete(
      'workout_sets',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<void> updateWorkoutSet(
    int id,
    double weight,
    int repetitions,
  ) async {
    final database = await getDatabase();

    await database.update(
      'workout_sets',
      {
        'weight': weight,
        'repetitions': repetitions,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
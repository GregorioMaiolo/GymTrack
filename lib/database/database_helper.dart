import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/exercise.dart';

class DatabaseHelper {
  static Future<Database> getDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'gymtracker.db');

    return openDatabase(
      path,
      onCreate: (database, version) {
        return database.execute(
          '''
          CREATE TABLE exercises(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            description TEXT
          )
          ''',
        );
      },
      version: 1,
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
}

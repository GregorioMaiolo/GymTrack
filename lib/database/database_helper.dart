import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

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
}
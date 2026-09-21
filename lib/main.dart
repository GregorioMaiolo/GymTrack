import 'package:flutter/material.dart';

import 'workout_screen.dart';

void main() {
  runApp(
    MaterialApp(
      theme: ThemeData.dark(),
      home: ExerciseListScreen(),
    ),
  );
}

class ExerciseListScreen extends StatelessWidget {
  ExerciseListScreen({super.key});

  final List<String> exercises = [
    'Bankdrücken',
    'Kniebeugen',
    'Klimmzüge',
    'Bizepscurls',
    'Schulterdrücken',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GymTracker'),
      ),

      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: exercises.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(
                exercises[index],
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text('0 Trainings'),

              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WorkoutScreen(
                      exerciseName: exercises[index],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../models/exercise.dart';
import '../screens/workout_screen.dart';

class ExerciseCard extends StatelessWidget {
  final Exercise exercise;
  final int workoutCount;
  final Animation<double> animation;
  final VoidCallback onExerciseUpdated;

  const ExerciseCard({
    super.key,
    required this.exercise,
    required this.workoutCount,
    required this.animation,
    required this.onExerciseUpdated,
  });

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: animation,

      child: FadeTransition(
        opacity: animation,

        child: Card(
          child: ListTile(
            title: Text(
              exercise.name,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            subtitle: Text(
              '${exercise.description}\n'
              '$workoutCount Trainings',
            ),

            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WorkoutScreen(
                    exerciseId: exercise.id,
                    exerciseName: exercise.name,
                  ),
                ),
              );

              onExerciseUpdated();
            },
          ),
        ),
      ),
    );
  }
}
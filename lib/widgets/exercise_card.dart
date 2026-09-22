import 'package:flutter/material.dart';

import '../models/exercise.dart';
import '../screens/workout_screen.dart';

class ExerciseCard extends StatelessWidget {
  final Exercise exercise;
  final int workoutCount;
  final Animation<double> animation;
  final VoidCallback onExerciseUpdated;
  final VoidCallback onDelete;

  const ExerciseCard({
    super.key,
    required this.exercise,
    required this.workoutCount,
    required this.animation,
    required this.onExerciseUpdated,
    required this.onDelete,
  });

  Future<bool> confirmDelete(BuildContext context) async {
    final delete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Übung löschen?'),

          content: Text(
            'Möchtest du "${exercise.name}" wirklich löschen?\n\n'
            'Auch alle gespeicherten Trainingsdaten werden gelöscht.',
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: Text('Abbrechen'),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: Text('Löschen'),
            ),
          ],
        );
      },
    );

    return delete ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: animation,

      child: FadeTransition(
        opacity: animation,

        child: Dismissible(
          key: ValueKey(exercise.id),

          direction: DismissDirection.endToStart,

          background: Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.only(right: 20),

            child: Icon(
              Icons.delete,
              size: 30,
            ),
          ),

          confirmDismiss: (direction) async {
            final delete = await confirmDelete(context);

            if (delete) {
              onDelete();
            }

            // false, weil wir selbst die AnimatedList entfernen.
            return false;
          },

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
      ),
    );
  }
}
import 'package:flutter/material.dart';

import '../controllers/create_exercise_controller.dart';

class CreateExerciseScreen extends StatefulWidget {
  const CreateExerciseScreen({super.key});

  @override
  State<CreateExerciseScreen> createState() => _CreateExerciseScreenState();
}

class _CreateExerciseScreenState extends State<CreateExerciseScreen> {
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();

  final CreateExerciseController controller = CreateExerciseController();

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> createExercise() async {
    final exercise = await controller.createExercise(
      nameController.text,
      descriptionController.text,
    );

    if (!mounted) return;

    if (exercise == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Bitte einen gültigen Namen eingeben.'),
        ),
      );
      return;
    }

    Navigator.pop(context, exercise);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Neue Übung'),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Name der Übung',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Beschreibung',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,

              child: ElevatedButton(
                onPressed: createExercise,
                child: const Text('Übung erstellen'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
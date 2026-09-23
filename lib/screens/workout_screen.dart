import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../controllers/workout_controller.dart';
import '../models/workout_set.dart';

import 'statistics_screen.dart';

class WorkoutScreen extends StatefulWidget {
  final int exerciseId;
  final String exerciseName;

  const WorkoutScreen({
    super.key, //IDE motzt ohne das
    required this.exerciseId,
    required this.exerciseName,
  });

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  final weightController = TextEditingController();

  final repetitionsController = TextEditingController();

  final WorkoutController controller = WorkoutController();

  @override
  void initState() {
    super.initState();
    loadWorkoutSets();
  }

  @override
  void dispose() {
    weightController.dispose();
    repetitionsController.dispose();
    super.dispose();
  }

  Future<void> loadWorkoutSets() async {
    await controller.loadWorkoutSets(
      widget.exerciseId,
    );

    if (!mounted) return;

    setState(() {});
  }

  Future<void> saveWorkoutSet() async {
    final error = await controller.saveWorkoutSet(
      exerciseId: widget.exerciseId,
      weightText: weightController.text,
      repetitionsText: repetitionsController.text,
    );

    if (!mounted) return;

    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error),
        ),
      );

      return;
    }

    weightController.clear();
    repetitionsController.clear();

    setState(() {});

    await loadWorkoutSets();
  }

  void editWorkoutSet(WorkoutSet workoutSet) {
    weightController.text = workoutSet.weight.toString();

    repetitionsController.text = workoutSet.repetitions.toString();

    controller.editWorkoutSet(
      workoutSet,
    );

    setState(() {});
  }

  Future<void> deleteWorkoutSet(WorkoutSet workoutSet) async {
    await controller.deleteWorkoutSet(workoutSet);

    await loadWorkoutSets();
  }

  void cancelEdit() {
    weightController.clear();
    repetitionsController.clear();

    controller.cancelEdit();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final groupedSets = controller.groupSetsByDate();

    final dates = groupedSets.keys.toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.exerciseName),

        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,

                MaterialPageRoute(
                  builder: (context) => StatisticsScreen(
                    exerciseId: widget.exerciseId,

                    exerciseName: widget.exerciseName,
                  ),
                ),
              );
            },

            icon: const Icon(
              Icons.bar_chart,
            ),
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Text(
              controller.editingSetId == null
                  ? 'Neuer Satz'
                  : 'Satz bearbeiten',

              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: weightController,

                    keyboardType: TextInputType.number,

                    decoration: const InputDecoration(
                      labelText: 'Gewicht (kg)',

                      border: OutlineInputBorder(),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: TextField(
                    controller: repetitionsController,

                    keyboardType: TextInputType.number,

                    decoration: const InputDecoration(
                      labelText: 'Wiederholungen',

                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: saveWorkoutSet,

                    child: Text(
                      controller.editingSetId == null
                          ? 'Satz speichern'
                          : 'Satz ändern',
                    ),
                  ),
                ),

                if (controller.editingSetId != null) ...[
                  const SizedBox(width: 8),

                  IconButton(
                    onPressed: cancelEdit,
                    icon: const Icon(
                      Icons.close,
                    ),
                  ),
                ],
              ],
            ),

            const SizedBox(height: 30),

            const Text(
              'Trainingsverlauf',

              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            Expanded(
              child: ListView.builder(
                itemCount: dates.length,

                itemBuilder: (context, index) {
                  final date = dates[index];

                  final List<WorkoutSet> sets = groupedSets[date]!;

                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          Text(
                            date,

                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(
                            height: 8,
                          ),

                          for (final workoutSet in sets)
                            Slidable(
                              key: ValueKey(
                                workoutSet.id,
                              ),

                              endActionPane: ActionPane(
                                motion: const DrawerMotion(),

                                children: [
                                  SlidableAction(
                                    onPressed: (context) {
                                      editWorkoutSet(
                                        workoutSet,
                                      );
                                    },

                                    backgroundColor: const Color.fromARGB(
                                      255,
                                      67,
                                      72,
                                      79,
                                    ),

                                    foregroundColor: Colors.white,

                                    icon: Icons.edit,

                                    label: 'Ändern',
                                  ),

                                  SlidableAction(
                                    onPressed: (context) {
                                      deleteWorkoutSet(
                                        workoutSet,
                                      );
                                    },

                                    backgroundColor: Colors.red,

                                    foregroundColor: Colors.white,

                                    icon: Icons.delete,

                                    label: 'Löschen',
                                  ),
                                ],
                              ),

                              child: Padding(
                                padding: const EdgeInsets.only(
                                  bottom: 4,
                                ),

                                child: ListTile(
                                  contentPadding: EdgeInsets.zero,

                                  title: Text(
                                    '${workoutSet.weight} kg × '
                                    '${workoutSet.repetitions}',
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
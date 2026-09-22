class WorkoutSet {
  final int id;
  final int exerciseId;
  final double weight;
  final int repetitions;
  final String date;

  WorkoutSet({
    required this.id,
    required this.exerciseId,
    required this.weight,
    required this.repetitions,
    required this.date,
  });

  factory WorkoutSet.fromMap(Map<String, dynamic> map) {
    return WorkoutSet(
      id: map['id'],
      exerciseId: map['exercise_id'],
      weight: map['weight'],
      repetitions: map['repetitions'],
      date: map['date'],
    );
  }
}
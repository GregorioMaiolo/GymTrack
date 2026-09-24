class Exercise {
  final int id;
  final String name;
  final String description;

  Exercise({
    required this.id,
    required this.name,
    required this.description,
  });

  // Factory-Methode, um eine Exercise-Instanz aus einer Map zu erstellen
  factory Exercise.fromMap(Map<String, dynamic> map) {
    return Exercise(
      id: map['id'],
      name: map['name'],
      description: map['description'] ?? '',
    );
  }
}

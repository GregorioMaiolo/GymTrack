import 'package:flutter/material.dart';

import 'screens/exercise_list_screen.dart';

void main() {
  runApp(
    MaterialApp(
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: ExerciseListScreen(),
    ),
  );
}
import 'package:flutter/material.dart';

class WorkoutScreen extends StatelessWidget {
  final String exerciseName;

  const WorkoutScreen({
    super.key,//IDE motzt ohne das
    required this.exerciseName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(exerciseName),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.bar_chart),
          ),
        ],
      ),

      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(
              'Neuer Satz',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 16),

            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Gewicht (kg)',
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 12),

            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Wiederholungen',
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                child: Text('Satz speichern'),
              ),
            ),

            SizedBox(height: 30),

            Text(
              'Trainingsverlauf',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 12),

            Card(
              child: ListTile(
                title: Text('17.09.2026'),
                subtitle: Text(
                  '60 kg × 8\n'
                  '60 kg × 7\n'
                  '55 kg × 10',
                ),
              ),
            ),

            Card(
              child: ListTile(
                title: Text('15.09.2026'),
                subtitle: Text(
                  '55 kg × 8\n'
                  '55 kg × 8\n'
                  '50 kg × 10',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
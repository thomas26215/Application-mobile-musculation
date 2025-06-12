import 'package:flutter/material.dart';
import 'package:unicons/unicons.dart';
import 'package:muscu/models/database_helper.dart';
import 'package:muscu/models/exercise/exercise.dart';

class SelectExistingExercisePage extends StatelessWidget {
  final DatabaseHelper dbHelper;
  final ValueChanged<int?> onExerciseSelected;

  const SelectExistingExercisePage({Key? key, required this.dbHelper, required this.onExerciseSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(72),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 40),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: Theme.of(context).colorScheme.primary,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop(null);
                    },
                    child: const Icon(
                      UniconsLine.angle_left,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    "Choisir un exercice",
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Container(
        color: Theme.of(context).colorScheme.primary, // Fond sombre pour le texte blanc
        child: FutureBuilder<List<Exercise>>(
          future: _fetchExercises(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text(
                  "Aucun exercice existant.",
                  style: TextStyle(color: Colors.white),
                ),
              );
            }
            final exercises = snapshot.data!;
            return ListView.separated(
              itemCount: exercises.length,
              separatorBuilder: (context, index) => const Divider(color: Colors.white24),
              itemBuilder: (context, index) {
                final exo = exercises[index];
                return ListTile(
                  title: Text(
                    exo.name,
                    style: const TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    exo.type.toString(),
                    style: const TextStyle(color: Colors.white70),
                  ),
                  onTap: () {
                    onExerciseSelected(exo.id);
                    Navigator.of(context).pop(exo);
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }

  Future<List<Exercise>> _fetchExercises() async {
    return await ExerciseTable.getAllExercises(dbHelper);
  }
}


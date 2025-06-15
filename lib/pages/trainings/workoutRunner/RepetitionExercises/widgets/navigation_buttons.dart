import 'package:flutter/material.dart';
import 'package:muscu/models/seance/seance.dart';
import 'package:muscu/pages/trainings/workoutRunner/Pause/main.dart';
import 'package:muscu/pages/trainings/workoutRunner/datas/ActualExercise.dart';

class NavigationButtons extends StatelessWidget {
  final ActualExercise? actual;
  final Session? session;
  final int initialSeconds;

  const NavigationButtons({
    super.key,
    this.actual,
    this.session,
    this.initialSeconds = 60, // Correction ici
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 10, right: 5),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                // Action pour le bouton "Failed"
              },
              child: const Text(
                'Failed',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 5, right: 10),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PausePage(
                      actualExercise: actual,
                      session: session,
                      initialSeconds: initialSeconds, // Correction ici
                    ),
                  ),
                );
              },
              child: const Text(
                'Successed',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}


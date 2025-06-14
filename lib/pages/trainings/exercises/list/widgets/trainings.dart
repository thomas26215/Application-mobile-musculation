import 'package:flutter/material.dart';
import 'package:muscu/models/exercise/exercise.dart';
import 'package:muscu/models/seance/seance.dart';
import 'package:muscu/pages/trainings/sessions/detailsTraining/main.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class ExercisesWidget extends StatefulWidget {
  final List<Exercise> filteredExercises;

  const ExercisesWidget({Key? key, required this.filteredExercises}) : super(key: key);

  @override
  _ExercisesWidgetState createState() => _ExercisesWidgetState();
}

class _ExercisesWidgetState extends State<ExercisesWidget> {
  /*void _onTrainingTap(Exercise session) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DetailPage(session: session)),
    );
  }*/

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.filteredExercises.length,
      itemBuilder: (context, index) {
        final session = widget.filteredExercises[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
          child: InkWell(
            //onTap: () => _onTrainingTap(session),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(6),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 3,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Icon(FontAwesomeIcons.dumbbell, size: 24, color: Colors.white70),
                    SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                session.name,
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white)
                              ),
                              Text(
                                session.type ?? 'Non spécifié',
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white)
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.secondary,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.history, color: Colors.black, size: 16),
                                    const SizedBox(width: 2),
                                    Text("Historique", style: TextStyle(fontSize: 12, color: Colors.black)),
                                  ],
                                ),
                              ),
                              Text(
                                //DateFormat('dd/MM/yyyy').format(session.createdAt),
                                "test",
                                style: TextStyle(fontSize: 12, color: Colors.white70)
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}


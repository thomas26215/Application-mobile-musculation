import 'package:flutter/material.dart';
import 'package:muscu/models/seance/seance.dart';
import 'package:muscu/models/seance/session_exercise.dart';
import 'package:muscu/pages/trainings/workoutRunner/datas/ActualExercise.dart';
import 'package:muscu/styles/text_styles.dart';

class GlobalIndications extends StatelessWidget {

    final ActualExercise actualExercise;
    final Session session;
    final SessionExercise sessionExercise;

    const GlobalIndications({super.key, required this.actualExercise, required this.session, required this.sessionExercise});

    @override
    Widget build(BuildContext context) {

        int numeroSerie = actualExercise.numeroSerie;
        int? totalSeries = sessionExercise.sets;
        int? repetitions = sessionExercise.reps;
        double? charge = sessionExercise.weight;

        return Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.5), // Augmentation de l'opacité
                            offset: Offset(0, 4), // Légère augmentation du décalage vertical
                            blurRadius: 15,
                            spreadRadius: 4, // Ajout d'un spreadRadius
                        ),
                    ],
                ),
                child: Padding(
                   padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15), 
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                            Column(
                                children: [
                                    Text(
                                        "Series",
                                        style: AppTextStyles.titleMedium.copyWith(fontSize: 20),
                                    ),
                                    Text(
                                        "$numeroSerie/$totalSeries",
                                        style: AppTextStyles.titleMedium.copyWith(fontSize: 20),
                                    ),
                                ],
                            ),
                            Column(
                                children: [
                                    Text(
                                        "Répétitions",
                                        style: AppTextStyles.titleMedium.copyWith(fontSize: 20),
                                    ),
                                    Text(
                                        "$repetitions",
                                        style: AppTextStyles.titleMedium.copyWith(fontSize: 20),
                                    ),
                                ],
                            ),
                            Column(
                                children: [
                                    Text(
                                        "Charge",
                                        style: AppTextStyles.titleMedium.copyWith(fontSize: 20),
                                    ),
                                    Text(
                                        "$charge",
                                        style: AppTextStyles.titleMedium.copyWith(fontSize: 20),
                                    ),
                                ],
                            ),
                        ],
                    ),
                ),
            )
        );
    }
}


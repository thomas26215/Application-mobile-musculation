import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:muscu/models/exercise/exercise.dart';
import 'package:muscu/models/seance/seance.dart';
import 'package:muscu/models/seance/session_exercise.dart';
import 'package:muscu/pages/trainings/workoutRunner/RepetitionExercises/widgets/demonstration.dart';
import 'package:muscu/pages/trainings/workoutRunner/RepetitionExercises/widgets/globals_indications.dart';
import 'package:muscu/pages/trainings/workoutRunner/RepetitionExercises/widgets/explications_text.dart';
import 'package:muscu/pages/trainings/workoutRunner/RepetitionExercises/widgets/navigation_buttons.dart';
import 'package:muscu/pages/trainings/workoutRunner/datas/ActualExercise.dart';
import 'package:muscu/styles/text_styles.dart';
import 'package:unicons/unicons.dart';

class RepetitionsExercise extends StatelessWidget {
    final Session session;
    final ActualExercise actualExercise;
    final SessionExercise sessionExercise;
    final Exercise? exercise;

    const RepetitionsExercise({
        super.key,
        required this.session,
        required this.actualExercise,
        required this.sessionExercise,
        this.exercise
    });

    @override
    Widget build(BuildContext context) {
        String? nameExercise = exercise?.name;
        return Scaffold(
            body: Column(
                children: [
                    Padding(
                        padding: EdgeInsets.only(left: 20, right: 20, top: 20),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                                GestureDetector(
                                    onTap: () {
                                        Navigator.pop(context);
                                    },
                                    child: Icon(
                                        UniconsLine.angle_left,
                                        color: Colors.white,
                                        size: 50,
                                    ),
                                ),
                                Text(
                                    "FullBody",
                                    style: AppTextStyles.titleMedium.copyWith(fontSize: 20),
                                ),
                                Icon(
                                    UniconsLine.setting,
                                    color: Colors.white,
                                    size: 35,
                                ),
                            ],
                        ),
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                            Text(
                                "$nameExercise",
                                style: AppTextStyles.titleMedium.copyWith(fontSize: 17),
                            ),
                        ],
                    ),
                    SizedBox(height: 20),
                    GlobalIndications(actualExercise: actualExercise, session: session, sessionExercise: sessionExercise,),
                    SizedBox(height: 20),
                    if(exercise?.videoURL != null)Demonstration(videoLink: exercise?.videoURL,),
                    SizedBox(height: 30),
                    if(exercise?.description != null)ExplicationsText(
                        exerciseDescription: exercise?.description ?? "",
                    ),
                    SizedBox(height: 10),
                    NavigationButtons(
                        actual: actualExercise,
                        session: session,
                        initialSeconds: sessionExercise.pause ?? 60, // Correction ici
                    ),
                    SizedBox(height: 10),
                ],
            ),
        );
    }
}


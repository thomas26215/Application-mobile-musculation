import 'package:flutter/material.dart';
import 'package:muscu/pages/trainings/workoutRunner/RepetitionExercises/widgets/demonstration.dart';
import 'package:muscu/pages/trainings/workoutRunner/RepetitionExercises/widgets/globals_indications.dart';
import 'package:muscu/pages/trainings/workoutRunner/RepetitionExercises/widgets/explications_text.dart';
import 'package:muscu/pages/trainings/workoutRunner/RepetitionExercises/widgets/navigation_buttons.dart';
import 'package:muscu/styles/text_styles.dart';
import 'package:unicons/unicons.dart';

class RepetitionsExercise extends StatelessWidget {
    final List<Map<String, dynamic>> exercises;

    const RepetitionsExercise({
        super.key,
        required this.exercises,
    });

    @override
    Widget build(BuildContext context) {
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
                                "coucou",
                                style: AppTextStyles.titleMedium.copyWith(fontSize: 17),
                            ),
                        ],
                    ),
                    SizedBox(height: 20),
                    GlobalIndications(),
                    SizedBox(height: 20),
                    Demonstration(),
                    SizedBox(height: 30),
                    ExplicationsText(),
                    SizedBox(height: 10),
                    NavigationButtons(),
                    SizedBox(height: 10),
                ],
            ),
        );
    }
}


import 'package:flutter/material.dart';
import 'package:muscu/models/database_helper.dart';
import 'package:muscu/models/seance/seance.dart';
import 'package:muscu/models/seance/session_exercise.dart';
import 'package:muscu/pages/trainings/sessions/addNewTraining/widgets/header.dart';
import 'package:muscu/utils/snackbar_helper.dart';
import 'package:unicons/unicons.dart';
import 'package:muscu/pages/trainings/sessions/addNewTraining/widgets/note.dart';
import 'package:muscu/pages/trainings/sessions/addNewTraining/globalSettings/main.dart';
import 'package:muscu/pages/trainings/sessions/addNewTraining/exercisesList/main.dart';
import 'package:muscu/pages/trainings/sessions/addNewTraining/exercisesList/donnees/exercise.dart';
import 'package:muscu/pages/trainings/sessions/addNewTraining/exercisesList/donnees/exerciseType.dart';
import 'package:muscu/pages/trainings/sessions/addNewTraining/exercisesList/donnees/exerciseSet.dart';

class AddNewTrainingPage extends StatefulWidget {
    final int? sessionId;
    const AddNewTrainingPage({Key? key, this.sessionId}) : super(key: key);

    @override
    _AddNewTrainingPageState createState() => _AddNewTrainingPageState();
}

class _AddNewTrainingPageState extends State<AddNewTrainingPage> with TickerProviderStateMixin {

    String trainingName = "";
    List<ExerciseToAdd> exercises = [];

    final dbHelper = DatabaseHelper.instance;

    Map<String, dynamic> trainingParameters = {
        'type': 'Full Body',
        'duration': 60,
        'difficulty': 'Intermédiaire',
    };

    late AnimationController _controller;
    late Animation<double> _buttonScaleAnimation;
    late Animation<double> _iconRotationAnimation;
    late Animation<Color?> _colorAnimation;

    @override
    void initState() {
        super.initState();
        _controller = AnimationController(
            duration: Duration(milliseconds: 500),
            vsync: this,
        );

        _buttonScaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
            CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
        );

        _iconRotationAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
        );

        _colorAnimation = ColorTween(
            begin: Color(0xFF006400), // Vert foncé
            end: Colors.greenAccent,
        ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

        WidgetsBinding.instance.addPostFrameCallback((_) {
            _edit();
        });
    }

    @override
    void dispose() {
        _controller.dispose();
        super.dispose();
    }

void _edit() {
    if (widget.sessionId != null) {
        showCustomNotification(
            context,
            "Édition de la séance ${widget.sessionId}",
            type: SnackBarType.info,
        );

        // Récupère la session et ses exercices associés
        SessionTable.getSessionById(dbHelper, widget.sessionId!).then((session) {
            if (session != null) {
                setState(() {
                    trainingName = session.name;
                });

                SessionExerciseTable.getSessionExercisesBySessionId(dbHelper, widget.sessionId!).then((sessionExercises) {
                    setState(() {
                        exercises = sessionExercises.map((se) {
                            // Conversion SessionExercise → ExerciseToAdd
                            return ExerciseToAdd(
                                id: se.exerciseId,
                                recuperation: se.restTime,
                                sets: [
                                    ExerciseSet(
                                        reps: se.reps,
                                        weight: se.weight,
                                        duration: se.duration,
                                        pause: se.pause, // Ajoute le champ pause si nécessaire
                                        // Ajoute d'autres champs si besoin
                                    ),
                                ],
                                type: ExerciseType.values.firstWhere(
                                    (et) => et.toString().split('.').last == se.exerciseType,
                                    orElse: () => ExerciseType.standard,
                                ),
                                numberOfSets: se.sets,
                            );
                        }).toList();
                    });
                });
            }
        });
    }
}


    @override
    Widget build(BuildContext context) {
        return Scaffold(
            body: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 50),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        Header(
                            trainingName: trainingName,
                            onChanged: (value) {
                                setState(() {
                                    trainingName = value;
                                });
                            },
                        ),
                        SizedBox(height: 20),
                        GestureDetector(
                            onTap: () async {
                                final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => EditTrainingParametersPage(
                                        initialParameters: trainingParameters,
                                    )),
                                );
                                if (result != null) {
                                    setState(() {
                                        trainingParameters = result;
                                    });
                                }
                            },
                            child: Container(
                                padding: EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.secondary,
                                    borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                        Text(
                                            "Paramètres généraux",
                                            style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.black),
                                        ),
                                        Icon(
                                            Icons.arrow_forward_ios,
                                            color: Colors.black,
                                        ),
                                    ],
                                ),
                            ),
                        ),
                        SizedBox(height: 20),
                        NoteWidget(),
                        SizedBox(height: 20),
                        Expanded(
                            child: ExerciseWidget(exercises: exercises, dbHelper: DatabaseHelper.instance),
                        ),
                        SizedBox(height: 15),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                                Expanded(
                                    flex: 6,
                                    child: ElevatedButton.icon(
                                        onPressed: () {
                                            setState(() {
                                                exercises.add(ExerciseToAdd.createExercise(1, "test", [ExerciseSet(reps: 10, weight: 5)], 60, ExerciseType.standard));
                                            });
                                        },
                                        icon: Icon(Icons.add, color: Colors.white),
                                        label: Text(
                                            "Add exercise",
                                            style: Theme.of(context).textTheme.displayMedium,
                                        ),
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Theme.of(context).colorScheme.primary,
                                            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(10),
                                            ),
                                        ),
                                    ),
                                ),
                                SizedBox(width: 20),
                                Expanded(
                                    flex: 4,
                                    child: AnimatedBuilder(
                                        animation: _controller,
                                        builder: (context, child) {
                                            return Transform.scale(
                                                scale: _buttonScaleAnimation.value,
                                                child: ElevatedButton.icon(
                                                    onPressed: () async {
                                                    _controller.forward().then((value) {
                                                        _controller.reverse();
                                                    });
                                                    if (trainingName.isEmpty) {
                                                        showCustomNotification(context, "Please enter a training name.", type: SnackBarType.error);
                                                        return;
                                                    } else if (exercises.isEmpty) {
                                                        showCustomNotification(context, "Please add at least one exercise.", type: SnackBarType.error);
                                                        return;
                                                    } else {
                                                        final session = Session(
                                                            id: widget.sessionId, // important pour l'update
                                                            name: trainingName,
                                                            type: "Standard",
                                                            description: "A new training session",
                                                        );

                                                        int sessionIdToUse;

                                                        if (widget.sessionId != null) {
                                                            // UPDATE de la session existante
                                                            await SessionTable.update(dbHelper, session); // Il te faut une méthode update
                                                            sessionIdToUse = widget.sessionId!;
                                                            // Supprime les anciens exercices liés à cette session
                                                            await SessionExerciseTable.deleteBySessionId(dbHelper, sessionIdToUse);
                                                        } else {
                                                            // INSERT d'une nouvelle session
                                                            sessionIdToUse = await SessionTable.insert(dbHelper, session);
                                                        }

                                                        // Ajoute tous les exercices de la liste locale à la session
                                                        for (var exercise in exercises) {
                                                            final newExercise = SessionExercise(
                                                                sessionId: sessionIdToUse,
                                                                exerciseId: exercise.id,
                                                                orderInSession: exercises.indexOf(exercise),
                                                                sets: exercise.numberOfSets ?? exercise.sets.length,
                                                                reps: exercise.sets.first.reps,
                                                                duration: exercise.sets.first.duration ?? 0, // Ajoute le champ duration si nécessaire
                                                                restTime: exercise.recuperation,
                                                                pause: exercise.sets.first.pause ?? 0, // Ajoute le champ pause si nécessaire
                                                                weight: exercise.sets.first.weight,
                                                                exerciseType: ExerciseType.standard,
                                                            );
                                                            await SessionExerciseTable.insert(dbHelper, newExercise);
                                                        }

                                                        showCustomNotification(context, "Séance sauvegardée !", type: SnackBarType.success);
                                                    }
                                                },

                                                    icon: AnimatedBuilder(
                                                        animation: _iconRotationAnimation,
                                                        builder: (context, child) {
                                                            return Transform.rotate(
                                                                angle: _iconRotationAnimation.value * 2 * 3.1416,
                                                                child: Icon(Icons.save, color: Colors.white),
                                                            );
                                                        },
                                                    ),
                                                    label: Text(
                                                        "Save",
                                                        style: Theme.of(context).textTheme.displayMedium,
                                                    ),
                                                    style: ElevatedButton.styleFrom(
                                                        backgroundColor: _colorAnimation.value,
                                                        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(10),
                                                        ),
                                                    ),
                                                ),
                                            );
                                        },
                                    ),
                                ),
                            ],
                        ),
                        SizedBox(height: 15),
                    ],
                ),
            ),
        );
    }
}


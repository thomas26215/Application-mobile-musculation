import 'package:flutter/material.dart';
import 'package:muscu/pages/trainings/sessions/addNewTraining/exercisesList/selectExercise/main.dart';
import 'package:muscu/styles/text_styles.dart';
import 'package:unicons/unicons.dart';
import 'package:muscu/pages/trainings/sessions/addNewTraining/exercisesList/donnees/exerciseType.dart';
import 'package:muscu/pages/trainings/sessions/addNewTraining/exercisesList/donnees/exercise.dart';
import 'package:muscu/pages/trainings/sessions/addNewTraining/exercisesList/widgets/setWidget.dart';
import 'package:muscu/models/database_helper.dart';
import 'package:muscu/models/exercise/exercise.dart';

class ExerciseWidget extends StatefulWidget {
  final List<ExerciseToAdd> exercises;
  final DatabaseHelper dbHelper;
  const ExerciseWidget({Key? key, required this.exercises, required this.dbHelper}) : super(key: key);

  @override
  _ExerciseWidgetState createState() => _ExerciseWidgetState();
}

class _ExerciseWidgetState extends State<ExerciseWidget> {
  @override
  Widget build(BuildContext context) {
    return ReorderableListView.builder(
      itemCount: widget.exercises.length,
      itemBuilder: (context, index) {
        return Padding(
          key: ValueKey(widget.exercises[index]),
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
          child: ExerciseCard(
            exercise: widget.exercises[index],
            dbHelper: widget.dbHelper,
            onUpdate: () => setState(() {}),
            onDelete: () {
              setState(() {
                widget.exercises.removeAt(index);
              });
            },
            onExerciseSelectedCard: (int? exerciseId) {
              setState(() {
                if (exerciseId != null) {
                  widget.exercises[index].id = exerciseId;
                  // Mettre à jour d'autres champs si nécessaire
                }
              });
            }
          ),
        );
      },
      onReorder: (oldIndex, newIndex) {
        setState(() {
          if (oldIndex < newIndex) {
            newIndex -= 1;
          }
          final ExerciseToAdd item = widget.exercises.removeAt(oldIndex);
          widget.exercises.insert(newIndex, item);
        });
      },
      proxyDecorator: (Widget child, int index, Animation<double> animation) {
        return AnimatedBuilder(
          animation: animation,
          builder: (BuildContext context, Widget? child) {
            return Material(
              elevation: 0,
              color: Colors.transparent,
              child: child,
            );
          },
          child: child,
        );
      },
    );
  }
}

class ExerciseCard extends StatefulWidget {
  final ExerciseToAdd exercise;
  final DatabaseHelper dbHelper;
  final VoidCallback onUpdate;
  final VoidCallback onDelete;
  final ValueChanged<int?>? onExerciseSelectedCard;

  const ExerciseCard({
    Key? key,
    required this.exercise,
    required this.dbHelper,
    required this.onUpdate,
    required this.onDelete,
    required this.onExerciseSelectedCard,
  }) : super(key: key);

  @override
  State<ExerciseCard> createState() => _ExerciseCardState();
}

class _ExerciseCardState extends State<ExerciseCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- MODIFIÉ : Bloc vert + Dropdown sur la même ligne ---
            Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Row(
                children: [
                  // Bloc vert qui prend toute la place disponible à gauche
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        final selectedExercise = await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => SelectExistingExercisePage(
                              dbHelper: widget.dbHelper,
                              onExerciseSelected: (int? exerciseId) {
                                if (widget.onExerciseSelectedCard != null) {
                                  widget.onExerciseSelectedCard!(exerciseId);
                                }
                              },
                            ),
                          ),
                        );
                        if (selectedExercise != null && selectedExercise is ExerciseToAdd) {
                          setState(() {
                            widget.exercise.id = selectedExercise.id;
                            widget.exercise.type = selectedExercise.type;
                          });
                          widget.onUpdate();
                        }
                      },
                      child: Container(
                        constraints: const BoxConstraints(
                          minWidth: 80,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          border: Border.all(color: Colors.black, width: 2),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.25),
                              blurRadius: 8,
                              offset: const Offset(2, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            const Icon(Icons.edit, color: Colors.white, size: 22),
                            const SizedBox(width: 10),
                            Flexible(
                              child: FutureBuilder<Exercise?>(
                                future: widget.exercise.id != null
                                    ? ExerciseTable.getExerciseById(widget.dbHelper, widget.exercise.id!)
                                    : Future.value(null),
                                builder: (context, snapshot) {
                                  String displayName = "Exercice inconnu";
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    displayName = "Chargement...";
                                  } else if (snapshot.hasData && snapshot.data != null) {
                                    displayName = snapshot.data!.name;
                                  }
                                  return Text(
                                    displayName,
                                    style: AppTextStyles.titleMedium.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.none,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Dropdown à droite avec largeur fixe
                  SizedBox(
                    width: 160,
                    child: Container(
                      height: 35,
                      decoration: BoxDecoration(
                        color: Colors.blueGrey[800],
                        borderRadius: BorderRadius.circular(4),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 6,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: DropdownButton<ExerciseType>(
                        value: widget.exercise.type,
                        dropdownColor: Colors.blueGrey[900],
                        icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                        underline: const SizedBox(),
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                        isExpanded: true,
                        hint: const Text('Sélectionnez', style: TextStyle(color: Colors.white70)),
                        items: ExerciseType.values.map((ExerciseType value) {
                          return DropdownMenuItem<ExerciseType>(
                            value: value,
                            child: Text(
                              _getExerciseTypeString(value),
                              style: const TextStyle(color: Colors.white),
                            ),
                          );
                        }).toList(),
                        onChanged: (ExerciseType? newValue) {
                          if (newValue != null) {
                            setState(() {
                              widget.exercise.type = newValue;
                            });
                            widget.onUpdate();
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),
            ...widget.exercise.sets.map((set) => SetWidget(
              exercise: widget.exercise,
              set: set,
              onUpdate: widget.onUpdate,
              onDelete: widget.onDelete,
              exerciseType: widget.exercise.type,
              onSetUpdated: () {
                setState(() {});
              })).toList(),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  String _getExerciseTypeString(ExerciseType type) {
    switch (type) {
      case ExerciseType.standard:
        return "Standard";
      // Ajoute d'autres cas si tu as d'autres types
      default:
        return "Standard";
    }
  }
}


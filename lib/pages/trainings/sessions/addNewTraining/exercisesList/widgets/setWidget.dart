import 'package:flutter/material.dart';
import 'package:muscu/pages/trainings/sessions/addNewTraining/exercisesList/donnees/exerciseType.dart';
import 'package:muscu/pages/trainings/sessions/addNewTraining/exercisesList/donnees/exerciseSet.dart';
import 'package:muscu/pages/trainings/sessions/addNewTraining/exercisesList/donnees/exercise.dart';
import 'package:muscu/styles/text_styles.dart';
import 'package:unicons/unicons.dart';

class SetWidget extends StatefulWidget {
  final ExerciseToAdd exercise;
  final ExerciseSet set;
  final VoidCallback onUpdate;
  final VoidCallback onDelete;
  final ExerciseType exerciseType;
  final VoidCallback onSetUpdated;

  const SetWidget({
    Key? key,
    required this.exercise,
    required this.set,
    required this.onUpdate,
    required this.onDelete,
    required this.exerciseType,
    required this.onSetUpdated,
  }) : super(key: key);

  @override
  State<SetWidget> createState() => _SetWidgetState();
}

class _SetWidgetState extends State<SetWidget> {
  late TextEditingController _repsController;
  late TextEditingController _durationController;
  late TextEditingController _weightController;
  late TextEditingController _exerciseNameController;
  late TextEditingController _pauseController;
  late TextEditingController _recuperationController;
  late TextEditingController _numberOfSetsController; // Ajouté

  @override
  void initState() {
    super.initState();
    _repsController = TextEditingController(text: widget.set.reps?.toString() ?? '');
    _durationController = TextEditingController(text: widget.set.duration?.toString() ?? '');
    _weightController = TextEditingController(text: widget.set.weight?.toString() ?? '');
    _exerciseNameController = TextEditingController(text: widget.set.exerciseName ?? '');
    _pauseController = TextEditingController(text: widget.set.pause?.toString() ?? '');
    _recuperationController = TextEditingController(text: widget.exercise.recuperation?.toString() ?? '');
    _numberOfSetsController = TextEditingController(text: widget.exercise.numberOfSets?.toString() ?? ''); // Ajouté
  }

  @override
  void dispose() {
    _repsController.dispose();
    _durationController.dispose();
    _weightController.dispose();
    _exerciseNameController.dispose();
    _pauseController.dispose();
    _recuperationController.dispose();
    _numberOfSetsController.dispose(); // Ajouté
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Vérification du type avant la construction du Row
    if (widget.exerciseType != ExerciseType.standard) {
      return Container();
    }

    return Container(
      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Column(
        children: [
          SizedBox(
            height: 50,
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: TextField(
                      controller: _repsController,
                      keyboardType: TextInputType.number,
                      style: AppTextStyles.titleMedium,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Répétitions",
                        labelStyle: AppTextStyles.bodySmall,
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                            width: 3.0,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey,
                            width: 2.0,
                          ),
                        ),
                      ),
                      onChanged: (value) {
                        widget.set.reps = int.tryParse(value);
                        widget.onUpdate();
                        widget.onSetUpdated();
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    child: TextField(
                      controller: _weightController,
                      keyboardType: TextInputType.number,
                      style: AppTextStyles.titleMedium,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Poids",
                        labelStyle: AppTextStyles.bodySmall,
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                            width: 3.0,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey,
                            width: 2.0,
                          ),
                        ),
                      ),
                      onChanged: (value) {
                        widget.set.weight = double.tryParse(value);
                        widget.onUpdate();
                        widget.onSetUpdated();
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: TextField(
                      controller: _durationController,
                      keyboardType: TextInputType.number,
                      style: AppTextStyles.titleMedium,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Durée",
                        labelStyle: AppTextStyles.bodySmall,
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                            width: 3.0,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey,
                            width: 2.0,
                          ),
                        ),
                      ),
                      onChanged: (value) {
                        widget.set.duration = int.tryParse(value);
                        widget.onUpdate();
                        widget.onSetUpdated();
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: TextField(
                      controller: _numberOfSetsController, // Correction ici
                      keyboardType: TextInputType.number,
                      style: AppTextStyles.titleMedium,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Nombres de séries",
                        labelStyle: AppTextStyles.bodySmall,
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                            width: 3.0,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey,
                            width: 2.0,
                          ),
                        ),
                      ),
                      onChanged: (value) {
                        widget.exercise.numberOfSets = int.tryParse(value);
                        widget.onUpdate();
                        widget.onSetUpdated();
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          SizedBox(
            height: 50,
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: TextField(
                      controller: _pauseController,
                      keyboardType: TextInputType.number,
                      style: AppTextStyles.titleMedium,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Pause",
                        labelStyle: AppTextStyles.bodySmall,
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                            width: 3.0,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey,
                            width: 2.0,
                          ),
                        ),
                      ),
                      onChanged: (value) {
                        widget.set.pause = int.tryParse(value);
                        widget.onUpdate();
                        widget.onSetUpdated();
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: TextField(
                      controller: _recuperationController,
                      keyboardType: TextInputType.number,
                      style: AppTextStyles.titleMedium,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Recuperation",
                        labelStyle: AppTextStyles.bodySmall,
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                            width: 3.0,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey,
                            width: 2.0,
                          ),
                        ),
                      ),
                      onChanged: (value) {
                        widget.exercise.recuperation = int.tryParse(value);
                        widget.onUpdate();
                        widget.onSetUpdated();
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 50,
                  child: GestureDetector(
                    onTap: () {
                      widget.onDelete();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Row(
                          children: [
                            SizedBox(width: 5),
                            Text(
                              "Supprimer l'exo",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Icon(
                              UniconsLine.trash_alt,
                              color: Colors.white,
                            ),
                            SizedBox(width: 2),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}


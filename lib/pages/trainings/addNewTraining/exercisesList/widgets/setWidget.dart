import 'package:flutter/material.dart';
import 'package:muscu/pages/trainings/addNewTraining/exercisesList/donnees/exerciseType.dart';
import 'package:muscu/pages/trainings/addNewTraining/exercisesList/donnees/exerciseSet.dart';
import 'package:muscu/styles/text_styles.dart';
import 'package:unicons/unicons.dart';

class SetWidget extends StatefulWidget {
    final ExerciseSet set;
    final VoidCallback onUpdate;
    final VoidCallback onDelete;
    final ExerciseType exerciseType;
    final VoidCallback onSetUpdated;

    const SetWidget({
        Key? key,
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

    @override
    void initState() {
        super.initState();
        _repsController = TextEditingController(text: widget.set.reps?.toString() ?? '');
        _durationController = TextEditingController(text: widget.set.duration?.toString() ?? '');
        _weightController = TextEditingController(text: widget.set.weight?.toString() ?? '');
        _exerciseNameController = TextEditingController(text: widget.set.exerciseName ?? '');
    }

    @override
    void dispose() {
        _repsController.dispose();
        _durationController.dispose();
        _weightController.dispose();
        _exerciseNameController.dispose();
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
                    Row(
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
                        ],
                    ),
                    SizedBox(height: 10),
                    Row(
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
                                            widget.set.reps = int.tryParse(value);
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
                                        controller: _repsController,
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
                                            widget.set.reps = int.tryParse(value);
                                            widget.onUpdate();
                                            widget.onSetUpdated();
                                        },
                                    ),
                                ),
                            ),
                            SizedBox(
                                height: 56,
                                child: GestureDetector(
                                    onTap: (){
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
                                                    Icon(Icons.delete, color: Colors.white),
                                                    SizedBox(width: 2),
                                                ],
                                            ),
                                        ),
                                    ),
                                ),
                            )
                            
                        ],
                    )
                ],
            ),
        );
    }
}


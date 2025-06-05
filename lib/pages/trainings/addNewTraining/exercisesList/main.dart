import 'package:flutter/material.dart';
import 'package:muscu/styles/text_styles.dart';
import 'package:unicons/unicons.dart';
import 'package:muscu/pages/trainings/addNewTraining/exercisesList/donnees/exerciseType.dart';
import 'package:muscu/pages/trainings/addNewTraining/exercisesList/donnees/exercise.dart';
import 'package:muscu/pages/trainings/addNewTraining/exercisesList/widgets/setWidget.dart';



class ExerciseWidget extends StatefulWidget {
    final List<Exercise> exercises;
    const ExerciseWidget({Key? key, required this.exercises}) : super(key: key);

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
                        onUpdate: () => setState(() {}),
                        onDelete: () {
                            setState(() {
                                widget.exercises.removeAt(index);
                            });
                        },
                    ),
                );
            },
            onReorder: (oldIndex, newIndex) {
                setState(() {
                    if (oldIndex < newIndex) {
                        newIndex -= 1;
                    }
                    final Exercise item = widget.exercises.removeAt(oldIndex);
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
    final Exercise exercise;
    final VoidCallback onUpdate;
    final VoidCallback onDelete;

    const ExerciseCard({
        Key? key,
        required this.exercise,
        required this.onUpdate,
        required this.onDelete,
    }) : super(key: key);

    @override
    State<ExerciseCard> createState() => _ExerciseCardState();
}

class _ExerciseCardState extends State<ExerciseCard> {
    //late TextEditingController _restTimeController;

    @override
    void initState() {
        super.initState();
        //_restTimeController = TextEditingController(text: widget.exercise.restTime.toString());
    }

    @override
    void dispose() {
        //_restTimeController.dispose();
        super.dispose();
    }

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
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                                Expanded(
                                    child: Text(
                                        widget.exercise.name,
                                        style: AppTextStyles.titleMedium,
                                        overflow: TextOverflow.ellipsis,
                                    ),
                                ),
                                DropdownButton<ExerciseType>(
                                    value: widget.exercise.type,
                                    onChanged: (ExerciseType? newValue) {
                                        if (newValue != null) {
                                            setState(() {
                                                widget.exercise.type = newValue;
                                                widget.onUpdate();
                                            });
                                        }
                                    },
                                    items: ExerciseType.values.map<DropdownMenuItem<ExerciseType>>((ExerciseType value) {
                                        return DropdownMenuItem<ExerciseType>(
                                            value: value,
                                            child: Text(_getExerciseTypeString(value)),
                                        );
                                    }).toList(),
                                ),
                            ],
                        ),
                        SizedBox(height: 8),
                        ...widget.exercise.sets.map((set) => SetWidget(
                            set: set,
                            onUpdate: widget.onUpdate,
                            onDelete: widget.onDelete,
                            exerciseType: widget.exercise.type,
                            onSetUpdated: () {
                                setState(() {});
                            })).toList(),
                        SizedBox(height: 8),
                    ],
                ),
            ),
        );
    }

    String _getExerciseTypeString(ExerciseType type) {
        switch (type) {

            case ExerciseType.standard:
                return "Standard";
            default:
                return "Standard";
        }
    }


}


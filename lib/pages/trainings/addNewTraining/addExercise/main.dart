import 'package:flutter/material.dart';
import 'package:muscu/styles/text_styles.dart';
import 'package:unicons/unicons.dart';

enum ExerciseType {
    standard,
    dropSet,
    pyramid,
    timeUnderTension,
    superSet,
    giantSet,
    restPause,
    cluster,
}

class Exercise {
    String name;
    String? equipment;
    List<ExerciseSet> sets;
    int restTime;
    ExerciseType type;

    Exercise({
        required this.name,
        this.equipment,
        required this.sets,
        required this.restTime,
        required this.type,
    });
}

class ExerciseSet {
    int? reps;
    int? duration;
    double? weight;
    String? exerciseName;

    ExerciseSet({this.reps, this.duration, this.weight, this.exerciseName});
}

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
    late TextEditingController _restTimeController;

    @override
    void initState() {
        super.initState();
        _restTimeController = TextEditingController(text: widget.exercise.restTime.toString());
    }

    @override
    void dispose() {
        _restTimeController.dispose();
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
                        if (widget.exercise.equipment != null)
                            Text(
                                "Équipement: ${widget.exercise.equipment}",
                                style: AppTextStyles.bodySmall,
                                overflow: TextOverflow.ellipsis,
                            ),
                        SizedBox(height: 8),
                        ...widget.exercise.sets.map((set) => SetWidget(
                            set: set,
                            onUpdate: widget.onUpdate,
                            exerciseType: widget.exercise.type,
                            onSetUpdated: () {
                                setState(() {});
                            })).toList(),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                                Container(
                                    padding: EdgeInsets.symmetric(horizontal: 7, vertical: 4),
                                    child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                            SizedBox(width: 7),
                                            SizedBox(
                                                width: 120,
                                                child: TextField(
                                                    controller: _restTimeController,
                                                    keyboardType: TextInputType.number,
                                                    style: AppTextStyles.titleMedium,
                                                    decoration: InputDecoration(
                                                        border: OutlineInputBorder(),
                                                        labelText: "Duration",
                                                        prefixIcon: Icon(UniconsLine.clock, color: Colors.white70, size: 20),
                                                        labelStyle: AppTextStyles.bodySmall,
                                                        focusedBorder: OutlineInputBorder( // Bordure quand le champ est sélectionné
                                                            borderSide: BorderSide(
                                                                color: Colors.white,
                                                                width: 3.0,
                                                            ),
                                                        ),
                                                        enabledBorder: OutlineInputBorder( // Bordure quand le champ est inactif
                                                            borderSide: BorderSide(
                                                                color: Colors.grey,
                                                                width: 2.0,
                                                            ),
                                                        ),
                                                    ),
                                                    onChanged: (value) {
                                                        int? newRestTime = int.tryParse(value);
                                                        if (newRestTime != null) {
                                                            widget.exercise.restTime = newRestTime;
                                                            widget.onUpdate();
                                                        }
                                                    },
                                                ),
                                            ),
                                        ],
                                    ),
                                ),
                            ],
                        ),
                        SizedBox(height: 8),
                        if (widget.exercise.type != ExerciseType.standard)
                            Row(
                                children: [
                                    Expanded(
                                        flex: 7,
                                        child: ElevatedButton(
                                            onPressed: () => _showAddSetDialog(context),
                                            child: Text("Ajouter une série"),
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor: Theme.of(context).colorScheme.secondary,
                                                foregroundColor: Theme.of(context).colorScheme.onSecondary,
                                                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(8),
                                                ),
                                            ),
                                        ),
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                        flex: 3,
                                        child: ElevatedButton(
                                            onPressed: widget.onDelete,
                                            child: Icon(UniconsLine.trash_alt, color: Theme.of(context).colorScheme.onError),
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor: Theme.of(context).colorScheme.error,
                                                padding: EdgeInsets.symmetric(vertical: 8),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(8),
                                                ),
                                            ),
                                        ),
                                    ),
                                ],
                            ),
                    ],
                ),
            ),
        );
    }

    String _getExerciseTypeString(ExerciseType type) {
        switch (type) {
            case ExerciseType.standard:
                return "Standard";
            case ExerciseType.dropSet:
                return "Drop Set";
            case ExerciseType.pyramid:
                return "Pyramide";
            case ExerciseType.timeUnderTension:
                return "Temps sous tension";
            case ExerciseType.superSet:
                return "Super Set";
            case ExerciseType.giantSet:
                return "Giant Set";
            case ExerciseType.restPause:
                return "Rest-Pause";
            case ExerciseType.cluster:
                return "Cluster";
        }
    }

    void _showRestTimeDialog(BuildContext context) {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                title: Text("Modifier le temps de repos"),
                content: TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: "Temps de repos (secondes)"),
                    onSubmitted: (value) {
                        widget.exercise.restTime = int.parse(value);
                        widget.onUpdate();
                        Navigator.pop(context);
                    },
                ),
            ),
        );
    }

    void _showAddSetDialog(BuildContext context) {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                title: Text("Ajouter une série"),
                content: SingleChildScrollView(
                    child: Column(
                        children:[
                            if (widget.exercise.type != ExerciseType.timeUnderTension)
                                TextField(
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(labelText: "Répétitions"),
                                    onSubmitted: (value) {
                                        widget.exercise.sets.add(ExerciseSet(reps: int.parse(value)));
                                        widget.onUpdate();
                                    },
                                ),
                            if (widget.exercise.type == ExerciseType.timeUnderTension)
                                TextField(
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(labelText: "Durée (secondes)"),
                                    onSubmitted: (value) {
                                        widget.exercise.sets.add(ExerciseSet(duration: int.parse(value)));
                                        widget.onUpdate();
                                    },
                                ),
                            TextField(
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(labelText: "Poids (kg)"),
                                onSubmitted: (value) {
                                    widget.exercise.sets.last.weight = double.parse(value);
                                    widget.onUpdate();
                                    Navigator.pop(context);
                                },
                            ),
                            if (widget.exercise.type == ExerciseType.superSet || widget.exercise.type == ExerciseType.giantSet)
                                TextField(
                                    decoration: InputDecoration(labelText: "Nom de l'exercice"),
                                    onSubmitted: (value) {
                                        widget.exercise.sets.last.exerciseName = value;
                                        widget.onUpdate();
                                    },
                                ),
                        ],
                    ),
                ),
            ),
        );
    }
}

class SetWidget extends StatefulWidget {
    final ExerciseSet set;
    final VoidCallback onUpdate;
    final ExerciseType exerciseType;
    final VoidCallback onSetUpdated;

    const SetWidget({
        Key? key,
        required this.set,
        required this.onUpdate,
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
        return Container(
            margin: EdgeInsets.only(bottom: 8),
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary.withOpacity(0.3),
                borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
                children: [
                    Expanded(
                        child: Wrap(
                            spacing: 8,
                            children: [
                                if (widget.exerciseType != ExerciseType.timeUnderTension)


                                    SizedBox(
                                        width: 100,
                                        child: TextField(
                                            controller: _repsController,
                                            keyboardType: TextInputType.number,
                                            style: AppTextStyles.titleMedium,
                                            decoration: InputDecoration(
                                                border: OutlineInputBorder(),
                                                labelText: "Répétitions",
                                                labelStyle: AppTextStyles.bodySmall,
                                                focusedBorder: OutlineInputBorder( // Bordure quand le champ est sélectionné
                                                    borderSide: BorderSide(
                                                        color: Colors.white,
                                                        width: 3.0,
                                                    ),
                                                ),
                                                enabledBorder: OutlineInputBorder( // Bordure quand le champ est inactif
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
                                if (widget.exerciseType == ExerciseType.timeUnderTension)
                                    SizedBox(
                                        width: 100,
                                        child: TextField(
                                            controller: _durationController,
                                            keyboardType: TextInputType.number,
                                            style: AppTextStyles.titleMedium,
                                            decoration: InputDecoration(
                                                border: OutlineInputBorder(),
                                                labelText: "Duration",
                                                labelStyle: AppTextStyles.bodySmall,
                                                focusedBorder: OutlineInputBorder( // Bordure quand le champ est sélectionné
                                                    borderSide: BorderSide(
                                                        color: Colors.white,
                                                        width: 3.0,
                                                    ),
                                                ),
                                                enabledBorder: OutlineInputBorder( // Bordure quand le champ est inactif
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
                                SizedBox(
                                    width: 100,
                                    child: TextField(
                                        controller: _weightController,
                                        keyboardType: TextInputType.number,
                                            style: AppTextStyles.titleMedium,
                                            decoration: InputDecoration(
                                                border: OutlineInputBorder(),
                                                labelText: "Weight",
                                                labelStyle: AppTextStyles.bodySmall,
                                                focusedBorder: OutlineInputBorder( // Bordure quand le champ est sélectionné
                                                    borderSide: BorderSide(
                                                        color: Colors.white,
                                                        width: 3.0,
                                                    ),
                                                ),
                                                enabledBorder: OutlineInputBorder( // Bordure quand le champ est inactif
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
                                if (widget.exerciseType == ExerciseType.superSet || widget.exerciseType == ExerciseType.giantSet)
                                    SizedBox(
                                        width: 100,
                                        child: TextField(
                                            controller: _exerciseNameController,
                                            style: AppTextStyles.titleMedium,
                                            decoration: InputDecoration(
                                                border: OutlineInputBorder(),
                                                labelText: "exerciseName",
                                                labelStyle: AppTextStyles.bodySmall,
                                                focusedBorder: OutlineInputBorder( // Bordure quand le champ est sélectionné
                                                    borderSide: BorderSide(
                                                        color: Colors.white,
                                                        width: 3.0,
                                                    ),
                                                ),
                                                enabledBorder: OutlineInputBorder( // Bordure quand le champ est inactif
                                                    borderSide: BorderSide(
                                                        color: Colors.grey,
                                                        width: 2.0,
                                                    ),
                                                ),
                                            ),
                                            onChanged: (value) {
                                                widget.set.exerciseName = value;
                                                widget.onUpdate();
                                                widget.onSetUpdated();
                                            },
                                        ),
                                    ),
                            ],
                        ),
                    ),
                ],
            ),
        );
    }
}


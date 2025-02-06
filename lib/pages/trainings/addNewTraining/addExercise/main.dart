import 'package:flutter/material.dart';
import 'package:muscu/text_styles.dart';
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
    return Expanded(
      child: ListView.builder(
        itemCount: widget.exercises.length,
        itemBuilder: (context, index) {
          return Padding(
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
      ),
    );
  }

}

class ExerciseCard extends StatelessWidget {
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
                    exercise.name,
                    style: AppTextStyles.titleMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                DropdownButton<ExerciseType>(
                  value: exercise.type,
                  onChanged: (ExerciseType? newValue) {
                    if (newValue != null) {
                      exercise.type = newValue;
                      onUpdate();
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
            if (exercise.equipment != null)
              Text(
                "Équipement: ${exercise.equipment}",
                style: AppTextStyles.bodySmall,
                overflow: TextOverflow.ellipsis,
              ),
            SizedBox(height: 8),
            ...exercise.sets.map((set) => SetWidget(set: set, onUpdate: onUpdate, exerciseType: exercise.type)).toList(),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(UniconsLine.clock, color: Colors.white70, size: 20),
                      SizedBox(width: 7),
                      Text(
                        "Repos: ${exercise.restTime} sec",
                        style: AppTextStyles.bodySmall.copyWith(fontSize: 15),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () => _showRestTimeDialog(context),
                  child: Text("Modifier repos"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    foregroundColor: Theme.of(context).colorScheme.onSecondary,
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            if (exercise.type != ExerciseType.standard)
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
                      onPressed: onDelete,
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
            exercise.restTime = int.parse(value);
            onUpdate();
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
            mainAxisSize: MainAxisSize.min,
            children: [
              if (exercise.type != ExerciseType.timeUnderTension)
                TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: "Répétitions"),
                  onSubmitted: (value) {
                    exercise.sets.add(ExerciseSet(reps: int.parse(value)));
                    onUpdate();
                  },
                ),
              if (exercise.type == ExerciseType.timeUnderTension)
                TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: "Durée (secondes)"),
                  onSubmitted: (value) {
                    exercise.sets.add(ExerciseSet(duration: int.parse(value)));
                    onUpdate();
                  },
                ),
              TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: "Poids (kg)"),
                onSubmitted: (value) {
                  exercise.sets.last.weight = double.parse(value);
                  onUpdate();
                  Navigator.pop(context);
                },
              ),
              if (exercise.type == ExerciseType.superSet || exercise.type == ExerciseType.giantSet)
                TextField(
                  decoration: InputDecoration(labelText: "Nom de l'exercice"),
                  onSubmitted: (value) {
                    exercise.sets.last.exerciseName = value;
                    onUpdate();
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class SetWidget extends StatelessWidget {
  final ExerciseSet set;
  final VoidCallback onUpdate;
  final ExerciseType exerciseType;

  const SetWidget({
    Key? key,
    required this.set,
    required this.onUpdate,
    required this.exerciseType,
  }) : super(key: key);

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
                if (exerciseType != ExerciseType.timeUnderTension && set.reps != null)
                  Text("${set.reps} reps", style: AppTextStyles.bodySmall),
                if (exerciseType == ExerciseType.timeUnderTension && set.duration != null)
                  Text("${set.duration} sec", style: AppTextStyles.bodySmall),
                if (set.weight != null) Text("@ ${set.weight} kg", style: AppTextStyles.bodySmall),
                if (set.exerciseName != null) Text(set.exerciseName!, style: AppTextStyles.bodySmall),
              ],
            ),
          ),
          IconButton(
            icon: Icon(UniconsLine.edit, size: 20, color: Colors.white),
            onPressed: () => _showEditDialog(context),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Modifier la série"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (exerciseType != ExerciseType.timeUnderTension)
              TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: "Répétitions"),
                onSubmitted: (value) {
                  set.reps = int.parse(value);
                  onUpdate();
                },
              ),
            if (exerciseType == ExerciseType.timeUnderTension)
              TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: "Durée (secondes)"),
                onSubmitted: (value) {
                  set.duration = int.parse(value);
                  onUpdate();
                },
              ),
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Poids (kg)"),
              onSubmitted: (value) {
                set.weight = double.parse(value);
                onUpdate();
              },
            ),
            if (exerciseType == ExerciseType.superSet || exerciseType == ExerciseType.giantSet)
              TextField(
                decoration: InputDecoration(labelText: "Nom de l'exercice"),
                onSubmitted: (value) {
                  set.exerciseName = value;
                  onUpdate();
                  Navigator.pop(context);
                },
              ),
          ],
        ),
      ),
    );
  }
}


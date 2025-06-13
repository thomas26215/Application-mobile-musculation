import 'package:muscu/pages/trainings/sessions/addNewTraining/exercisesList/donnees/exerciseType.dart';
import 'package:muscu/pages/trainings/sessions/addNewTraining/exercisesList/donnees/exerciseSet.dart';

class ExerciseToAdd {
  int id;
  int? recuperation;
  List<ExerciseSet> sets;
  ExerciseType type;
  int? numberOfSets; // Ajout du paramètre optionnel

  ExerciseToAdd({
    required this.id,
    required this.recuperation,
    required this.sets,
    required this.type,
    this.numberOfSets, // Ajout ici
  });

  static ExerciseToAdd createExercise(
    int id,
    String? equipment,
    List<ExerciseSet> sets,
    int restTime,
    ExerciseType type,
  ) {
    return ExerciseToAdd(
      id: id,
      recuperation: restTime,
      sets: sets,
      type: type,
    );
  }
}


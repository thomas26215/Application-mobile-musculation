import 'package:muscu/pages/trainings/sessions/addNewTraining/exercisesList/donnees/exerciseType.dart';
import 'package:muscu/pages/trainings/sessions/addNewTraining/exercisesList/donnees/exerciseSet.dart';

class Exercise {
    int id;
    int? recuperation;
    List<ExerciseSet> sets;
    ExerciseType type;

    Exercise({
        required this.id,
        required this.recuperation,
        required this.sets,
        required this.type,
    });

    static Exercise createExercise(int id, String? equipment, List<ExerciseSet> sets, int restTime, ExerciseType type) {
        return Exercise(
            id: id,
            recuperation: restTime,
            sets: sets,
            type: type,
        );
    }
}


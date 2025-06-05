import 'package:muscu/pages/trainings/addNewTraining/exercisesList/donnees/exerciseType.dart';
import 'package:muscu/pages/trainings/addNewTraining/exercisesList/donnees/exerciseSet.dart';

class Exercise {
    String name;
    List<ExerciseSet> sets;
    ExerciseType type;

    Exercise({
        required this.name,
        required this.sets,
        required this.type,
    });

    static Exercise createExercise(String name, String? equipment, List<ExerciseSet> sets, int restTime, ExerciseType type) {
        return Exercise(
            name: name,
            sets: sets,
            type: type,
        );
    }
}


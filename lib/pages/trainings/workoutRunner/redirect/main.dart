import 'package:flutter/material.dart';
import 'package:muscu/models/exercise/exercise.dart';
import 'package:muscu/models/seance/seance.dart';
import 'package:muscu/models/seance/session_exercise.dart';
import 'package:muscu/pages/trainings/workoutRunner/RepetitionExercises/main.dart';
import 'package:muscu/pages/trainings/workoutRunner/datas/ActualExercise.dart';
import 'package:muscu/models/database_helper.dart';

class Redirect extends StatelessWidget {
  final Session session;
  final ActualExercise actualExercise;

  Redirect({
    Key? key,
    required this.session,
    ActualExercise? actualExercise,
  })  : actualExercise = actualExercise ??
            ActualExercise(numeroExercise: 1, numeroSerie: 0),
        super(key: key);

  DatabaseHelper get dbHelper => DatabaseHelper.instance;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _runCurrentExercise(context),
      builder: (context, snapshot) {
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  Future<void> _runCurrentExercise(BuildContext context) async {
    // 1. Récupérer tous les exercices de la session
    List<SessionExercise> sessionExercises =
        await SessionExerciseTable.getSessionExercisesBySessionId(
            dbHelper, session.id!);
    sessionExercises.sort((a, b) => a.orderInSession.compareTo(b.orderInSession));

    int currentExerciseIndex = actualExercise.numeroExercise - 1;

    // 2. Fin de session ?
    if (currentExerciseIndex >= sessionExercises.length) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // TODO: Naviguer vers la page de fin de session
        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => EndOfSessionPage()));
      });
      return;
    }

    SessionExercise currentSessionExercise = sessionExercises[currentExerciseIndex];
    int totalSeries = currentSessionExercise.sets ?? 1;
    int currentSerie = actualExercise.numeroSerie;

    // 3. On récupère les infos de l'exercice en cours (si tu en as besoin)
    Exercise? exercise = await ExerciseTable.getExerciseById(
        dbHelper, currentSessionExercise.exerciseId);


    // 4. Toutes les séries faites ? Passer à l'exercice suivant
    if (currentSerie > totalSeries) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Redirect(
              session: session,
              actualExercise: ActualExercise(
                numeroExercise: actualExercise.numeroExercise + 1,
                numeroSerie: 1,
              ),
            ),
          ),
        );
      });
      return;
    }

    print("Type d'exercice: ${exercise?.type}");

    // 5. Selon le type d'exercice, naviguer vers la bonne page
    if (exercise?.type == "Force") {
      // Exercice à répétitions
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => RepetitionsExercise(
              session: session,
              actualExercise: ActualExercise(
                numeroExercise: actualExercise.numeroExercise,
                numeroSerie: actualExercise.numeroSerie + 1,
              ),
              sessionExercise: currentSessionExercise,
              exercise: exercise,
            ),
          ),
        );
      });
    } else if (exercise?.type == "Endurance") {
      // Exercice à durée (ici tu dois remplacer par ta vraie page)
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => DurationPage(
        //       session: session,
        //       actualExercise: ActualExercise(
        //         numeroExercise: actualExercise.numeroExercise,
        //         numeroSerie: actualExercise.numeroSerie + 1,
        //       ),
        //     ),
        //   ),
        // );
      });
    } else {
      // Autre type ou erreur
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Type d\'exercice non supporté')),
        );
        Navigator.pop(context);
      });
    }
  }
}


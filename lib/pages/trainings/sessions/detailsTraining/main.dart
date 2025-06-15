import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:muscu/models/database_helper.dart';
import 'package:muscu/models/exercise/exercise.dart';
import 'package:muscu/models/seance/seance.dart';
import 'package:muscu/models/seance/session_exercise.dart';
import 'package:muscu/pages/trainings/sessions/addNewTraining/main.dart';
import 'package:muscu/pages/trainings/sessions/detailsTraining/widgets/sliver.dart';
import 'package:muscu/pages/trainings/workoutRunner/redirect/main.dart';
import 'package:muscu/styles/text_styles.dart';
import 'package:muscu/pages/trainings/workoutRunner/redirect/main.dart';
import 'package:muscu/utils/snackbar_helper.dart';


class CombinedExerciseData {
  final SessionExercise sessionExercise;
  final Exercise exercise;

  CombinedExerciseData({
    required this.sessionExercise,
    required this.exercise,
  });
}

// Fonction utilitaire pour calculer la durée estimée de la séance
int calculerDureeEstimeeSeance(List<SessionExercise> exercices) {
  int totalSeconds = 0;

  for (var exo in exercices) {
    int nbSeries = exo.sets ?? 1;
    int nbReps = exo.reps ?? 1;
    int dureeSerie = 0;

    // Si l'exercice a une durée fixe (ex: gainage, cardio, etc.)
    if (exo.duration != null && exo.duration! > 0) {
      dureeSerie = exo.duration!;
    } else {
      // Sinon, on estime durée = nb reps × 4 sec (modifiable selon le type)
      dureeSerie = nbReps * 4;
    }

    // Pause entre les séries (en secondes)
    int pause = exo.pause ?? 0;

    // Durée totale pour cet exercice
    // (nbSeries - 1) pauses car pas de pause après la dernière série
    int dureeExercice = (dureeSerie * nbSeries) + (pause * (nbSeries - 1));

    // Ajoute la récupération après l'exercice (sauf pour le dernier)
    int recuperation = exo.restTime ?? 0;
    totalSeconds += dureeExercice + recuperation;
  }

  return totalSeconds;
}

class DetailPage extends StatefulWidget {
  final Session session;

  DetailPage({Key? key, required this.session}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final dbHelper = DatabaseHelper.instance;
  List<CombinedExerciseData> combinedExercises = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    startLoading();
  }

  Future<void> startLoading() async {
    setState(() {
      isLoading = true;
    });
    await Future.delayed(Duration(seconds: 2));
    await _loadCombinedExercises();
  }

  Future<void> _loadCombinedExercises() async {
    final sessionExercises = await SessionExerciseTable.getSessionExercisesBySessionId(dbHelper, widget.session.id!);
    List<CombinedExerciseData> tempCombinedExercises = [];
    for (var sessionExercise in sessionExercises) {
      final exercise = await ExerciseTable.getExerciseById(dbHelper, sessionExercise.exerciseId);
      if (exercise != null) {
        tempCombinedExercises.add(
          CombinedExerciseData(
            sessionExercise: sessionExercise,
            exercise: exercise,
          ),
        );
      }
    }
    setState(() {
      combinedExercises = tempCombinedExercises;
      isLoading = false;
    });
  }

  String getDifficultyLevel(String level) {
    switch (level) {
      case "beginner":
        return "Débutant";
      case "intermediate":
        return "Intermédiaire";
      case "advanced":
        return "Avancé";
      default:
        return "Inconnu";
    }
  }

  @override
  Widget build(BuildContext context) {
    final String difficultyLevel = getDifficultyLevel("intermediate");

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverPersistentHeader(
                  delegate: DetailSliverDelegate(),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
                    child: SessionInfo(
                      session: widget.session,
                      difficultyLevel: difficultyLevel,
                      combinedExercises: combinedExercises,
                      isLoading: isLoading,
                    ),
                  ),
                ),
              ],
            ),
          ),
          BottomButton(session: widget.session),
        ],
      ),
    );
  }
}

class SessionInfo extends StatelessWidget {
  const SessionInfo({
    Key? key,
    required this.session,
    required this.difficultyLevel,
    required this.combinedExercises,
    required this.isLoading,
  }) : super(key: key);

  final Session session;
  final String difficultyLevel;
  final List<CombinedExerciseData> combinedExercises;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final totalSeconds = calculerDureeEstimeeSeance(
      combinedExercises.map((e) => e.sessionExercise).toList(),
    );
    final minutes = (totalSeconds / 60).floor();
    final secondes = totalSeconds % 60;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Séance : ${session.name}",
          style: AppTextStyles.titleMedium,
        ),
        SizedBox(height: 10),
        _buildInfoRow(Icons.fitness_center, "Type de séance : ${session.type ?? 'Non spécifié'}"),
        SizedBox(height: 8),
        _buildInfoRow(Icons.timer, "Durée totale estimée : $minutes min ${secondes.toString().padLeft(2, '0')} sec"),
        SizedBox(height: 8),
        _buildInfoRow(Icons.star, "Niveau : $difficultyLevel"),
        SizedBox(height: 8),
        _buildInfoRow(Icons.local_fire_department, "Calories estimées : ~300 kcal"),
        SizedBox(height: 8),
        _buildInfoRow(Icons.flag, "Objectif : Renforcement musculaire et endurance"),
        SizedBox(height: 8),
        _buildInfoRow(Icons.sports_gymnastics, "Équipement requis : Tapis, Haltères"),
        SizedBox(height: 16),
        if (isLoading)
          LinearProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.orangeAccent),
            backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
          ),
        SizedBox(height: 16),
        Text(
          "Note : Assurez-vous de bien vous échauffer avant de commencer pour éviter les blessures.",
          style: AppTextStyles.bodySmall.copyWith(color: Colors.redAccent),
        ),
        SizedBox(height: 16),
        Text(
          "Exercices :",
          style: AppTextStyles.titleMedium,
        ),
        SizedBox(height: 8),
        if (isLoading)
          Center(child: Text("Chargement des exercices...")),
        if (!isLoading)
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: combinedExercises.length,
            itemBuilder: (context, index) {
              final combinedData = combinedExercises[index];
              return ExerciseCard(combinedData: combinedData);
            },
          ),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey, size: 20),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.bodySmall,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class ExerciseCard extends StatelessWidget {
  const ExerciseCard({
    Key? key,
    required this.combinedData,
  }) : super(key: key);

  final CombinedExerciseData combinedData;

  IconData _getExerciseIcon(String exerciseType) {
    switch (exerciseType) {
      case "Force":
        return Icons.fitness_center;
      case "Endurance":
        return Icons.timer;
      case "Cardio":
        return Icons.directions_run;
      case "Souplesse":
        return Icons.sports_handball;
      default:
        return Icons.sports;
    }
  }

  Color _getExerciseTypeColor(String exerciseType) {
    switch (exerciseType) {
      case "Force":
        return Colors.red;
      case "Endurance":
        return Colors.blue;
      case "Cardio":
        return Colors.orange;
      case "Souplesse":
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final exerciseType = combinedData.exercise.type;
    final se = combinedData.sessionExercise;
    final customData = se.customData;

    List<Widget> infoWidgets = [];

    if (exerciseType == "Force") {
      infoWidgets.add(Text("Poids : ${se.weight != null ? "${se.weight} kg" : "Inconnu"}", style: AppTextStyles.bodySmall.copyWith(color: Colors.white70)));
      infoWidgets.add(Text("Répétitions : ${se.reps ?? 'Inconnu'}", style: AppTextStyles.bodySmall.copyWith(color: Colors.white70)));
      infoWidgets.add(Text("Pause : ${se.pause != null ? "${se.pause} sec" : "—"}", style: AppTextStyles.bodySmall.copyWith(color: Colors.white70)));
    } else if (exerciseType == "Endurance") {
      infoWidgets.add(Text("Durée : ${se.duration != null ? "${se.duration} min" : "Inconnue"}", style: AppTextStyles.bodySmall.copyWith(color: Colors.white70)));
      infoWidgets.add(Text("Pause : ${se.pause != null ? "${se.pause} sec" : "—"}", style: AppTextStyles.bodySmall.copyWith(color: Colors.white70)));
    } else if (exerciseType == "Cardio") {
      infoWidgets.add(Text("Durée : ${se.duration != null ? "${se.duration} min" : "Inconnue"}", style: AppTextStyles.bodySmall.copyWith(color: Colors.white70)));
    } else if (exerciseType == "Souplesse") {
      infoWidgets.add(Text("Durée : ${se.duration != null ? "${se.duration} min" : "Inconnue"}", style: AppTextStyles.bodySmall.copyWith(color: Colors.white70)));
    }

    if (exerciseType == "pyramid" && customData != null && customData.containsKey('sets')) {
      infoWidgets.add(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Pyramid Data:", style: TextStyle(color: Colors.white70)),
            ...(customData['sets'] as List<dynamic>).map((set) => Text(
              "Set: Weight - ${set['weight']}, Reps - ${set['reps']}",
              style: TextStyle(color: Colors.white70),
            )),
          ],
        ),
      );
    }
    if (exerciseType == "dropSet" && customData != null && customData.containsKey('drops')) {
      infoWidgets.add(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Drop Set Data:", style: TextStyle(color: Colors.white70)),
            ...(customData['drops'] as List<dynamic>).map((drop) => Text(
              "Drop: Weight - ${drop['weight']}, Reps - ${drop['reps']}",
              style: TextStyle(color: Colors.white70),
            )),
          ],
        ),
      );
    }
    if (exerciseType == "timeUnderTension" && customData != null && customData.containsKey('tempo')) {
      infoWidgets.add(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Time Under Tension Data:", style: TextStyle(color: Colors.white70)),
            Text("Tempo: ${customData['tempo']}", style: TextStyle(color: Colors.white70)),
          ],
        ),
      );
    }

    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 5,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: Theme.of(context).colorScheme.primary.withOpacity(0.9),
        ),
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              _getExerciseIcon(exerciseType),
              color: Colors.white,
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    combinedData.exercise.name,
                    style: AppTextStyles.titleMedium.copyWith(color: Colors.white),
                  ),
                  ...infoWidgets,
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _getExerciseTypeColor(exerciseType),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                exerciseType,
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BottomButton extends StatelessWidget {
  const BottomButton({
    Key? key,
    required this.session,
  }) : super(key: key);

  final Session session;
  final dbHelper = DatabaseHelper.instance;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.secondary.withOpacity(0.9),
                padding: EdgeInsets.symmetric(vertical: 17),
                textStyle: AppTextStyles.titleMedium.copyWith(color: Colors.white),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () {
                final List<Map<String, dynamic>> exerciseList = [
                  {'name': 'Pompes', 'repetitions': 15, 'series': 3},
                  {'name': 'Squats', 'repetitions': 20, 'series': 3},
                  {'name': 'Tractions', 'repetitions': 8, 'series': 3},
                ];
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => Redirect(session: session),
                  ),
                );
              },
              child: Center(child: Text("Démarrer la séance")),
            ),
          ),
          SizedBox(width: 10),
          Container(
            width: 52,
            height: 52,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                padding: EdgeInsets.zero,
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddNewTrainingPage(sessionId: session.id!)),
                );
              },
              child: Icon(Icons.edit, color: Colors.white),
            ),
          ),
          SizedBox(width: 10),
          Container(
            width: 52,
            height: 52,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                padding: EdgeInsets.zero,
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                      title: Row(
                        children: [
                          Icon(Icons.warning, color: Colors.redAccent),
                          SizedBox(width: 8),
                          Text("Suppression", style: TextStyle(color: Colors.redAccent)),
                        ],
                      ),
                      content: Text(
                        "Êtes-vous sûr de vouloir supprimer cette séance ?\nCette action est irréversible.",
                        style: AppTextStyles.bodySmall,
                      ),
                      actions: [
                        TextButton(
                          child: Text("Annuler", style: TextStyle(color: Colors.grey)),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: Text("Supprimer", style: TextStyle(color: Colors.white)),
                          onPressed: () async {
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                            await SessionExerciseTable.deleteBySessionId(dbHelper, session.id!);
                            await SessionTable.delete(dbHelper, session.id!);
                            showCustomNotification(context, "Séance supprimée avec succès", type: SnackBarType.success);
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              child: Icon(Icons.delete, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}


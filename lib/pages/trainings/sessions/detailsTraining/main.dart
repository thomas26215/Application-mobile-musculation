import 'package:flutter/material.dart';
import 'package:muscu/models/exercise/exercise.dart';
import 'package:muscu/models/seance/seance.dart';
import 'package:muscu/models/seance/session_exercise.dart';
import 'package:muscu/pages/trainings/sessions/detailsTraining/widgets/sliver.dart';
import 'package:muscu/models/database_helper.dart';
import 'package:muscu/styles/text_styles.dart';
import 'package:muscu/pages/trainings/workoutRunner/RepetitionExercises/main.dart';
import 'dart:async';

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

    // Délai de 2 secondes
    await Future.delayed(Duration(seconds: 2));

    await _loadCombinedExercises();
  }

  Future<void> _loadCombinedExercises() async {
    // Récupérer les SessionExercises pour la session actuelle
    final sessionExercises = await SessionExerciseTable.getSessionExercisesBySessionId(dbHelper, widget.session.id!);

    // Préparer une liste pour stocker les données combinées
    List<CombinedExerciseData> tempCombinedExercises = [];

    // Pour chaque SessionExercise, récupérer l'Exercise correspondant
    for (var sessionExercise in sessionExercises) {
      final exercise = await ExerciseTable.getExerciseById(dbHelper, sessionExercise.exerciseId);
      if (exercise != null) {
        // Combiner les données et ajouter à la liste temporaire
        tempCombinedExercises.add(
          CombinedExerciseData(
            sessionExercise: sessionExercise,
            exercise: exercise,
          ),
        );
      }
    }

    // Mettre à jour l'état avec les données combinées
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
        _buildInfoRow(Icons.timer, "Durée totale : 45 minutes"),
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
        if (!isLoading)
          SizedBox(height: 0),
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
      case "Strength":
        return Icons.fitness_center;
      case "Endurance":
        return Icons.timer;
      default:
        return Icons.sports;
    }
  }

  Color _getExerciseTypeColor(String exerciseType) {
    switch (exerciseType) {
      case "Strength":
        return Colors.red;
      case "Endurance":
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final exerciseType = combinedData.exercise.type; // Récupérer le type de l'exercice
    final customData = combinedData.sessionExercise.customData; // Récupérer les données personnalisées

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
              _getExerciseIcon(exerciseType), // Utiliser le type d'exercice pour l'icône
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
                  Text(
                    "Durée : ${combinedData.sessionExercise.duration != null ? combinedData.sessionExercise.duration.toString() + ' min' : 'Inconnue'}",
                    style: AppTextStyles.bodySmall.copyWith(color: Colors.white70),
                  ),
                  Text(
                    "Séries : ${combinedData.sessionExercise.sets ?? 'Inconnu'}  Répétitions : ${combinedData.sessionExercise.reps ?? 'Inconnu'}",
                    style: AppTextStyles.bodySmall.copyWith(color: Colors.white70),
                  ),
                  // Afficher les informations spécifiques en fonction du type d'exercice et des données personnalisées
                  if (exerciseType == "pyramid" && customData != null && customData.containsKey('sets'))
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Pyramid Data:", style: TextStyle(color: Colors.white70)),
                        // Affiche les données spécifiques à l'exercice pyramid
                        ...(customData['sets'] as List<dynamic>).map((set) => Text(
                          "Set: Weight - ${set['weight']}, Reps - ${set['reps']}",
                          style: TextStyle(color: Colors.white70),
                        )),
                      ],
                    ),
                  if (exerciseType == "dropSet" && customData != null && customData.containsKey('drops'))
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Drop Set Data:", style: TextStyle(color: Colors.white70)),
                        // Affiche les données spécifiques à l'exercice drop set
                        ...(customData['drops'] as List<dynamic>).map((drop) => Text(
                          "Drop: Weight - ${drop['weight']}, Reps - ${drop['reps']}",
                          style: TextStyle(color: Colors.white70),
                        )),
                      ],
                    ),
                  if (exerciseType == "timeUnderTension" && customData != null && customData.containsKey('tempo'))
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Time Under Tension Data:", style: TextStyle(color: Colors.white70)),
                        Text("Tempo: ${customData['tempo']}", style: TextStyle(color: Colors.white70)),
                      ],
                    ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _getExerciseTypeColor(exerciseType), // Utiliser le type d'exercice pour la couleur
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                exerciseType, // Utiliser le type d'exercice pour le texte
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

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.secondary.withOpacity(0.9),
          padding: EdgeInsets.symmetric(vertical: 20),
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
              builder: (context) => RepetitionsExercise(exercises: exerciseList),
            ),
          );
        },
        child: Center(child: Text("Démarrer la séance")),
      ),
    );
  }
}

class CombinedExerciseData {
  final SessionExercise sessionExercise;
  final Exercise exercise;

  CombinedExerciseData({
    required this.sessionExercise,
    required this.exercise,
  });
}


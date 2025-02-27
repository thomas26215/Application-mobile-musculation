import 'package:flutter/material.dart';
import 'package:muscu/models/seance/seance.dart';
import 'package:muscu/pages/trainings/detailsTraining/widgets/sliver.dart';
import 'package:muscu/styles/text_styles.dart';
import 'package:muscu/pages/trainings/workoutRunner/RepetitionExercises/main.dart';

class DetailPage extends StatefulWidget {
  final Session session; // Ajout de la session

  DetailPage({Key? key, required this.session}) : super(key: key); // Modification du constructeur

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> with TickerProviderStateMixin {
  bool _isInstalling = false;
  late AnimationController _progressController;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 5),
    );
    _progressAnimation = Tween<double>(begin: 0, end: 1).animate(_progressController);
    _progressController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _isInstalling = false;
        });
      }
    });

    // Exemple de liste d'exercices (à remplacer par les données de la session)
    // final List<Map<String, dynamic>> exerciseList = [
    //   {'name': 'Pompes', 'repetitions': 15, 'series': 3},
    //   {'name': 'Squats', 'repetitions': 20, 'series': 3},
    //   {'name': 'Tractions', 'repetitions': 8, 'series': 3},
    // ];

  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  void _startInstallation() {
    setState(() {
      _isInstalling = true;
    });
    _progressController.forward(from: 0);
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
    // Exemple d'exercices (à remplacer par les données réelles de la session)
    final List<Map<String, dynamic>> exercises = [
      {"name": "Échauffement", "duration": "10 min", "type": "Échauffement"},
      {"name": "Pompes", "duration": "3 séries x 15 répétitions", "type": "Force"},
      {"name": "Squats", "duration": "3 séries x 20 répétitions", "type": "Force"},
      {"name": "Planche", "duration": "3 séries x 1 min", "type": "Endurance"},
      {"name": "Étirements", "duration": "5 min", "type": "Récupération"},
    ];

    final String difficultyLevel = getDifficultyLevel("intermediate"); // A remplacer avec la difficulte de la session

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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Séance : ${widget.session.nom}", // Utilisation du nom de la session
                          style: AppTextStyles.titleMedium,
                        ),
                        SizedBox(height: 10),
                        _buildInfoRow(Icons.fitness_center, "Type de séance : ${widget.session.type ?? 'Non spécifié'}"), // Utilisation du type de la session
                        SizedBox(height: 8),
                        _buildInfoRow(Icons.timer, "Durée totale : 45 minutes"), // TODO: Implement duration
                        SizedBox(height: 8),
                        _buildInfoRow(Icons.star, "Niveau : $difficultyLevel"), // A remplacer
                        SizedBox(height: 8),
                        _buildInfoRow(Icons.local_fire_department, "Calories estimées : ~300 kcal"), // TODO: implement calories
                        SizedBox(height: 8),
                        _buildInfoRow(Icons.flag, "Objectif : Renforcement musculaire et endurance"), // TODO: Implement objective
                        SizedBox(height: 8),
                        _buildInfoRow(Icons.sports_gymnastics, "Équipement requis : Tapis, Haltères"), // TODO: Implement equipment
                        SizedBox(height: 16),
                        LinearProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.orangeAccent),
                          backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                          value: exercises.length / (exercises.length + 2),
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
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: exercises.length,
                          itemBuilder: (context, index) {
                            final exercise = exercises[index];
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
                                      _getExerciseIcon(exercise["type"]),
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            exercise["name"],
                                            style: AppTextStyles.titleMedium.copyWith(color: Colors.white),
                                          ),
                                          Text(
                                            "Durée : ${exercise["duration"]}",
                                            style: AppTextStyles.bodySmall.copyWith(color: Colors.white70),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: _getExerciseTypeColor(exercise["type"]),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        exercise["type"],
                                        style: TextStyle(color: Colors.white, fontSize: 12),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
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
    // Créez une liste d'exercices (à remplacer par vos vraies données)
    final List<Map<String, dynamic>> exerciseList = [
      {'name': 'Pompes', 'repetitions': 15, 'series': 3},
      {'name': 'Squats', 'repetitions': 20, 'series': 3},
      {'name': 'Tractions', 'repetitions': 8, 'series': 3},
    ];
    // Naviguez vers la page RepetitionsExercise
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => RepetitionsExercise(exercises: exerciseList),
      ),
    );
  },
  child: Center(child: Text("Démarrer la séance")),
),

          )
        ],
      ),
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

  IconData _getExerciseIcon(String type) {
    switch (type) {
      case "Échauffement":
        return Icons.whatshot;
      case "Force":
        return Icons.fitness_center;
      case "Endurance":
        return Icons.timer;
      case "Récupération":
        return Icons.self_improvement;
      default:
        return Icons.sports;
    }
  }

  Color _getExerciseTypeColor(String type) {
    switch (type) {
      case "Échauffement":
        return Colors.orange;
      case "Force":
        return Colors.red;
      case "Endurance":
        return Colors.blue;
      case "Récupération":
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}


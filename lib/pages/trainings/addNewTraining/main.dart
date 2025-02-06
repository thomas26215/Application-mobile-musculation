import 'package:flutter/material.dart';
import 'package:unicons/unicons.dart';
import 'package:muscu/pages/trainings/addNewTraining/widgets/note.dart';
import 'package:muscu/pages/trainings/addNewTraining/globalSettings/main.dart';
import 'package:muscu/pages/trainings/addNewTraining/addExercise/main.dart';

class AddNewTrainingPage extends StatefulWidget {
  const AddNewTrainingPage({Key? key}) : super(key: key);

  @override
  _AddNewTrainingPageState createState() => _AddNewTrainingPageState();
}

class _AddNewTrainingPageState extends State<AddNewTrainingPage> with TickerProviderStateMixin {
  String trainingName = "";
  Map<String, dynamic> trainingParameters = {
    'type': 'Full Body',
    'duration': 60,
    'difficulty': 'Intermédiaire',
  };
  List<Exercise> exercises = [];

  // Animation variables
  late AnimationController _controller;
  late Animation<double> _buttonScaleAnimation;
  late Animation<double> _iconRotationAnimation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    // Initialiser l'animation
    _controller = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );

    _buttonScaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _iconRotationAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _colorAnimation = ColorTween(
      begin: Color(0xFF006400), // Vert foncé
      end: Colors.greenAccent, // Couleur plus claire pendant l'animation
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose(); // Nettoyer l'animation
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final darkGreenColor = Color(0xFF006400);  // Une couleur vert foncé

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    UniconsLine.angle_left,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
                Expanded(
                  child: TextField(
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Nom de l'entraînement",
                      hintStyle: Theme.of(context).textTheme.displayLarge?.copyWith(color: Colors.white54),
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        trainingName = value;
                      });
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditTrainingParametersPage(
                    initialParameters: trainingParameters,
                  )),
                );
                if (result != null) {
                  setState(() {
                    trainingParameters = result;
                  });
                }
              },
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Paramètres généraux",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.black),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.black,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            NoteWidget(),
            SizedBox(height: 20),
            ExerciseWidget(exercises: exercises),
            
            // Espace avant les boutons fixes
            SizedBox(height: 15),

            // Les boutons fixes avec proportions
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Premier bouton prenant 70% de la place
                Expanded(
                  flex: 6,  // Prend 70% de l'espace
                  child: ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        exercises.add(Exercise(
                          name: "Nouvel exercice",
                          sets: [ExerciseSet(reps: 10, weight: 0)],
                          restTime: 60,
                          type: ExerciseType.standard,
                        ));
                      });
                    },
                    icon: Icon(Icons.add, color: Colors.white), // Icône pour ajouter un exercice
                    label: Text(
                      "Add exercise",
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary, // Couleur du bouton
                      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 20),
                // Deuxième bouton avec animation stylisée
                Expanded(
                  flex: 4,  // Prend 30% de l'espace
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _buttonScaleAnimation.value,
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            // Démarre l'animation de bouton lorsqu'on clique
                            _controller.forward().then((value) {
                              _controller.reverse();  // Revenir à la taille originale après l'animation
                            });

                            // Votre action de sauvegarde ici
                          },
                          icon: AnimatedBuilder(
                            animation: _iconRotationAnimation,
                            builder: (context, child) {
                              return Transform.rotate(
                                angle: _iconRotationAnimation.value * 2 * 3.1416, // Rotation complète
                                child: Icon(Icons.save, color: Colors.white),
                              );
                            },
                          ),
                          label: Text(
                            "Save",
                            style: Theme.of(context).textTheme.displayMedium,
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _colorAnimation.value,  // Animation de la couleur
                            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}


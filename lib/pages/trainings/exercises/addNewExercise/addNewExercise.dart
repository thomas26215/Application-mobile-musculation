import 'package:flutter/material.dart';
import 'package:muscu/models/database_helper.dart';
import 'package:muscu/models/exercise/exercise.dart';
import 'package:muscu/pages/trainings/exercises/addNewExercise/datas/MuscularGroupEntry.dart';
import 'package:muscu/pages/trainings/exercises/addNewExercise/widgets/header.dart';
import 'package:muscu/pages/trainings/exercises/addNewExercise/widgets/lists.dart';
import 'package:muscu/pages/trainings/exercises/addNewExercise/widgets/muscularGroups.dart';
import 'package:muscu/pages/trainings/exercises/addNewExercise/widgets/videosAndDescriptions.dart';

class AddNewTrainingPage extends StatefulWidget {
    const AddNewTrainingPage({Key? key}) : super(key: key);

    @override
    _AddNewTrainingPageState createState() => _AddNewTrainingPageState();
}

class _AddNewTrainingPageState extends State<AddNewTrainingPage> with TickerProviderStateMixin {
    int? exerciseId;
    String exerciseName = '';
    String selectedExerciseType = '';

    List<MuscularGroupEntry> groupesMusculaires = [
        MuscularGroupEntry(name: "Pectoraux", value: "80"),
        MuscularGroupEntry(name: "Dos", value: "60"),
        MuscularGroupEntry(name: "Jambes", value: "40"),
    ];

    String videoUrl = '';
    String description = '';
    String note = '';

    final dbHelper = DatabaseHelper.instance;

    late AnimationController _controller;

    @override
    void initState() {
        super.initState();
        _controller = AnimationController(
            duration: Duration(milliseconds: 500),
            vsync: this,
        );
    }

    @override
    void dispose() {
        _controller.dispose();
        super.dispose();
    }

    Future<void> _handleSaveOrUpdate() async {
        if (exerciseName.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Veuillez entrer un nom d'exercice")),
            );
            return;
        }
        if (selectedExerciseType.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Veuillez sélectionner un type d'exercice")),
            );
            return;
        }

        final newExercise = Exercise(
            id: exerciseId,
            userId: 1, // à adapter selon ton contexte utilisateur
            name: exerciseName,
            description: description,
            type: selectedExerciseType,
        );

        if (exerciseId == null) {
            // Ajout
            int newId = await ExerciseTable.insert(dbHelper, newExercise);
            setState(() {
                exerciseId = newId;
            });
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Exercice ajouté avec succès")),
            );
        } else {
            // Modification (id non null garanti)
            await ExerciseTable.update(dbHelper, newExercise);
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Exercice modifié avec succès")),
            );
        }

        // Tu peux ici rafraîchir ou réinitialiser le formulaire si besoin
        setState(() {}); // force le rafraîchissement du bouton et de la page
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            body: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 50),
                child: SingleChildScrollView(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                            Header(
                                trainingName: exerciseName,
                                onChanged: (value) {
                                    setState(() {
                                        exerciseName = value;
                                    });
                                },
                            ),
                            Lists(
                                onValueChanged: (value) {
                                    setState(() {
                                        selectedExerciseType = value;
                                    });
                                },
                            ),
                            const SizedBox(height: 20),
                            Divider(
                                color: Colors.white54,
                                thickness: 2,
                                indent: 10,
                                endIndent: 10,
                            ),
                            const SizedBox(height: 20),
                            MuscularGroups(
                                initialGroups: groupesMusculaires,
                                onValueChanged: (updatedList) {
                                    setState(() {
                                        groupesMusculaires = updatedList;
                                    });
                                },
                            ),
                            const SizedBox(height: 20),
                            Divider(
                                color: Colors.white54,
                                thickness: 2,
                                indent: 10,
                                endIndent: 10,
                            ),
                            const SizedBox(height: 20),
                            VideoAndDescriptions(
                                videoUrl: videoUrl,
                                description: description,
                                note: note,
                                onVideoUrlChanged: (value) {
                                    setState(() {
                                        videoUrl = value;
                                    });
                                },
                                onDescriptionChanged: (value) {
                                    setState(() {
                                        description = value;
                                    });
                                },
                                onNoteChanged: (value) {
                                    setState(() {
                                        note = value;
                                    });
                                },
                            ),
                        ],
                    ),
                ),
            ),
            bottomNavigationBar: SafeArea(
                child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
                    child: SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).colorScheme.secondary,
                                foregroundColor: Color(0xFF223B65),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                ),
                                elevation: 6,
                                textStyle: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                ),
                            ),
                            onPressed: _handleSaveOrUpdate,
                            child: Text(
                                exerciseId == null
                                    ? "Ajouter l'exercice"
                                    : "Modifier l'exercice",
                            ),
                        ),
                    ),
                ),
            ),
        );
    }
}


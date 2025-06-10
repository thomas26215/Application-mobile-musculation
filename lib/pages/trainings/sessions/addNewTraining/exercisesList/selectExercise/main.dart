import 'package:flutter/material.dart';
import 'package:muscu/models/database_helper.dart';
import 'package:muscu/models/exercise/exercise.dart';

class SelectExistingExercisePage extends StatelessWidget {
    final DatabaseHelper dbHelper;

    const SelectExistingExercisePage({Key? key, required this.dbHelper}) : super(key: key);

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: Text("Choisir un exercice"),
                leading: IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                        Navigator.of(context).pop(null); // retour simple
                    },
                ),
            ),
            body: FutureBuilder<List<Exercise>>(
                future: _fetchExercises(),
                builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(child: Text("Aucun exercice existant."));
                    }
                    final exercises = snapshot.data!;
                    return ListView.separated(
                        itemCount: exercises.length,
                        separatorBuilder: (context, index) => Divider(),
                        itemBuilder: (context, index) {
                            final exo = exercises[index];
                            return ListTile(
                                title: Text(exo.name),
                                subtitle: Text(exo.type),
                                onTap: () {
                                    Navigator.of(context).pop(exo); // sélection
                                },
                            );
                        },
                    );
                },
            ),
        );
    }

    Future<List<Exercise>> _fetchExercises() async {
        // À adapter selon ta méthode pour récupérer tous les exercices
        return await ExerciseTable.getAllExercises(dbHelper);
    }
}


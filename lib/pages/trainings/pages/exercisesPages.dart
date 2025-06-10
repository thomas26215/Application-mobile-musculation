import 'package:flutter/material.dart';
import 'package:muscu/models/database_helper.dart';
import 'package:muscu/models/exercise/exercise.dart';
import 'package:muscu/pages/trainings/exercises/list/widgets/search.dart';
import 'package:muscu/pages/trainings/exercises/list/widgets/trainings.dart';
import 'package:muscu/styles/text_styles.dart';

class ExercisesListPage extends StatefulWidget {
    const ExercisesListPage({super.key});

    @override
    _ExercisesListPageState createState() => _ExercisesListPageState();
}

class _ExercisesListPageState extends State<ExercisesListPage> {
    final dbHelper = DatabaseHelper.instance;
    List<Exercise> allExercises = [];
    List<Exercise> filteredExercises = [];

    @override
    void initState() {
        super.initState();
        _loadSessions();
    }

    Future<void> _loadSessions() async {
        final loadedSessions = await ExerciseTable.getAllExercises(dbHelper);
        setState(() {
            allExercises = loadedSessions;
            filteredExercises = List.from(allExercises);
        });
    }

    void searchTrainings(String query) {
        setState(() {
            filteredExercises = allExercises.where((training) {
                final nomLower = training.name.toLowerCase();
                final typeLower = training.type?.toLowerCase() ?? '';
                final descriptionLower = training.description?.toLowerCase() ?? '';
                final searchLower = query.toLowerCase();
                return nomLower.contains(searchLower) || 
                       typeLower.contains(searchLower) ||
                       descriptionLower.contains(searchLower);
            }).toList();
        });
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            body: SafeArea(
                child: Padding(
                    padding: const EdgeInsets.only(left: 10, right: 20),
            // Espace sous les tabs
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                            Row(
                                children: [
                                    Expanded(
                                        child: Text(
                                            "Exercices",
                                            style: AppTextStyles.titleMedium.copyWith(fontSize: 24),
                                            textAlign: TextAlign.center,
                                        ),
                                    ),
                                ],
                            ),
                            SearchWidget(onSearch: searchTrainings),
                            Expanded(
                                child: ExercisesWidget(filteredExercises: filteredExercises),
                            ),
                        ],
                    ),
                ),
            ),
        );
    }
}



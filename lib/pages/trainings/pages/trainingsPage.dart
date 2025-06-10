import 'package:flutter/material.dart';
import 'package:muscu/models/database_helper.dart';
import 'package:muscu/models/seance/seance.dart';
import 'package:muscu/pages/trainings/sessions/list/widgets/search.dart';
import 'package:muscu/pages/trainings/sessions/list/widgets/trainings.dart';
import 'package:muscu/styles/text_styles.dart';

class SportsListPage extends StatefulWidget {
    const SportsListPage({super.key});

    @override
    _SportsListPageState createState() => _SportsListPageState();
}

class _SportsListPageState extends State<SportsListPage> {
    final dbHelper = DatabaseHelper.instance;
    List<Session> allTrainings = [];
    List<Session> filteredTrainings = [];

    @override
    void initState() {
        super.initState();
        _loadSessions();
    }

    Future<void> _loadSessions() async {
        final loadedSessions = await SessionTable.getAllSessions(dbHelper);
        setState(() {
            allTrainings = loadedSessions;
            filteredTrainings = List.from(allTrainings);
        });
    }

    void searchTrainings(String query) {
        setState(() {
            filteredTrainings = allTrainings.where((training) {
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
                                            "Entraînements",
                                            style: AppTextStyles.titleMedium.copyWith(fontSize: 24),
                                            textAlign: TextAlign.center,
                                        ),
                                    ),
                                ],
                            ),
                            SearchWidget(onSearch: searchTrainings),
                            Expanded(
                                child: TrainingsWidget(filteredTrainings: filteredTrainings),
                            ),
                        ],
                    ),
                ),
            ),
        );
    }
}


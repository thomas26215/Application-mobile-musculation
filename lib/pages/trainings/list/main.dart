import 'package:flutter/material.dart';
import 'package:muscu/models/database_helper.dart';
import 'package:muscu/models/seance/seance.dart';
import 'package:muscu/pages/trainings/list/widgets/search.dart';
import 'package:muscu/pages/trainings/list/widgets/trainings.dart';
import 'package:muscu/styles/text_styles.dart';
import 'package:unicons/unicons.dart';

class SportsListPage extends StatefulWidget {
    const SportsListPage({super.key});

    @override
    _SportsListPageState createState() => _SportsListPageState();
}

class _SportsListPageState extends State<SportsListPage> {
    final dbHelper = DatabaseHelper.instance;
    List<Map<String, dynamic>> allTrainings = [
        {"date": "Lundi 11 Janvier", "type": "Full body", "time": "19h00 - 20h30", "duration": 90},
        {"date": "Mercredi 13 Février", "type": "Jambes", "time": "18h30 - 19h30", "duration": 60},
        {"date": "Jeudi 14 Mars", "type": "Bras", "time": "12h30 - 13h30", "duration": 60},
    ];
    List<Session> sessions = [];

    List<Map<String, dynamic>> filteredTrainings = [];

    @override
    void initState() {
        super.initState();
        _loadSessions();
        filteredTrainings = List.from(allTrainings);
    }

    Future<void> _loadSessions() async {
        final loadedSessions = await SessionTable.getAllSessions(dbHelper);
        setState(() {
            sessions = loadedSessions;
        });
    }

    void searchTrainings(String query) {
        setState(() {
            filteredTrainings = allTrainings.where((training) {
                final dateLower = training["date"].toLowerCase();
                final typeLower = training["type"].toLowerCase();
                final searchLower = query.toLowerCase();
                return dateLower.contains(searchLower) || typeLower.contains(searchLower);
            }).toList();
        });
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            body: SafeArea(
                child: Padding(
                    padding: const EdgeInsets.only(left: 10, right: 20, top: 20),
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


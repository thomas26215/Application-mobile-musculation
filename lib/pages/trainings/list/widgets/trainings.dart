import 'package:flutter/material.dart';
import 'package:muscu/text_styles.dart';
import 'package:unicons/unicons.dart';
import 'package:muscu/pages/trainings/list/widgets/search.dart';

class TrainingsWidget extends StatefulWidget {
  const TrainingsWidget({Key? key}) : super(key: key);

  @override
  _TrainingsWidgetState createState() => _TrainingsWidgetState();
}

class _TrainingsWidgetState extends State<TrainingsWidget> {
  final List<Map<String, dynamic>> allTrainings = [
    {"date": "Lundi 11 Janvier", "type": "Full body", "time": "19h00 - 20h30", "duration": 90},
    {"date": "Mercredi 13 Février", "type": "Jambes", "time": "18h30 - 19h30", "duration": 60},
    {"date": "Jeudi 14 Mars", "type": "Bras", "time": "12h30 - 13h30", "duration": 60},
  ];

  List<Map<String, dynamic>> filteredTrainings = [];

  @override
  void initState() {
    super.initState();
    filteredTrainings = List.from(allTrainings);
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
    return Column(
      children: [
        SearchWidget(onSearch: searchTrainings),
        Expanded(
          child: ListView.builder(
            itemCount: filteredTrainings.length,
            itemBuilder: (context, index) {
              final training = filteredTrainings[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(training["date"], style: AppTextStyles.titleMedium),
                            Text(training["type"], style: AppTextStyles.titleMedium),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.history, color: Colors.white70, size: 20),
                                const SizedBox(width: 4),
                                Text("Historique", style: AppTextStyles.bodySmall),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(Icons.timer, color: Colors.white70, size: 20),
                                const SizedBox(width: 4),
                                Text("${training["duration"]} min", style: AppTextStyles.bodySmall),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}


import 'package:flutter/material.dart';
import 'package:muscu/pages/trainings/detailsTraining/main.dart';
import 'package:muscu/styles/text_styles.dart';
import 'package:unicons/unicons.dart';
import 'package:muscu/pages/trainings/list/widgets/search.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TrainingsWidget extends StatefulWidget {
  final List<Map<String, dynamic>> filteredTrainings;

  const TrainingsWidget({Key? key, required this.filteredTrainings}) : super(key: key);

  @override
  _TrainingsWidgetState createState() => _TrainingsWidgetState();
}

class _TrainingsWidgetState extends State<TrainingsWidget> {
  void _onTrainingTap(Map<String, dynamic> training) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DetailPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SearchWidget(onSearch: (String query) {}),  // Vous devrez gérer la recherche dans le widget parent
        Expanded(
          child: ListView.builder(
            itemCount: widget.filteredTrainings.length,
            itemBuilder: (context, index) {
              final training = widget.filteredTrainings[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                child: InkWell(
                  onTap: () => _onTrainingTap(training),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(6),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 3,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          Icon(FontAwesomeIcons.dumbbell, size: 24, color: Colors.white70),
                          SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(training["date"], style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white)),
                                    Text(training["type"], style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white)),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).colorScheme.secondary,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(Icons.history, color: Colors.black, size: 16),
                                          const SizedBox(width: 2),
                                          Text("Historique", style: TextStyle(fontSize: 12, color: Colors.black)),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Icon(Icons.timer, color: Colors.white70, size: 16),
                                        const SizedBox(width: 2),
                                        Text("${training["duration"]} min", style: TextStyle(fontSize: 12, color: Colors.white70)),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
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


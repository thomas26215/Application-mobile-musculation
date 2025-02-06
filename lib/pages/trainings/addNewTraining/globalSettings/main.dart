import 'package:flutter/material.dart';
import 'package:unicons/unicons.dart';
import 'package:muscu/text_styles.dart'; // Assurez-vous que ce chemin d'importation est correct

class EditTrainingParametersPage extends StatefulWidget {
  final Map<String, dynamic> initialParameters;

  const EditTrainingParametersPage({Key? key, required this.initialParameters}) : super(key: key);

  @override
  _EditTrainingParametersPageState createState() => _EditTrainingParametersPageState();
}

class _EditTrainingParametersPageState extends State<EditTrainingParametersPage> {
  late String selectedTrainingType;
  late int duration;
  late String difficulty;

  @override
  void initState() {
    super.initState();
    selectedTrainingType = widget.initialParameters['type'];
    duration = widget.initialParameters['duration'];
    difficulty = widget.initialParameters['difficulty'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(UniconsLine.angle_left, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Paramètres de l\'entraînement', style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Type d\'entraînement', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white)),
            DropdownButton<String>(
              value: selectedTrainingType,
              isExpanded: true,
              dropdownColor: Colors.grey[800],
              style: AppTextStyles.bodySmall.copyWith(color: Colors.white70),
              items: <String>['Full Body', 'Split', 'HIIT', 'Cardio']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value, style: AppTextStyles.bodySmall.copyWith(color: Colors.white70)),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedTrainingType = newValue!;
                });
              },
            ),
            SizedBox(height: 20),
            Text('Durée (minutes)', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white)),
            Slider(
                  value: duration.toDouble(),
                  min: 15,
                  max: 120,
                  divisions: 7,
                  label: duration.toString(),
                  activeColor: Theme.of(context).colorScheme.secondary, // Partie mobile en vert
                  inactiveColor: Colors.grey[800], // Partie inactive en gris foncé
                  thumbColor: Theme.of(context).colorScheme.secondary, // Curseur en vert
                  onChanged: (double value) {
                    setState(() {
                      duration = value.round();
                    });
                  },
                ),

            SizedBox(height: 20),
            Text('Difficulté', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white)),
            DropdownButton<String>(
              value: difficulty,
              isExpanded: true,
              dropdownColor: Colors.grey[800],
              style: AppTextStyles.bodySmall.copyWith(color: Colors.white70),
              items: <String>['Débutant', 'Intermédiaire', 'Avancé', 'Expert']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value, style: AppTextStyles.bodyMedium),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  difficulty = newValue!;
                });
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pop({
            'type': selectedTrainingType,
            'duration': duration,
            'difficulty': difficulty,
          });
        },
        child: Icon(Icons.save, color: Colors.white),
      ),
    );
  }
}


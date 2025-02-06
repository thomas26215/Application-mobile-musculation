import 'package:flutter/material.dart';
import 'package:muscu/pages/trainings/addNewTraining/globalSettings/widgets/difficulty.dart';
import 'package:muscu/pages/trainings/addNewTraining/globalSettings/widgets/duration.dart';
import 'package:muscu/pages/trainings/addNewTraining/globalSettings/widgets/save.dart';
import 'package:muscu/pages/trainings/addNewTraining/globalSettings/widgets/training_type.dart';

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
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Paramètres de l\'entraînement', style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TrainingTypeWidget(
              selectedType: selectedTrainingType,
              onChanged: (newValue) => setState(() => selectedTrainingType = newValue),
            ),
            SizedBox(height: 20),
            DurationWidget(
              duration: duration,
              onChanged: (newValue) => setState(() => duration = newValue),
            ),
            SizedBox(height: 20),
            DifficultyWidget(
              difficulty: difficulty,
              onChanged: (newValue) => setState(() => difficulty = newValue),
            ),
          ],
        ),
      ),
      floatingActionButton: SaveButton(
        onPressed: () {
          Navigator.of(context).pop({
            'type': selectedTrainingType,
            'duration': duration,
            'difficulty': difficulty,
          });
        },
      ),
    );
  }
}


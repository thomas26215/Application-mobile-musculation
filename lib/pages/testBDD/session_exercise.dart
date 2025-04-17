import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'dart:convert';
import 'package:muscu/models/database_helper.dart';
import 'package:muscu/models/seance/session_exercise.dart';
import 'package:muscu/models/exercise/exercise.dart';
import 'package:muscu/models/seance/seance.dart';

class SessionExercisesPage extends StatefulWidget {
  const SessionExercisesPage({Key? key}) : super(key: key);

  @override
  State<SessionExercisesPage> createState() => _SessionExercisesPageState();
}

class _SessionExercisesPageState extends State<SessionExercisesPage> {
  final dbHelper = DatabaseHelper.instance;
  List<SessionExercise> sessionExercises = [];
  List<Exercise> exercises = [];
  List<Session> sessions = [];
  int? selectedSessionId;

  @override
  void initState() {
    super.initState();
    _loadSessions();
    _loadExercises();
  }

  Future<void> _loadSessions() async {
    final loaded = await SessionTable.getAllSessions(dbHelper);
    setState(() {
      sessions = loaded;
      if (sessions.isNotEmpty) {
        selectedSessionId = sessions.first.id;
        _loadSessionExercises();
      }
    });
  }

  Future<void> _loadSessionExercises() async {
    if (selectedSessionId == null) return;
    final loaded = await SessionExerciseTable.getSessionExercisesBySessionId(dbHelper, selectedSessionId!);
    setState(() {
      sessionExercises = loaded;
    });
  }

  Future<void> _loadExercises() async {
    final loaded = await ExerciseTable.getAllExercises(dbHelper);
    setState(() {
      exercises = loaded;
    });
  }

  String _getExerciseName(int exerciseId) {
    return exercises.firstWhereOrNull((e) => e.id == exerciseId)?.name ?? 'Exercise $exerciseId';
  }

  String _getSessionName(int sessionId) {
    return sessions.firstWhereOrNull((s) => s.id == sessionId)?.name ?? 'Session $sessionId';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Session Exercises'),
        actions: [
          if (sessions.isNotEmpty)
            DropdownButton<int>(
              value: selectedSessionId,
              items: sessions.map((session) => DropdownMenuItem(
                value: session.id,
                child: Text(session.name),
              )).toList(),
              onChanged: (val) {
                setState(() {
                  selectedSessionId = val;
                });
                _loadSessionExercises();
              },
            ),
        ],
      ),
      body: ListView.builder(
        itemCount: sessionExercises.length,
        itemBuilder: (context, index) {
          final se = sessionExercises[index];
          return Card(
            child: ListTile(
              title: Text(_getExerciseName(se.exerciseId)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Session: ${_getSessionName(se.sessionId)}'),
                  Text('Type: ${se.exerciseType.toString().split('.').last}'),
                  if (se.sets != null) Text('Sets: ${se.sets}'),
                  if (se.reps != null) Text('Reps: ${se.reps}'),
                  if (se.duration != null) Text('Duration: ${se.duration} sec'),
                  if (se.restTime != null) Text('Rest: ${se.restTime} sec'),
                  if (se.weight != null) Text('Weight: ${se.weight} kg'),
                  if (se.customData != null)
                    Text('Données spéciales: ${json.encode(se.customData)}'),
                ],
              ),
              trailing: IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () async {
                  await SessionExerciseTable.delete(dbHelper, se.id!);
                  _loadSessionExercises();
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: exercises.isEmpty || sessions.isEmpty ? null : () => _showAddSessionExerciseDialog(context),
        child: Icon(Icons.add),
      ),
    );
  }

  void _showAddSessionExerciseDialog(BuildContext context) {
    if (exercises.isEmpty || sessions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Veuillez charger les exercices et les sessions.')),
      );
      return;
    }

    int? selectedExerciseId;
    int? selectedDialogSessionId = selectedSessionId ?? sessions.first.id;
    ExerciseType selectedType = ExerciseType.standard;

    // Contrôleurs communs
    final setsController = TextEditingController();
    final repsController = TextEditingController();
    final durationController = TextEditingController();
    final restController = TextEditingController();
    final weightController = TextEditingController();

    // Contrôleurs spécifiques
    final initialWeightController = TextEditingController(); // DropSet
    final dropsControllers = <Map<String, TextEditingController>>[]; // DropSet
    final pyramidSetsControllers = <Map<String, TextEditingController>>[]; // Pyramid
    final tutTempoController = TextEditingController(); // TUT
    final superSetOrderController = TextEditingController(); // SuperSet
    final giantSetOrderController = TextEditingController(); // GiantSet
    final restPauseInitialRepsController = TextEditingController(); // RestPause
    final restPauseRestTimeController = TextEditingController(); // RestPause
    final restPauseSubsequentSetsController = TextEditingController(); // RestPause
    final clusterRepsPerClusterController = TextEditingController(); // Cluster
    final clusterClustersPerSetController = TextEditingController(); // Cluster
    final clusterRestBetweenClustersController = TextEditingController(); // Cluster
    final clusterWeightController = TextEditingController(); // Cluster

    void addDrop() {
      dropsControllers.add({
        'weight': TextEditingController(),
        'reps': TextEditingController(),
      });
    }

    void addPyramidSet() {
      pyramidSetsControllers.add({
        'weight': TextEditingController(),
        'reps': TextEditingController(),
      });
    }

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setState) {
            List<Widget> customFields = [];
            switch (selectedType) {
              case ExerciseType.standard:
                customFields = [
                  TextField(controller: setsController, decoration: InputDecoration(labelText: 'Sets'), keyboardType: TextInputType.number),
                  TextField(controller: repsController, decoration: InputDecoration(labelText: 'Reps'), keyboardType: TextInputType.number),
                  TextField(controller: weightController, decoration: InputDecoration(labelText: 'Poids (kg)'), keyboardType: TextInputType.numberWithOptions(decimal: true)),
                  TextField(controller: durationController, decoration: InputDecoration(labelText: 'Durée (sec)'), keyboardType: TextInputType.number),
                  TextField(controller: restController, decoration: InputDecoration(labelText: 'Repos (sec)'), keyboardType: TextInputType.number),
                ];
                break;

              case ExerciseType.dropSet:
                if (dropsControllers.isEmpty) addDrop();
                customFields = [
                  TextField(controller: setsController, decoration: InputDecoration(labelText: 'Sets'), keyboardType: TextInputType.number),
                  TextField(controller: initialWeightController, decoration: InputDecoration(labelText: 'Poids initial (kg)'), keyboardType: TextInputType.numberWithOptions(decimal: true)),
                  ...dropsControllers.asMap().entries.map((entry) {
                    int i = entry.key;
                    var ctrls = entry.value;
                    return Row(
                      children: [
                        Expanded(child: TextField(controller: ctrls['weight'], decoration: InputDecoration(labelText: "Poids drop #${i+1}"), keyboardType: TextInputType.numberWithOptions(decimal: true))),
                        SizedBox(width: 8),
                        Expanded(child: TextField(controller: ctrls['reps'], decoration: InputDecoration(labelText: "Reps drop #${i+1}"), keyboardType: TextInputType.number)),
                        IconButton(icon: Icon(Icons.remove_circle, color: Colors.red), onPressed: () { setState(() { dropsControllers.removeAt(i); }); }),
                      ],
                    );
                  }),
                  TextButton.icon(icon: Icon(Icons.add), label: Text("Ajouter un drop"), onPressed: () { setState(() { addDrop(); }); }),
                  TextField(controller: durationController, decoration: InputDecoration(labelText: 'Durée totale (sec)'), keyboardType: TextInputType.number),
                  TextField(controller: restController, decoration: InputDecoration(labelText: 'Repos (sec)'), keyboardType: TextInputType.number),
                ];
                break;

              case ExerciseType.pyramid:
                if (pyramidSetsControllers.isEmpty) addPyramidSet();
                customFields = [
                  ...pyramidSetsControllers.asMap().entries.map((entry) {
                    int i = entry.key;
                    var ctrls = entry.value;
                    return Row(
                      children: [
                        Expanded(child: TextField(controller: ctrls['weight'], decoration: InputDecoration(labelText: "Poids set #${i+1}"), keyboardType: TextInputType.numberWithOptions(decimal: true))),
                        SizedBox(width: 8),
                        Expanded(child: TextField(controller: ctrls['reps'], decoration: InputDecoration(labelText: "Reps set #${i+1}"), keyboardType: TextInputType.number)),
                        IconButton(icon: Icon(Icons.remove_circle, color: Colors.red), onPressed: () { setState(() { pyramidSetsControllers.removeAt(i); }); }),
                      ],
                    );
                  }),
                  TextButton.icon(icon: Icon(Icons.add), label: Text("Ajouter un set"), onPressed: () { setState(() { addPyramidSet(); }); }),
                  TextField(controller: durationController, decoration: InputDecoration(labelText: 'Durée totale (sec)'), keyboardType: TextInputType.number),
                  TextField(controller: restController, decoration: InputDecoration(labelText: 'Repos (sec)'), keyboardType: TextInputType.number),
                ];
                break;

              case ExerciseType.timeUnderTension:
                customFields = [
                  TextField(controller: setsController, decoration: InputDecoration(labelText: 'Sets'), keyboardType: TextInputType.number),
                  TextField(controller: durationController, decoration: InputDecoration(labelText: 'Durée (sec)'), keyboardType: TextInputType.number),
                  TextField(controller: tutTempoController, decoration: InputDecoration(labelText: 'Tempo (ex: 2-1-2-1)')),
                  TextField(controller: restController, decoration: InputDecoration(labelText: 'Repos (sec)'), keyboardType: TextInputType.number),
                ];
                break;

              case ExerciseType.superSet:
                customFields = [
                  TextField(controller: setsController, decoration: InputDecoration(labelText: 'Sets'), keyboardType: TextInputType.number),
                  TextField(controller: repsController, decoration: InputDecoration(labelText: 'Reps'), keyboardType: TextInputType.number),
                  TextField(controller: weightController, decoration: InputDecoration(labelText: 'Poids (kg)'), keyboardType: TextInputType.numberWithOptions(decimal: true)),
                  TextField(controller: superSetOrderController, decoration: InputDecoration(labelText: "Ordre dans le super set"), keyboardType: TextInputType.number),
                  TextField(controller: restController, decoration: InputDecoration(labelText: 'Repos (sec)'), keyboardType: TextInputType.number),
                ];
                break;

              case ExerciseType.giantSet:
                customFields = [
                  TextField(controller: setsController, decoration: InputDecoration(labelText: 'Sets'), keyboardType: TextInputType.number),
                  TextField(controller: repsController, decoration: InputDecoration(labelText: 'Reps'), keyboardType: TextInputType.number),
                  TextField(controller: giantSetOrderController, decoration: InputDecoration(labelText: "Ordre dans le giant set"), keyboardType: TextInputType.number),
                  TextField(controller: restController, decoration: InputDecoration(labelText: 'Repos (sec)'), keyboardType: TextInputType.number),
                ];
                break;

              case ExerciseType.restPause:
                customFields = [
                  TextField(controller: setsController, decoration: InputDecoration(labelText: 'Sets'), keyboardType: TextInputType.number),
                  TextField(controller: restPauseInitialRepsController, decoration: InputDecoration(labelText: "Reps initiales"), keyboardType: TextInputType.number),
                  TextField(controller: restPauseRestTimeController, decoration: InputDecoration(labelText: "Repos (sec)"), keyboardType: TextInputType.number),
                  TextField(controller: restPauseSubsequentSetsController, decoration: InputDecoration(labelText: "Reps des sets suivants (ex: 5,3,2)")),
                  TextField(controller: durationController, decoration: InputDecoration(labelText: 'Durée totale (sec)'), keyboardType: TextInputType.number),
                ];
                break;

              case ExerciseType.cluster:
                customFields = [
                  TextField(controller: setsController, decoration: InputDecoration(labelText: 'Sets'), keyboardType: TextInputType.number),
                  TextField(controller: clusterRepsPerClusterController, decoration: InputDecoration(labelText: "Reps par cluster"), keyboardType: TextInputType.number),
                  TextField(controller: clusterClustersPerSetController, decoration: InputDecoration(labelText: "Clusters par set"), keyboardType: TextInputType.number),
                  TextField(controller: clusterRestBetweenClustersController, decoration: InputDecoration(labelText: "Repos entre clusters (sec)"), keyboardType: TextInputType.number),
                  TextField(controller: clusterWeightController, decoration: InputDecoration(labelText: "Poids (kg)"), keyboardType: TextInputType.numberWithOptions(decimal: true)),
                  TextField(controller: restController, decoration: InputDecoration(labelText: 'Repos (sec)'), keyboardType: TextInputType.number),
                ];
                break;
            }

            return AlertDialog(
              title: Text('Add Session Exercise'),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    DropdownButtonFormField<int>(
                      decoration: InputDecoration(labelText: 'Session'),
                      value: selectedDialogSessionId,
                      items: sessions.map((s) => DropdownMenuItem(
                        value: s.id,
                        child: Text(s.name),
                      )).toList(),
                      onChanged: (val) => setState(() => selectedDialogSessionId = val),
                    ),
                    DropdownButtonFormField<int>(
                      decoration: InputDecoration(labelText: 'Exercise'),
                      value: selectedExerciseId,
                      items: exercises.map((e) => DropdownMenuItem(
                        value: e.id,
                        child: Text(e.name),
                      )).toList(),
                      onChanged: (val) => setState(() => selectedExerciseId = val),
                    ),
                    DropdownButtonFormField<ExerciseType>(
                      decoration: InputDecoration(labelText: 'Type'),
                      value: selectedType,
                      items: ExerciseType.values.map((e) => DropdownMenuItem(
                        value: e,
                        child: Text(e.toString().split('.').last),
                      )).toList(),
                      onChanged: (val) => setState(() => selectedType = val!),
                    ),
                    ...customFields,
                  ],
                ),
              ),
              actions: [
                TextButton(
                  child: Text('Cancel'),
                  onPressed: () => Navigator.pop(context),
                ),
                ElevatedButton(
                  child: Text('Add'),
                  onPressed: () async {
                    if (selectedExerciseId == null || selectedDialogSessionId == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Veuillez sélectionner une session et un exercice.')),
                      );
                      return;
                    }

                    Map<String, dynamic>? customData;
                    switch (selectedType) {
                      case ExerciseType.dropSet:
                        customData = {
                          'initial_weight': double.tryParse(initialWeightController.text),
                          'drops': dropsControllers.map((ctrls) => {
                            'weight': double.tryParse(ctrls['weight']!.text),
                            'reps': int.tryParse(ctrls['reps']!.text),
                          }).toList(),
                          'duration': int.tryParse(durationController.text),
                          'rest_time': int.tryParse(restController.text),
                        };
                        break;
                      case ExerciseType.pyramid:
                        customData = {
                          'sets': pyramidSetsControllers.map((ctrls) => {
                            'weight': double.tryParse(ctrls['weight']!.text),
                            'reps': int.tryParse(ctrls['reps']!.text),
                          }).toList(),
                          'duration': int.tryParse(durationController.text),
                          'rest_time': int.tryParse(restController.text),
                        };
                        break;
                      case ExerciseType.timeUnderTension:
                        customData = {
                          'duration': int.tryParse(durationController.text),
                          'tempo': tutTempoController.text,
                          'rest_time': int.tryParse(restController.text),
                        };
                        break;
                      case ExerciseType.superSet:
                        customData = {
                          'super_set_order': int.tryParse(superSetOrderController.text),
                          'rest_time': int.tryParse(restController.text),
                        };
                        break;
                      case ExerciseType.giantSet:
                        customData = {
                          'giant_set_order': int.tryParse(giantSetOrderController.text),
                          'rest_time': int.tryParse(restController.text),
                        };
                        break;
                      case ExerciseType.restPause:
                        customData = {
                          'initial_reps': int.tryParse(restPauseInitialRepsController.text),
                          'rest_time': int.tryParse(restPauseRestTimeController.text),
                          'subsequent_sets': restPauseSubsequentSetsController.text
                              .split(',')
                              .map((e) => int.tryParse(e.trim()))
                              .where((e) => e != null)
                              .toList(),
                          'duration': int.tryParse(durationController.text),
                        };
                        break;
                      case ExerciseType.cluster:
                        customData = {
                          'reps_per_cluster': int.tryParse(clusterRepsPerClusterController.text),
                          'clusters_per_set': int.tryParse(clusterClustersPerSetController.text),
                          'rest_between_clusters': int.tryParse(clusterRestBetweenClustersController.text),
                          'weight': double.tryParse(clusterWeightController.text),
                          'rest_time': int.tryParse(restController.text),
                        };
                        break;
                      default:
                        customData = null;
                    }

                    final newSE = SessionExercise(
                      sessionId: selectedDialogSessionId!,
                      exerciseId: selectedExerciseId!,
                      orderInSession: sessionExercises.length + 1,
                      sets: int.tryParse(setsController.text),
                      reps: int.tryParse(repsController.text),
                      duration: int.tryParse(durationController.text),
                      restTime: int.tryParse(restController.text),
                      weight: double.tryParse(weightController.text),
                      exerciseType: selectedType,
                      customData: customData,
                    );
                    await SessionExerciseTable.insert(dbHelper, newSE);
                    Navigator.pop(context);
                    _loadSessionExercises();
                  },
                ),
              ],
            );
          }
        );
      }
    );
  }
}


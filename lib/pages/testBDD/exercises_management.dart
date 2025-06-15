import 'package:flutter/material.dart';
import 'package:muscu/models/database_helper.dart';
import 'package:muscu/models/exercise/exercise.dart';
import 'package:muscu/models/utilisateur/utilisateurs.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';

class ExercisesManagementPage extends StatefulWidget {
  const ExercisesManagementPage({Key? key}) : super(key: key);

  @override
  _ExercisesManagementState createState() => _ExercisesManagementState();
}

class _ExercisesManagementState extends State<ExercisesManagementPage> {
  final dbHelper = DatabaseHelper.instance;
  List<Exercise> exercises = [];
  List<User> users = [];
  User? selectedUser;

  final List<String> exercisesType = ['Strength', 'Endurance'];

  @override
  void initState() {
    super.initState();
    _loadExercises();
    _loadUsers();
  }

  Future<void> _loadExercises() async {
    final loadedExercises = await ExerciseTable.getAllExercises(dbHelper);
    setState(() {
      exercises = loadedExercises;
    });
  }

  Future<void> _loadUsers() async {
    final loadedUsers = await UserTable.getAllUsers(dbHelper);
    setState(() {
      users = loadedUsers;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exercises Management'),
      ),
      body: ListView.builder(
        itemCount: exercises.length,
        itemBuilder: (context, index) {
          final exercise = exercises[index];
          return ListTile(
            title: Text(exercise.name,
                style: Theme.of(context).textTheme.displayMedium),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Description: ${exercise.description}'),
                Text('Type: ${exercise.type}'),
                Text(
                    'Created At: ${DateFormat('yyyy-MM-dd').format(exercise.createdAt!)}'),
              ],
            ),
            trailing: IconButton(
              icon: Icon(Icons.delete, color: Colors.white),
              onPressed: () async {
                await ExerciseTable.delete(dbHelper, exercise.id!);
                _loadExercises();
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _showAddExerciseDialog(context);
        },
      ),
    );
  }

  void _showAddExerciseDialog(BuildContext context) {
    final nomController = TextEditingController();
    final descriptionController = TextEditingController();
    User? localSelectedUser;
    String? localSelectedType;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: Text('Ajouter un exercice'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButton<User>(
                    hint: Text('Select User'),
                    onChanged: (User? value) {
                      setState(() {
                        localSelectedUser = value;
                      });
                    },
                    items: users.map((User user) {
                      return DropdownMenuItem<User>(
                        value: user,
                        child: Text(user.username),
                      );
                    }).toList(),
                  ),
                  TextField(
                    controller: nomController,
                    decoration: InputDecoration(labelText: 'Nom'),
                  ),
                  TextField(
                    controller: descriptionController,
                    decoration: InputDecoration(labelText: 'Description'),
                  ),
                  DropdownButton<String>(
                    hint: Text('Select Type'),
                    onChanged: (String? value) {
                      setState(() {
                        localSelectedType = value;
                      });
                    },
                    items: exercisesType.map((String type) {
                      return DropdownMenuItem(
                        value: type,
                        child: Text(type),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                child: Text('Annuler'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              ElevatedButton(
                child: Text('Ajouter'),
                onPressed: () async {
                  if (localSelectedUser == null || nomController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please fill all fields')),
                    );
                    return;
                  }
                  final newExercise = Exercise(
                    name: nomController.text,
                    description: descriptionController.text,
                    type: localSelectedType!,
                    isPublic: false,
                    createdAt: DateTime.now(),
                  );
                  await ExerciseTable.insert(dbHelper, newExercise);
                  Navigator.of(context).pop();
                  _loadExercises();
                },
              ),
            ],
          );
        });
      },
    );
  }
}


import 'package:flutter/material.dart';
import 'package:muscu/pages/dashboard/main.dart';
import 'package:muscu/pages/testBDD/exercises_management.dart';
import 'package:muscu/pages/testBDD/session_exercise.dart';
import 'package:muscu/pages/testBDD/user_management.dart';
import 'package:muscu/pages/testBDD/session_management.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Muscu App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DashBoardPage()),
                );
              },
              child: Text('Dashboard'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UserManagementPage()),
                );
              },
              child: Text('Gestion des utilisateurs'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SessionManagementPage()),
                );
              },
              child: Text('Gestion des sessions'),
            ),
            ElevatedButton(
                onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ExercisesManagementPage()),
                    );
                },
                child: Text('Gestion des exercices'),
            ),
            ElevatedButton(onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SessionExercisesPage()),
                );
            }, child: Text('Gestion des exercices de la séance')),
          ],
        ),
      ),
    );
  }
}


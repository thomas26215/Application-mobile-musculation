import 'package:flutter/material.dart';
import 'package:muscu/pages/trainings/main.dart';
import 'widgets/next_training.dart';
import 'widgets/sport_list.dart';
import '../trainings/pages/trainingsPage.dart';
import 'package:unicons/unicons.dart';


class DashBoardPage extends StatelessWidget {
  const DashBoardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 30, right: 30, top: 50),
          child: Column(
            children: [
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Training",
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                  const Icon(
                    UniconsSolid.apps,
                    color: Colors.white,
                    size: 30,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const SportListWidget(),
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Next trainings",
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => TrainingsTabs()),
                      );
                    },
                    child: const Icon(
                      UniconsSolid.apps,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ],
              ),
              const NextTraining(),
              // Vous pouvez ajouter d'autres widgets ici
            ],
          ),
        ),
      ),
      // Vous pouvez ajouter un bottomNavigationBar ici si nécessaire
    );
  }
}


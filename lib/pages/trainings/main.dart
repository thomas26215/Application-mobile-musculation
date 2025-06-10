import 'package:flutter/material.dart';
import 'package:muscu/pages/testBDD/exercises_management.dart';
import 'package:muscu/pages/trainings/pages/exercisesPages.dart';
import 'package:muscu/pages/trainings/pages/trainingsPage.dart';

class TrainingsTabs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        // Fond global hérité du thème
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Column(
          children: [
            // Padding au-dessus des tabs
            const SizedBox(height: 60),
            // Onglets personnalisés avec fond et ombre
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Theme.of(context).appBarTheme.backgroundColor ?? Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: TabBar(
                indicator: BoxDecoration(
                  color: Colors.white, // Fond de l'onglet sélectionné
                  borderRadius: BorderRadius.circular(8),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: Theme.of(context).appBarTheme.backgroundColor ?? Theme.of(context).primaryColor, // Texte sélectionné
                unselectedLabelColor: Colors.white, // Texte non sélectionné
                tabs: const [
                  Tab(text: 'Sessions', height: 35),
                  Tab(text: 'Exercises', height: 35),
                ],
              ),
            ),
            // Contenu des onglets
            Expanded(
              child: Container(
                color: Theme.of(context).scaffoldBackgroundColor, // Fond uniforme
                child: const TabBarView(
                  children: [
                    SportsListPage(),
                    ExercisesListPage(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


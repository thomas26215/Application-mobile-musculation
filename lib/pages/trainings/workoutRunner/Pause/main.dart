import 'package:flutter/material.dart';
import 'package:muscu/models/seance/seance.dart';
import 'package:muscu/pages/trainings/workoutRunner/datas/ActualExercise.dart';
import 'package:muscu/styles/text_styles.dart';
import 'package:unicons/unicons.dart';
import 'dart:async';

class PausePage extends StatefulWidget {
    final ActualExercise? actualExercise;
    final Session? session;
  final int initialSeconds;

  const PausePage({super.key, this.actualExercise, this.session, this.initialSeconds = 60});

  @override
  State<PausePage> createState() => _PausePageState();
}

class _PausePageState extends State<PausePage> {
  late int secondsLeft;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    secondsLeft = widget.initialSeconds;
    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (secondsLeft > 0) {
        setState(() {
          secondsLeft--;
        });
      } else {
        timer?.cancel();
        // Action à la fin de la pause si besoin
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  String formatTime(int seconds) {
    final min = (seconds ~/ 60).toString().padLeft(2, '0');
    final sec = (seconds % 60).toString().padLeft(2, '0');
    return '$min:$sec';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Utilise la couleur de fond du thème (bleu si défini ainsi dans ton ThemeData)
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 50),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      UniconsLine.angle_left,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                  Text(
                    "Pause",
                    style: AppTextStyles.titleMedium.copyWith(fontSize: 22),
                  ),
                  Icon(
                    UniconsLine.setting,
                    color: Colors.white,
                    size: 32,
                  ),
                ],
              ),
              const SizedBox(height: 40),

              // Timer & Infos
              Center(
                child: Column(
                  children: [
                    const Icon(
                      UniconsLine.bed,
                      color: Colors.white,
                      size: 80,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Temps de pause restant",
                      style: AppTextStyles.titleMedium.copyWith(fontSize: 17),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      formatTime(secondsLeft),
                      style: AppTextStyles.titleMedium.copyWith(
                        fontSize: 50,
                        color: Theme.of(context).colorScheme.secondary, // Couleur bleue du thème
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),
              Divider(
                color: Colors.white54,
                thickness: 2,
                indent: 10,
                endIndent: 10,
              ),
              const SizedBox(height: 30),

              // Bouton secondaire
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(UniconsLine.exit, color: Colors.white),
                    label: const Text(
                      "Quitter la pause",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
          child: SizedBox(
            width: double.infinity,
            height: 60,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.secondary, // Bleu du thème
                foregroundColor: const Color(0xFF223B65),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                elevation: 6,
                textStyle: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () => Navigator.pop(context),
              icon: const Icon(UniconsLine.play),
              label: const Text("Reprendre"),
            ),
          ),
        ),
      ),
    );
  }
}


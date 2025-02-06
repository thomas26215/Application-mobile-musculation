import 'package:flutter/material.dart';
import 'package:unicons/unicons.dart';
import 'package:muscu/pages/trainings/addNewTraining/widgets/note.dart';
import 'package:muscu/pages/trainings/addNewTraining/globalSettings/main.dart';
import 'package:muscu/pages/trainings/addNewTraining/addExercise/main.dart';

class AddNewTrainingPage extends StatefulWidget {
	const AddNewTrainingPage({Key? key}) : super(key: key);

	@override
	_AddNewTrainingPageState createState() => _AddNewTrainingPageState();
}

class _AddNewTrainingPageState extends State<AddNewTrainingPage> {
	String trainingName = "";
	Map<String, dynamic> trainingParameters = {
		'type': 'Full Body',
		'duration': 60,
		'difficulty': 'Intermédiaire',
	};
	List<Exercise> exercises = [];

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			body: Padding(
				padding: const EdgeInsets.only(left: 20, right: 20, top: 50),
				child: Column(
					crossAxisAlignment: CrossAxisAlignment.start,
					children: [
						Row(
							children: [
								GestureDetector(
									onTap: () {
										Navigator.pop(context);
									},
									child: const Icon(
										UniconsLine.angle_left,
										color: Colors.white,
										size: 40,
									),
								),
								Expanded(
									child: TextField(
										style: Theme.of(context).textTheme.displayLarge?.copyWith(color: Colors.white),
										decoration: InputDecoration(
											hintText: "Nom de l'entraînement",
											hintStyle: Theme.of(context).textTheme.displayLarge?.copyWith(color: Colors.white54),
											border: UnderlineInputBorder(
												borderSide: BorderSide(color: Colors.white),
											),
											enabledBorder: UnderlineInputBorder(
												borderSide: BorderSide(color: Colors.white),
											),
											focusedBorder: UnderlineInputBorder(
												borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
											),
										),
										onChanged: (value) {
											setState(() {
												trainingName = value;
											});
										},
									),
								),
							],
						),
						SizedBox(height: 20),
						GestureDetector(
							onTap: () async {
								final result = await Navigator.push(
									context,
									MaterialPageRoute(builder: (context) => EditTrainingParametersPage(
										initialParameters: trainingParameters,
									)),
								);
								if (result != null) {
									setState(() {
										trainingParameters = result;
									});
								}
							},
							child: Container(
								padding: EdgeInsets.all(16),
								decoration: BoxDecoration(
									color: Theme.of(context).colorScheme.secondary,
									borderRadius: BorderRadius.circular(10),
								),
								child: Row(
									mainAxisAlignment: MainAxisAlignment.spaceBetween,
									children: [
										Text(
											"Paramètres généraux",
											style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.black),
										),
										Icon(
											Icons.arrow_forward_ios,
											color: Colors.black,
										),
									],
								),
							),
						),
						SizedBox(height: 20),
						NoteWidget(),
						SizedBox(height: 20),
						ExerciseWidget(exercises: exercises),
					],
				),
			),
			floatingActionButton: FloatingActionButton.extended(
				onPressed: () {
					setState(() {
						exercises.add(Exercise(
							name: "Nouvel exercice",
							sets: [ExerciseSet(reps: 10, weight: 0)],
							restTime: 60,
							type: ExerciseType.standard,
						));
					});
				},
				label: Text(
					"Add new exercise",
					style: Theme.of(context).textTheme.displayMedium,
				),
				backgroundColor: Theme.of(context).colorScheme.primary,
			),
			floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
		);
	}
}


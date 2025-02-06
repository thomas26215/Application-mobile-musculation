import 'package:flutter/material.dart';
import 'package:unicons/unicons.dart';
import 'package:muscu/text_styles.dart';

class NextTraining extends StatelessWidget {
    const NextTraining({super.key});

    @override
    Widget build(BuildContext context) {
        final List<String> items = ["Lundi 11 Janvier", "Mercredi 13 Février", "Jeudi 14 Mars", "Vendredi 15 Avril", "Samedi 16 Mai", "Dimanche 17 Juin", "Lundi 18 Juillet"];
        final List<String> time = ["19h00 - 20h30", "18h30 - 19h30", "12h30 - 13h30", "20h00 - 21h00", "19h30 - 20h30", "10h00 - 11h00", "18h00 - 19h00"];
        final List<String> type = ["Full body", "Jambes", "Bras", "Abdos", "Dos", "Pecs", "Cardio"];
        final List<int> timePractice = [90, 60, 60, 60, 60, 60, 60];
        final int maxItems = 7;
        final limitedItems = items.take(maxItems).toList();

        return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: limitedItems.length,
            itemBuilder: (context, index) {
                return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                    child: Container(
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(7),
                            boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    offset: Offset(0, 3),
                                    blurRadius: 15,
                                    spreadRadius: 10,
                                ),
                            ],
                        ),
                        child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                    Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                            Text(limitedItems[index], style: AppTextStyles.titleMedium),
                                            Text(type[index], style: AppTextStyles.titleMedium),
                                        ],
                                    ),
                                    Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                            Text(time[index], style: AppTextStyles.bodyMedium),
                                            Row(
                                                children: [
                                                    Icon(UniconsLine.stopwatch, color: Colors.white70, size: 20),
                                                    SizedBox(width: 4),
                                                    Text("${timePractice[index]} min", style: AppTextStyles.bodySmall),
                                                ],
                                            ),
                                        ],
                                    ),
                                ],
                            ),
                        ),
                    ),
                );
            },
        );
    }
}


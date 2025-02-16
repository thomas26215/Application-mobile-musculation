import 'package:flutter/material.dart';
import 'package:muscu/styles/text_styles.dart';

class GlobalIndications extends StatelessWidget {
    const GlobalIndications({super.key});

    @override
    Widget build(BuildContext context) {

        return Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.5), // Augmentation de l'opacité
                            offset: Offset(0, 4), // Légère augmentation du décalage vertical
                            blurRadius: 15,
                            spreadRadius: 4, // Ajout d'un spreadRadius
                        ),
                    ],
                ),
                child: Padding(
                   padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15), 
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                            Column(
                                children: [
                                    Text(
                                        "Series",
                                        style: AppTextStyles.titleMedium.copyWith(fontSize: 20),
                                    ),
                                    Text(
                                        "3/4",
                                        style: AppTextStyles.titleMedium.copyWith(fontSize: 20),
                                    ),
                                ],
                            ),
                            Column(
                                children: [
                                    Text(
                                        "Répétitions",
                                        style: AppTextStyles.titleMedium.copyWith(fontSize: 20),
                                    ),
                                    Text(
                                        "12",
                                        style: AppTextStyles.titleMedium.copyWith(fontSize: 20),
                                    ),
                                ],
                            ),
                            Column(
                                children: [
                                    Text(
                                        "Charge",
                                        style: AppTextStyles.titleMedium.copyWith(fontSize: 20),
                                    ),
                                    Text(
                                        "2 X 6",
                                        style: AppTextStyles.titleMedium.copyWith(fontSize: 20),
                                    ),
                                ],
                            ),
                        ],
                    ),
                ),
            )
        );
    }
}


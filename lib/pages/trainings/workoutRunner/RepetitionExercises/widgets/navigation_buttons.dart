import 'package:flutter/material.dart';

class NavigationButtons extends StatelessWidget {

    const NavigationButtons({super.key});

    @override
    Widget build(BuildContext context) {
        return Row(
            children: [
                Expanded(
                    child: Padding(
                        padding: EdgeInsets.only(left: 10, right: 5),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                ),
                            ),
                            onPressed: () {
                                // Action pour le premier bouton
                            },
                            child: Text(
                                'Failed',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                ),
                            ),
                        ),
                    ),
                ),
                SizedBox(width: 10),
                Expanded(
                    child: Padding(
                        padding: EdgeInsets.only(left: 5, right: 10),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                ),
                            ),
                            onPressed: () {
                                // Action pour le deuxième bouton
                            },
                            child: Text(
                                'Successed',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                ),
                            ),
                        ),
                    ),
                ),
            ],
        );
    }
}

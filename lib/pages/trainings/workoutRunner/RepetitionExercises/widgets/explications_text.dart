import 'package:flutter/material.dart';
import 'package:muscu/styles/text_styles.dart';

class ExplicationsText extends StatelessWidget {

    final String exerciseDescription;

  const ExplicationsText({super.key, required this.exerciseDescription});

    @override
    Widget build(BuildContext context) {
        return Expanded(
            child: SingleChildScrollView(
                child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                        exerciseDescription,
                        style: AppTextStyles.bodySmall,
                    ),
                ),
            ),
        );
    }
}

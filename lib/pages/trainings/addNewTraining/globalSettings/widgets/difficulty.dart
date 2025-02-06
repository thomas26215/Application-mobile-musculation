import 'package:flutter/material.dart';
import 'package:muscu/text_styles.dart';

class DifficultyWidget extends StatelessWidget {
  final String difficulty;
  final ValueChanged<String> onChanged;

  const DifficultyWidget({Key? key, required this.difficulty, required this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Difficulté', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white)),
        SizedBox(height: 8),
        DropdownButton<String>(
          value: difficulty,
          isExpanded: true,
          dropdownColor: Colors.grey[800],
          style: AppTextStyles.bodySmall.copyWith(color: Colors.white70),
          items: <String>['Débutant', 'Intermédiaire', 'Avancé', 'Expert']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value, style: AppTextStyles.bodyMedium),
            );
          }).toList(),
          onChanged: (String? newValue) {
            if (newValue != null) {
              onChanged(newValue);
            }
          },
        ),
      ],
    );
  }
}


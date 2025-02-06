import 'package:flutter/material.dart';
import 'package:muscu/text_styles.dart';

class TrainingTypeWidget extends StatelessWidget {
  final String selectedType;
  final ValueChanged<String> onChanged;

  const TrainingTypeWidget({Key? key, required this.selectedType, required this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Type d\'entraînement', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white)),
        SizedBox(height: 8),
        DropdownButton<String>(
          value: selectedType,
          isExpanded: true,
          dropdownColor: Colors.grey[800],
          style: AppTextStyles.bodySmall.copyWith(color: Colors.white70),
          items: <String>['Full Body', 'Split', 'HIIT', 'Cardio']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value, style: AppTextStyles.bodySmall.copyWith(color: Colors.white70)),
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


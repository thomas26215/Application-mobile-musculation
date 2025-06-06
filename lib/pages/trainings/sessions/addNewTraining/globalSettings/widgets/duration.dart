import 'package:flutter/material.dart';

class DurationWidget extends StatelessWidget {
  final int duration;
  final ValueChanged<int> onChanged;

  const DurationWidget({Key? key, required this.duration, required this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Durée (minutes)', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white)),
        SizedBox(height: 8),
        Slider(
          value: duration.toDouble(),
          min: 15,
          max: 120,
          divisions: 7,
          label: duration.toString(),
          activeColor: Theme.of(context).colorScheme.secondary,
          inactiveColor: Colors.grey[800],
          thumbColor: Theme.of(context).colorScheme.secondary,
          onChanged: (double newValue) {
            onChanged(newValue.round());
          },
        ),
      ],
    );
  }
}


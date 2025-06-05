import 'package:flutter/material.dart';
import 'package:unicons/unicons.dart';

class Header extends StatelessWidget {
  const Header({
    Key? key,
    required this.trainingName,
    required this.onChanged,
  }) : super(key: key);

  final String trainingName;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
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
                borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
            ),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}

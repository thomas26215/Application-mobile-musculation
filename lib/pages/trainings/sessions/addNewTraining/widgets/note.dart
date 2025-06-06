import 'package:flutter/material.dart';
import 'package:muscu/styles/text_styles.dart';

class NoteWidget extends StatelessWidget {
  const NoteWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4.0,
              spreadRadius: 1.0,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: TextField(
            maxLines: null,
            keyboardType: TextInputType.multiline,
            style: AppTextStyles.bodyMedium.copyWith(color: Colors.white), // Correction ici
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              hintText: "Enter your note here...",
              hintStyle: AppTextStyles.bodySmall,
              border: InputBorder.none,
            ),
          ),
        ),
      ),
    );
  }
}


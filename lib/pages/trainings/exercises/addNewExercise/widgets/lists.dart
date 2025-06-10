import 'package:flutter/material.dart';
import 'package:muscu/styles/text_styles.dart';

// Exemple : largeur fixe de 220 pour chaque DropdownButton
class Lists extends StatefulWidget {
  final ValueChanged<String> onValueChanged;

  const Lists({required this.onValueChanged, Key? key}) : super(key: key);

  @override
  _ListsState createState() => _ListsState();
}

class _ListsState extends State<Lists> {
  String? selectedType;
  String? selectedLevel;

  final List<String> exerciseTypes = ['Cardio', 'Force', 'Souplesse', 'Endurance'];
  final List<String> equipment = ['Débutant', 'Intermédiaire', 'Avancé'];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(left: 5, right: 5),
        child: Column(
          children: [
            // Première ligne
            Row(
              children: [
                Expanded(
                  child: Text(
                    "Type d'exercice : ",
                    style: AppTextStyles.titleMedium.copyWith(fontSize: 20),
                  ),
                ),
                Container(
                  width: 160, // Largeur fixe ici
                  height: 35,
                  decoration: BoxDecoration(
                    color: Colors.blueGrey[800],
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 6,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: DropdownButton<String>(
                    value: selectedType,
                    dropdownColor: Colors.blueGrey[900],
                    icon: Icon(Icons.arrow_drop_down, color: Colors.white),
                    underline: SizedBox(),
                    style: TextStyle(color: Colors.white, fontSize: 18),
                    hint: Text('Sélectionnez', style: TextStyle(color: Colors.white70)),
                    isExpanded: true, // Pour que le Dropdown prenne toute la largeur du Container
                    items: exerciseTypes.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value, style: TextStyle(color: Colors.white)),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedType = newValue;
                      });
                      if (newValue != null) {
                        widget.onValueChanged(newValue);
                      }
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 4),
            // Deuxième ligne
            Row(
              children: [
                Expanded(
                  child: Text(
                    "Equipement : ",
                    style: AppTextStyles.titleMedium.copyWith(fontSize: 20),
                  ),
                ),
                Container(
                  width: 160, // Largeur fixe ici aussi
                  height: 35,
                  decoration: BoxDecoration(
                    color: Colors.blueGrey[800],
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 6,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: DropdownButton<String>(
                    value: selectedLevel,
                    dropdownColor: Colors.blueGrey[900],
                    icon: Icon(Icons.arrow_drop_down, color: Colors.white),
                    underline: SizedBox(),
                    style: TextStyle(color: Colors.white, fontSize: 18),
                    hint: Text('Sélectionnez', style: TextStyle(color: Colors.white70)),
                    isExpanded: true,
                    items: equipment.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value, style: TextStyle(color: Colors.white)),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedLevel = newValue;
                      });
                      if (newValue != null) {
                        widget.onValueChanged(newValue);
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


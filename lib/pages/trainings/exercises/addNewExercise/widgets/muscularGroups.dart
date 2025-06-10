import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:muscu/styles/text_styles.dart';
import 'package:muscu/pages/trainings/exercises/addNewExercise/datas/MuscularGroupEntry.dart';

class MuscularGroups extends StatefulWidget {
  final List<MuscularGroupEntry> initialGroups;
  final ValueChanged<List<MuscularGroupEntry>> onValueChanged;

  const MuscularGroups({
    required this.initialGroups,
    required this.onValueChanged,
    Key? key,
  }) : super(key: key);

  @override
  State<MuscularGroups> createState() => _MuscularGroupsState();
}

class _MuscularGroupsState extends State<MuscularGroups> {
  late List<MuscularGroupEntry> groups;
  final List<TextEditingController> _controllers = [];

  final List<String> availableGroups = [
    'Pectoraux',
    'Dos',
    'Jambes',
    'Épaules',
    'Bras',
    'Abdominaux',
  ];

  @override
  void initState() {
    super.initState();
    groups = List.from(widget.initialGroups);
    _controllers.addAll(groups.map((g) => TextEditingController(text: g.value ?? '')));
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _updateGroupValue(int index, String newValue) {
    setState(() {
      groups[index] = groups[index].copyWith(value: newValue);
    });
    widget.onValueChanged(groups);
  }

  void _updateGroupName(int index, String newName) {
    setState(() {
      groups[index] = groups[index].copyWith(name: newName);
    });
    widget.onValueChanged(groups);
  }

  void _removeGroup(int index) {
    setState(() {
      groups.removeAt(index);
      _controllers.removeAt(index);
    });
    widget.onValueChanged(groups);
  }

  void _addGroup() {
    setState(() {
      groups.add(MuscularGroupEntry(name: availableGroups.first, value: "0"));
      _controllers.add(TextEditingController(text: "0"));
    });
    widget.onValueChanged(groups);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...groups.asMap().entries.map((entry) {
          final index = entry.key;
          final group = entry.value;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              children: [
                // DropdownButton pour choisir le groupe musculaire
                Expanded(
                  flex: 3,
                  child: Container(
                    height: 48,
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
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: DropdownButton<String>(
                      value: group.name ?? availableGroups.first,
                      dropdownColor: Colors.blueGrey[900],
                      icon: Icon(Icons.arrow_drop_down, color: Colors.white),
                      underline: SizedBox(),
                      style: AppTextStyles.titleMedium.copyWith(color: Colors.white, fontSize: 18),
                      items: availableGroups.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value, style: TextStyle(color: Colors.white)),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          _updateGroupName(index, newValue);
                        }
                      },
                    ),
                  ),
                ),
                // TextField stylisé avec hauteur contrôlée
                Expanded(
                  flex: 2,
                  child: Container(
                    height: 48,
                    margin: EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Center(
                      child: TextField(
                        controller: _controllers[index],
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        style: AppTextStyles.titleMedium.copyWith(color: Colors.white),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Valeur (%)",
                          labelStyle: AppTextStyles.bodySmall.copyWith(color: Colors.white70),
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                              width: 3.0,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey,
                              width: 2.0,
                            ),
                          ),
                          filled: false, // Pas de fond coloré parasite
                        ),
                        onChanged: (val) => _updateGroupValue(index, val),
                      ),
                    ),
                  ),
                ),
                // Carré rouge avec poubelle
                SizedBox(
                  height: 48,
                  width: 48,
                  child: Material(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(4),
                    child: InkWell(
                      onTap: () => _removeGroup(index),
                      child: Icon(Icons.delete, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
        SizedBox(height: 8),
        // Bouton aligné à gauche
        Row(
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey[800],
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
              ),
              onPressed: _addGroup,
              child: Text("Ajouter un groupe"),
            ),
          ],
        ),
      ],
    );
  }
}


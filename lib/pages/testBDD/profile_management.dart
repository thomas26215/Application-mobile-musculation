import 'package:flutter/material.dart';
import 'package:muscu/models/database_helper.dart';
import 'package:muscu/models/utilisateur/profils.dart';
import 'package:muscu/models/utilisateur/utilisateurs.dart';
import 'package:intl/intl.dart';

class ProfileManagementPage extends StatefulWidget {
  @override
  _ProfileManagementPageState createState() => _ProfileManagementPageState();
}

class _ProfileManagementPageState extends State<ProfileManagementPage> {
  final dbHelper = DatabaseHelper.instance;
  List<Profil> profiles = [];
  List<User> users = [];
  User? selectedUser;

  @override
  void initState() {
    super.initState();
    _loadProfiles();
    _loadUsers();
  }

  Future<void> _loadProfiles() async {
    final loadedProfiles = await ProfilTable.getAllProfils(dbHelper);
    setState(() {
      profiles = loadedProfiles;
    });
  }

  Future<void> _loadUsers() async {
    final loadedUsers = await UserTable.getAllUsers(dbHelper);
    setState(() {
      users = loadedUsers;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestion des profils'),
      ),
      body: ListView.builder(
        itemCount: profiles.length,
        itemBuilder: (context, index) {
          final profile = profiles[index];
          return ListTile(
            title: Text('${profile.prenom} ${profile.nom}', style: Theme.of(context).textTheme.displayMedium),
            subtitle: Text('Né(e) le ${profile.dateNaissance.toString().split(' ')[0]}', style: Theme.of(context).textTheme.displaySmall),
            trailing: IconButton(
              icon: Icon(Icons.delete, color: Colors.white),
              onPressed: () async {
                await ProfilTable.delete(dbHelper, profile.id!);
                _loadProfiles();
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _showAddProfileDialog(context);
        },
      ),
    );
  }

  void _showAddProfileDialog(BuildContext context) {
    final nomController = TextEditingController();
    final prenomController = TextEditingController();
    final sexeController = TextEditingController();
    final biographieController = TextEditingController();
    DateTime? selectedDate;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Ajouter un profil'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButton<User>(
                      value: selectedUser,
                      hint: Text('Sélectionner un utilisateur'),
                      onChanged: (User? value) {
                        setState(() {
                          selectedUser = value;
                        });
                      },
                      items: users.map((User user) {
                        return DropdownMenuItem<User>(
                          value: user,
                          child: Text(user.username),
                        );
                      }).toList(),
                    ),
                    TextField(
                      controller: nomController,
                      decoration: InputDecoration(labelText: 'Nom'),
                    ),
                    TextField(
                      controller: prenomController,
                      decoration: InputDecoration(labelText: 'Prénom'),
                    ),
                    ElevatedButton(
                      child: Text(selectedDate == null 
                        ? 'Sélectionner la date de naissance' 
                        : 'Date de naissance: ${DateFormat('yyyy-MM-dd').format(selectedDate!)}'),
                      onPressed: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        );
                        if (picked != null && picked != selectedDate) {
                          setState(() {
                            selectedDate = picked;
                          });
                        }
                      },
                    ),
                    TextField(
                      controller: sexeController,
                      decoration: InputDecoration(labelText: 'Sexe (M/F)'),
                      maxLength: 1,
                    ),
                    TextField(
                      controller: biographieController,
                      decoration: InputDecoration(labelText: 'Biographie'),
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  child: Text('Annuler'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                ElevatedButton(
                  child: Text('Ajouter'),
                  onPressed: () async {
                    if (selectedDate == null || selectedUser == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Veuillez remplir tous les champs obligatoires')),
                      );
                      return;
                    }
                    final newProfil = Profil(
                      userId: selectedUser!.id!,
                      nom: nomController.text,
                      prenom: prenomController.text,
                      dateNaissance: selectedDate!,
                      sexe: sexeController.text,
                      biographie: biographieController.text,
                    );
                    await ProfilTable.insert(dbHelper, newProfil);
                    Navigator.of(context).pop();
                    _loadProfiles();
                  },
                ),
              ],
            );
          }
        );
      },
    );
  }
}


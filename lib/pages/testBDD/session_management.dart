import 'package:flutter/material.dart';
import 'package:muscu/models/database_helper.dart';
import 'package:muscu/models/seance/seance.dart';
import 'package:muscu/models/utilisateur/utilisateurs.dart';
import 'package:intl/intl.dart';

class SessionManagementPage extends StatefulWidget {
  @override
  _SessionManagementPageState createState() => _SessionManagementPageState();
}

class _SessionManagementPageState extends State<SessionManagementPage> {
  final dbHelper = DatabaseHelper.instance;
  List<Session> sessions = [];
  List<User> users = [];
  User? selectedUser;
  String? selectedType;

  final List<String> sessionTypes = ['Musculation', 'Cardio', 'Stretching', 'Autre'];

  @override
  void initState() {
    super.initState();
    _loadSessions();
    _loadUsers();
  }

  Future<void> _loadSessions() async {
    final loadedSessions = await SessionTable.getAllSessions(dbHelper);
    setState(() {
      sessions = loadedSessions;
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
        title: Text('Gestion des sessions'),
      ),
      body: ListView.builder(
        itemCount: sessions.length,
        itemBuilder: (context, index) {
          final session = sessions[index];
          return ListTile(
            title: Text(session.name, style: Theme.of(context).textTheme.displayMedium),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Type: ${session.type ?? "Non spécifié"}', style: Theme.of(context).textTheme.displaySmall),
                Text('Créée le ${DateFormat('yyyy-MM-dd').format(session.createdAt)}', style: Theme.of(context).textTheme.displaySmall),
              ],
            ),
            trailing: IconButton(
              icon: Icon(Icons.delete, color: Colors.white),
              onPressed: () async {
                await SessionTable.delete(dbHelper, session.id!);
                _loadSessions();
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _showAddSessionDialog(context);
        },
      ),
    );
  }

  void _showAddSessionDialog(BuildContext context) {
    final nomController = TextEditingController();
    final descriptionController = TextEditingController();
    User? localSelectedUser;
    String? localSelectedType;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Ajouter une session'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButton<User>(
                      value: localSelectedUser,
                      hint: Text('Sélectionner un utilisateur'),
                      onChanged: (User? value) {
                        setState(() {
                          localSelectedUser = value;
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
                      decoration: InputDecoration(labelText: 'Nom de la session'),
                    ),
                    DropdownButton<String>(
                      value: localSelectedType,
                      hint: Text('Sélectionner un type'),
                      onChanged: (String? value) {
                        setState(() {
                          localSelectedType = value;
                        });
                      },
                      items: sessionTypes.map((String type) {
                        return DropdownMenuItem<String>(
                          value: type,
                          child: Text(type),
                        );
                      }).toList(),
                    ),
                    TextField(
                      controller: descriptionController,
                      decoration: InputDecoration(labelText: 'Description'),
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
                    if (localSelectedUser == null || nomController.text.isEmpty || localSelectedType == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Veuillez remplir tous les champs obligatoires')),
                      );
                      return;
                    }
                    final newSession = Session(
                      name: nomController.text,
                      type: localSelectedType,
                      description: descriptionController.text,
                    );
                    await SessionTable.insert(dbHelper, newSession);
                    Navigator.of(context).pop();
                    _loadSessions();
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


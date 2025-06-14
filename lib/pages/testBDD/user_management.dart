import 'package:flutter/material.dart';
import 'package:muscu/models/database_helper.dart';
import 'package:muscu/models/utilisateur/utilisateurs.dart';

class UserManagementPage extends StatefulWidget {
  @override
  _UserManagementPageState createState() => _UserManagementPageState();
}

class _UserManagementPageState extends State<UserManagementPage> {
  final dbHelper = DatabaseHelper.instance;
  List<User> users = [];

  @override
  void initState() {
    super.initState();
    _loadUsers();
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
        title: Text('Gestion des utilisateurs'),
      ),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return ListTile(
            title: Text(
              user.username,
              style: Theme.of(context).textTheme.displayMedium,
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.email,
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                if (user.id != null)
                  Text(
                    'ID: ${user.id}',
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
              ],
            ),
            trailing: IconButton(
              icon: Icon(Icons.delete, color: Colors.white),
              onPressed: () async {
                await UserTable.delete(dbHelper, user.id!);
                _loadUsers();
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _showAddUserDialog(context);
        },
      ),
    );
  }

  void _showAddUserDialog(BuildContext context) {
    final pseudoController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Ajouter un utilisateur'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: pseudoController,
                decoration: InputDecoration(
                  labelText: 'Pseudo',
                  contentPadding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 12.0), // Hauteur personnalisée
                ),
              ),
              SizedBox(height: 8),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  contentPadding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 12.0), // Hauteur personnalisée
                ),
              ),
              SizedBox(height: 8),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'Mot de passe',
                  contentPadding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 12.0), // Hauteur personnalisée
                ),
                obscureText: true,
              ),
            ],
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
                final newUser = User(
                  username: pseudoController.text,
                  email: emailController.text,
                  passwordHash: passwordController.text,
                );
                await UserTable.insert(dbHelper, newUser);
                Navigator.of(context).pop();
                _loadUsers();
              },
            ),
          ],
        );
      },
    );
  }
}


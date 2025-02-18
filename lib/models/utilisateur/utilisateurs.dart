import 'package:intl/intl.dart';
import '../database_helper.dart';

class UserTable {
  static const String tableName = 'utilisateur';

  static Future<void> createTable(DatabaseHelper dbHelper) async {
    final db = await dbHelper.database;
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $tableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        pseudo VARCHAR(50) NOT NULL,
        email VARCHAR(100) NOT NULL UNIQUE,
        mot_de_passe VARCHAR(255) NOT NULL,
        date_inscription DATETIME DEFAULT CURRENT_TIMESTAMP,
        derniere_connexion DATETIME
      )
    ''');
  }

  static Future<int> insert(DatabaseHelper dbHelper, User user) async {
    return await dbHelper.insert(tableName, user.toMap());
  }

  static Future<List<User>> getAllUsers(DatabaseHelper dbHelper) async {
    final List<Map<String, dynamic>> maps = await dbHelper.queryAllRows(tableName);
    return List.generate(maps.length, (i) => User.fromMap(maps[i]));
  }

  static Future<User?> getUserById(DatabaseHelper dbHelper, int id) async {
    final List<Map<String, dynamic>> maps = await dbHelper.queryRows(
      tableName,
      'id = ?',
      [id],
    );
    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  static Future<int> update(DatabaseHelper dbHelper, User user) async {
    return await dbHelper.update(
      tableName,
      user.toMap(),
      'id = ?',
      [user.id],
    );
  }

  static Future<int> delete(DatabaseHelper dbHelper, int id) async {
    return await dbHelper.delete(
      tableName,
      'id = ?',
      [id],
    );
  }

  static Future<void> clearTable(DatabaseHelper dbHelper) async {
    await dbHelper.clearTable(tableName);
  }
}

class User {
  final int? id;
  final String pseudo;
  final String email;
  final String motDePasse;
  final DateTime dateInscription;
  final DateTime? derniereConnexion;

  User({
    this.id,
    required this.pseudo,
    required this.email,
    required this.motDePasse,
    DateTime? dateInscription,
    this.derniereConnexion,
  }) : this.dateInscription = dateInscription ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'pseudo': pseudo,
      'email': email,
      'mot_de_passe': motDePasse,
      'date_inscription': DateFormat('yyyy-MM-dd HH:mm:ss').format(dateInscription),
      'derniere_connexion': derniereConnexion != null
          ? DateFormat('yyyy-MM-dd HH:mm:ss').format(derniereConnexion!)
          : null,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      pseudo: map['pseudo'],
      email: map['email'],
      motDePasse: map['mot_de_passe'],
      dateInscription: DateTime.parse(map['date_inscription']),
      derniereConnexion: map['derniere_connexion'] != null
          ? DateTime.parse(map['derniere_connexion'])
          : null,
    );
  }
}

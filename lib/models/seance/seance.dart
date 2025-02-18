import 'package:intl/intl.dart';
import '../database_helper.dart';

class SessionTable {
  static const String tableName = 'session';

  static Future<void> createTable(DatabaseHelper dbHelper) async {
    final db = await dbHelper.database;
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $tableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        id_utilisateur INTEGER NOT NULL,
        nom VARCHAR(50) NOT NULL,
        type VARCHAR(50),
        description TEXT,
        date_creation DATETIME DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (id_utilisateur) REFERENCES utilisateur(id)
      )
    ''');
  }

  static Future<int> insert(DatabaseHelper dbHelper, Session session) async {
    return await dbHelper.insert(tableName, session.toMap());
  }

  static Future<List<Session>> getAllSessions(DatabaseHelper dbHelper) async {
    final List<Map<String, dynamic>> maps = await dbHelper.queryAllRows(tableName);
    return List.generate(maps.length, (i) => Session.fromMap(maps[i]));
  }

  static Future<Session?> getSessionById(DatabaseHelper dbHelper, int id) async {
    final List<Map<String, dynamic>> maps = await dbHelper.queryRows(
      tableName,
      'id = ?',
      [id],
    );
    if (maps.isNotEmpty) {
      return Session.fromMap(maps.first);
    }
    return null;
  }

  static Future<List<Session>> getSessionsByUserId(DatabaseHelper dbHelper, int userId) async {
    final List<Map<String, dynamic>> maps = await dbHelper.queryRows(
      tableName,
      'id_utilisateur = ?',
      [userId],
    );
    return List.generate(maps.length, (i) => Session.fromMap(maps[i]));
  }

  static Future<int> update(DatabaseHelper dbHelper, Session session) async {
    return await dbHelper.update(
      tableName,
      session.toMap(),
      'id = ?',
      [session.id],
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

class Session {
  final int? id;
  final int idUtilisateur;
  final String nom;
  final String? type;
  final String? description;
  final DateTime dateCreation;

  Session({
    this.id,
    required this.idUtilisateur,
    required this.nom,
    this.type,
    this.description,
    DateTime? dateCreation,
  }) : this.dateCreation = dateCreation ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'id_utilisateur': idUtilisateur,
      'nom': nom,
      'type': type,
      'description': description,
      'date_creation': DateFormat('yyyy-MM-dd HH:mm:ss').format(dateCreation),
    };
  }

  factory Session.fromMap(Map<String, dynamic> map) {
    return Session(
      id: map['id'],
      idUtilisateur: map['id_utilisateur'],
      nom: map['nom'],
      type: map['type'],
      description: map['description'],
      dateCreation: DateTime.parse(map['date_creation']),
    );
  }
}


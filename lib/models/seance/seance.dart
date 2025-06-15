import 'package:intl/intl.dart';
import '../database_helper.dart';

class SessionTable {
  static const String tableName = 'sessions';

  static Future<void> createTable(DatabaseHelper dbHelper) async {
    final db = await dbHelper.database;
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $tableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name VARCHAR(255) NOT NULL,
        description TEXT,
        type VARCHAR(50),
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP
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

  // Cette méthode n'a plus de sens sans user_id, tu peux la supprimer ou la laisser vide
  // static Future<List<Session>> getSessionsByUserId(DatabaseHelper dbHelper, int userId) async {
  //   return [];
  // }

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
  final String name;
  final String? description;
  final String? type;
  final DateTime createdAt;

  Session({
    this.id,
    required this.name,
    this.description,
    this.type,
    DateTime? createdAt,
  }) : this.createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'type': type,
      'created_at': DateFormat('yyyy-MM-dd HH:mm:ss').format(createdAt),
    };
  }

  factory Session.fromMap(Map<String, dynamic> map) {
    return Session(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      type: map['type'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }
}


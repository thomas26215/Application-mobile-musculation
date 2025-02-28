import 'package:intl/intl.dart';
import '../database_helper.dart';

class ExerciseTable {
  static const String tableName = 'exercise';

  static Future<void> createTable(DatabaseHelper dbHelper) async {
    final db = await dbHelper.database;
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $tableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        id_utilisateur INTEGER NOT NULL,
        name VARCHAR(50) NOT NULL,
        description TEXT NOT NULL,
        type VARCHAR(50),
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP
      )
    ''');
  }

  static Future<int> insert(DatabaseHelper dbHelper, Exercise exercise) async {
    return await dbHelper.insert(tableName, exercise.toMap());
  }

  static Future<List<Exercise>> getAllExercises(DatabaseHelper dbHelper) async {
    final List<Map<String, dynamic>> maps = await dbHelper.queryAllRows(tableName);
    return List.generate(maps.length, (i) => Exercise.fromMap(maps[i]));
  }

  static Future<Exercise?> getExerciseById(DatabaseHelper dbHelper, int id) async {
    final List<Map<String, dynamic>> maps = await dbHelper.queryRows(
      tableName,
      'id = ?',
      [id],
    );
    if (maps.isNotEmpty) {
      return Exercise.fromMap(maps.first);
    }
    return null;
  }

  static Future<List<Exercise>> getExercisesByUserId(DatabaseHelper dbHelper, int userId) async {
    final List<Map<String, dynamic>> maps = await dbHelper.queryRows(
      tableName,
      'id_utilisateur = ?',
      [userId],
    );
    return List.generate(maps.length, (i) => Exercise.fromMap(maps[i]));
  }

  static Future<int> update(DatabaseHelper dbHelper, Exercise exercise) async {
    return await dbHelper.update(
      tableName,
      exercise.toMap(),
      'id = ?',
      [exercise.id],
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

class Exercise {
  int? id;
  int idUtilisateur;
  String name;
  String description;
  String? type;
  DateTime? createdAt;

  Exercise({
    this.id,
    required this.idUtilisateur,
    required this.name,
    required this.description,
    this.type,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'id_utilisateur': idUtilisateur,
      'name': name,
      'description': description,
      'type': type,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  static Exercise fromMap(Map<String, dynamic> map) {
    return Exercise(
      id: map['id'],
      idUtilisateur: map['id_utilisateur'],
      name: map['name'],
      description: map['description'],
      type: map['type'],
      createdAt: map['created_at'] != null ? DateTime.parse(map['created_at']) : null,
    );
  }
}

import 'package:intl/intl.dart';
import '../database_helper.dart';

class ExerciseTable {
  static const String tableName = 'exercises';

  static Future<void> createTable(DatabaseHelper dbHelper) async {
    final db = await dbHelper.database;
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $tableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        name VARCHAR(255) NOT NULL,
        description TEXT,
        type VARCHAR(50) NOT NULL,
        is_public BOOLEAN DEFAULT FALSE,
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (user_id) REFERENCES users(id)
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
      'user_id = ?',
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
  int userId;
  String name;
  String? description;
  String type;
  bool isPublic;
  DateTime? createdAt;

  Exercise({
    this.id,
    required this.userId,
    required this.name,
    this.description,
    required this.type,
    this.isPublic = false,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'description': description,
      'type': type,
      'is_public': isPublic ? 1 : 0,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  static Exercise fromMap(Map<String, dynamic> map) {
    return Exercise(
      id: map['id'],
      userId: map['user_id'],
      name: map['name'],
      description: map['description'],
      type: map['type'],
      isPublic: map['is_public'] == 1,
      createdAt: map['created_at'] != null ? DateTime.parse(map['created_at']) : null,
    );
  }
}


import 'package:intl/intl.dart';
import '../database_helper.dart';

class ExerciseTable {
  static const String tableName = 'exercises';

  static Future<void> createTable(DatabaseHelper dbHelper) async {
    final db = await dbHelper.database;
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $tableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name VARCHAR(255) NOT NULL,
        description TEXT,
        type TEXT NOT NULL,
        video_url TEXT,
        is_public BOOLEAN DEFAULT FALSE,
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

  // Cette méthode n'a plus de sens sans userId, tu peux la supprimer ou la laisser vide
  // static Future<List<Exercise>> getExercisesByUserId(DatabaseHelper dbHelper, int userId) async {
  //   return [];
  // }

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
  String name;
  String? description;
  String type;
  String? videoURL;
  bool isPublic;
  DateTime? createdAt;

  Exercise({
    this.id,
    required this.name,
    this.description,
    required this.type,
    this.videoURL,
    this.isPublic = false,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'type': type,
      'video_url': videoURL,
      'is_public': isPublic ? 1 : 0,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  static Exercise fromMap(Map<String, dynamic> map) {
    return Exercise(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      type: map['type'],
      videoURL: map['video_url'],
      isPublic: map['is_public'] == 1,
      createdAt: map['created_at'] != null ? DateTime.parse(map['created_at']) : null,
    );
  }
}


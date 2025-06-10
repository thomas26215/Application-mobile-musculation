import '../database_helper.dart';

class MuscularGroupExerciseTable {
  static const String tableName = 'muscular_groups';

  static Future<void> createTable(DatabaseHelper dbHelper) async {
    final db = await dbHelper.database;
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $tableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        exercise_id INTEGER NOT NULL,
        group_name VARCHAR(255) NOT NULL,
        impact_percent INTEGER NOT NULL,
        side TEXT,
        FOREIGN KEY (exercise_id) REFERENCES exercises(id) ON DELETE CASCADE
      )
    ''');
  }

  static Future<int> insert(DatabaseHelper dbHelper, MuscularGroupEntry entry) async {
    return await dbHelper.insert(tableName, entry.toMap());
  }

  static Future<List<MuscularGroupEntry>> getAllGroups(DatabaseHelper dbHelper) async {
    final List<Map<String, dynamic>> maps = await dbHelper.queryAllRows(tableName);
    return List.generate(maps.length, (i) => MuscularGroupEntry.fromMap(maps[i]));
  }

  static Future<MuscularGroupEntry?> getGroupById(DatabaseHelper dbHelper, int id) async {
    final List<Map<String, dynamic>> maps = await dbHelper.queryRows(
      tableName,
      'id = ?',
      [id],
    );
    if (maps.isNotEmpty) {
      return MuscularGroupEntry.fromMap(maps.first);
    }
    return null;
  }

  static Future<List<MuscularGroupEntry>> getGroupsByExerciseId(DatabaseHelper dbHelper, int exerciseId) async {
    final List<Map<String, dynamic>> maps = await dbHelper.queryRows(
      tableName,
      'exercise_id = ?',
      [exerciseId],
    );
    return List.generate(maps.length, (i) => MuscularGroupEntry.fromMap(maps[i]));
  }

  static Future<int> update(DatabaseHelper dbHelper, MuscularGroupEntry entry) async {
    return await dbHelper.update(
      tableName,
      entry.toMap(),
      'id = ?',
      [entry.id],
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

class MuscularGroupEntry {
  int? id;
  int exerciseId;
  String groupName;
  int impactPercent;
  String? side;

  MuscularGroupEntry({
    this.id,
    required this.exerciseId,
    required this.groupName,
    required this.impactPercent,
    this.side,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'exercise_id': exerciseId,
      'group_name': groupName,
      'impact_percent': impactPercent,
      'side': side,
    };
  }

  static MuscularGroupEntry fromMap(Map<String, dynamic> map) {
    return MuscularGroupEntry(
      id: map['id'],
      exerciseId: map['exercise_id'],
      groupName: map['group_name'],
      impactPercent: map['impact_percent'],
      side: map['side'],
    );
  }
}


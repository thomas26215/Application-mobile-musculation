import 'dart:convert';
import '../database_helper.dart';

enum ExerciseType {
  standard,
  dropSet,
  pyramid,
  timeUnderTension,
  superSet,
  giantSet,
  restPause,
  cluster
}

class SessionExerciseTable {
  static const String tableName = 'session_exercises';

  static Future<void> createTable(DatabaseHelper dbHelper) async {
    final db = await dbHelper.database;
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $tableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        session_id INTEGER NOT NULL,
        exercise_id INTEGER NOT NULL,
        order_in_session INTEGER NOT NULL,
        sets INTEGER,
        reps INTEGER,
        duration INTEGER,
        rest_time INTEGER,
        weight DECIMAL(5,2),
        exercise_type TEXT NOT NULL,
        custom_data TEXT,
        FOREIGN KEY (session_id) REFERENCES sessions(id),
        FOREIGN KEY (exercise_id) REFERENCES exercises(id)
      )
    ''');
  }

  static Future<int> insert(DatabaseHelper dbHelper, SessionExercise sessionExercise) async {
    return await dbHelper.insert(tableName, sessionExercise.toMap());
  }

  static Future<List<SessionExercise>> getAllSessionExercises(DatabaseHelper dbHelper) async {
    final List<Map<String, dynamic>> maps = await dbHelper.queryAllRows(tableName);
    return List.generate(maps.length, (i) => SessionExercise.fromMap(maps[i]));
  }

  static Future<SessionExercise?> getSessionExerciseById(DatabaseHelper dbHelper, int id) async {
    final List<Map<String, dynamic>> maps = await dbHelper.queryRows(
      tableName,
      'id = ?',
      [id],
    );
    if (maps.isNotEmpty) {
      return SessionExercise.fromMap(maps.first);
    }
    return null;
  }

  static Future<List<SessionExercise>> getSessionExercisesBySessionId(DatabaseHelper dbHelper, int sessionId) async {
    final List<Map<String, dynamic>> maps = await dbHelper.queryRows(
      tableName,
      'session_id = ?',
      [sessionId],
    );
    return List.generate(maps.length, (i) => SessionExercise.fromMap(maps[i]));
  }

  static Future<int> update(DatabaseHelper dbHelper, SessionExercise sessionExercise) async {
    return await dbHelper.update(
      tableName,
      sessionExercise.toMap(),
      'id = ?',
      [sessionExercise.id],
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

class SessionExercise {
  int? id;
  int sessionId;
  int exerciseId;
  int orderInSession;
  int? sets;
  int? reps;
  int? duration;
  int? restTime;
  double? weight;
  ExerciseType exerciseType;
  Map<String, dynamic>? customData;

  SessionExercise({
    this.id,
    required this.sessionId,
    required this.exerciseId,
    required this.orderInSession,
    this.sets,
    this.reps,
    this.duration,
    this.restTime,
    this.weight,
    required this.exerciseType,
    this.customData,
  });

  Map<String, dynamic> toMap() {
  final map = <String, dynamic>{
    'session_id': sessionId,
    'exercise_id': exerciseId,
    'order_in_session': orderInSession,
    'sets': sets,
    'reps': reps,
    'duration': duration,
    'rest_time': restTime,
    'weight': weight,
    'exercise_type': exerciseType.toString().split('.').last,
    'custom_data': customData != null ? json.encode(customData) : null,
  };
  if (id != null) {
    map['id'] = id;
  }
  return map;
}

  static SessionExercise fromMap(Map<String, dynamic> map) {
    return SessionExercise(
      id: map['id'],
      sessionId: map['session_id'],
      exerciseId: map['exercise_id'],
      orderInSession: map['order_in_session'],
      sets: map['sets'],
      reps: map['reps'],
      duration: map['duration'],
      restTime: map['rest_time'],
      weight: map['weight'] != null ? (map['weight'] as num).toDouble() : null,
      exerciseType: ExerciseType.values.firstWhere(
        (e) => e.toString().split('.').last == map['exercise_type'],
        orElse: () => ExerciseType.standard,
      ),
      customData: map['custom_data'] != null ? json.decode(map['custom_data']) : null,
    );
  }
}


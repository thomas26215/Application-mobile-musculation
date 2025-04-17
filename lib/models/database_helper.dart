import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  // Singleton instance
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  // Private constructor
  DatabaseHelper._init();

  // Factory constructor for creating an instance
  factory DatabaseHelper() {
    return instance;
  }

  // Getter for the database
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('database.db');
    return _database!;
  }

  // Initialize the database
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  // Create the database schema
  Future _createDB(Database db, int version) async {
    // Example table creation (replace with your own tables)
    await db.execute('''
      CREATE TABLE utilisateur (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        pseudo TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        mot_de_passe TEXT NOT NULL,
        date_inscription DATETIME DEFAULT CURRENT_TIMESTAMP,
        derniere_connexion DATETIME
      )
    ''');

    await db.execute('''
    CREATE TABLE IF NOT EXISTS session_exercises (
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

  // Insert a row into a table
  Future<int> insert(String table, Map<String, dynamic> row) async {
    final db = await instance.database;
    return await db.insert(table, row);
  }

  // Query all rows from a table
  Future<List<Map<String, dynamic>>> queryAllRows(String table) async {
    final db = await instance.database;
    return await db.query(table);
  }

  // Query specific rows from a table
  Future<List<Map<String, dynamic>>> queryRows(
      String table, String where, List<dynamic> whereArgs) async {
    final db = await instance.database;
    return await db.query(table, where: where, whereArgs: whereArgs);
  }

  // Update a row in a table
  Future<int> update(
      String table, Map<String, dynamic> row, String where, List<dynamic> whereArgs) async {
    final db = await instance.database;
    return await db.update(table, row, where: where, whereArgs: whereArgs);
  }

  // Delete a row from a table
  Future<int> delete(String table, String where, List<dynamic> whereArgs) async {
    final db = await instance.database;
    return await db.delete(table, where: where, whereArgs: whereArgs);
  }

  // Clear all rows from a table
  Future<void> clearTable(String table) async {
    final db = await instance.database;
    await db.execute("DELETE FROM $table");
  }

  // Close the database connection
  Future<void> close() async {
    final db = await instance.database;
    await db.close();
    _database = null; // Reset the database reference
  }
}


import 'package:intl/intl.dart';
import '../database_helper.dart';

class ProfilTable {
  static const String tableName = 'profil';

  static Future<void> createTable(DatabaseHelper dbHelper) async {
    final db = await dbHelper.database;
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $tableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL UNIQUE,
        nom VARCHAR(50) NOT NULL,
        prenom VARCHAR(50) NOT NULL,
        date_naissance DATETIME NOT NULL,
        sexe VARCHAR(1) NOT NULL,
        biographie TEXT,
        FOREIGN KEY (user_id) REFERENCES utilisateur(id)
      )
    ''');
  }

  static Future<int> insert(DatabaseHelper dbHelper, Profil profil) async {
    return await dbHelper.insert(tableName, profil.toMap());
  }

  static Future<List<Profil>> getAllProfils(DatabaseHelper dbHelper) async {
    final List<Map<String, dynamic>> maps = await dbHelper.queryAllRows(tableName);
    return List.generate(maps.length, (i) => Profil.fromMap(maps[i]));
  }

  static Future<Profil?> getProfilById(DatabaseHelper dbHelper, int id) async {
    final List<Map<String, dynamic>> maps = await dbHelper.queryRows(
      tableName,
      'id = ?',
      [id],
    );
    if (maps.isNotEmpty) {
      return Profil.fromMap(maps.first);
    }
    return null;
  }

  static Future<Profil?> getProfilByUserId(DatabaseHelper dbHelper, int userId) async {
    final List<Map<String, dynamic>> maps = await dbHelper.queryRows(
      tableName,
      'user_id = ?',
      [userId],
    );
    if (maps.isNotEmpty) {
      return Profil.fromMap(maps.first);
    }
    return null;
  }

  static Future<int> update(DatabaseHelper dbHelper, Profil profil) async {
    return await dbHelper.update(
      tableName,
      profil.toMap(),
      'id = ?',
      [profil.id],
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

class Profil {
  final int? id;
  final int userId;
  final String nom;
  final String prenom;
  final DateTime dateNaissance;
  final String sexe;
  final String? biographie;

  Profil({
    this.id,
    required this.userId,
    required this.nom,
    required this.prenom,
    required this.dateNaissance,
    required this.sexe,
    this.biographie,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'nom': nom,
      'prenom': prenom,
      'date_naissance': DateFormat('yyyy-MM-dd').format(dateNaissance),
      'sexe': sexe,
      'biographie': biographie,
    };
  }

  factory Profil.fromMap(Map<String, dynamic> map) {
    return Profil(
      id: map['id'],
      userId: map['user_id'],
      nom: map['nom'],
      prenom: map['prenom'],
      dateNaissance: DateTime.parse(map['date_naissance']),
      sexe: map['sexe'],
      biographie: map['biographie'],
    );
  }
}


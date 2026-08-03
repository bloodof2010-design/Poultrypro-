// lib/db/DatabaseHelper.dart
// SQLite helper singleton for PoultryPro
import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._internal();
  factory DatabaseHelper() => instance;
  DatabaseHelper._internal();

  static Database? _db;

  Future<Database> get database async {
    return _db ??= await _initDb();
  }

  Future<void> init() async {
    _db ??= await _initDb();
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'poultrypro.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    // users table
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        email TEXT UNIQUE,
        password TEXT
      );
    ''');

    // poultry table
    await db.execute('''
      CREATE TABLE poultry (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER,
        type TEXT,
        breed TEXT,
        quantity INTEGER,
        date_added TEXT,
        notes TEXT,
        FOREIGN KEY(user_id) REFERENCES users(id)
      );
    ''');
  }

  // --------------------
  // User helpers
  // --------------------

  // Create user; returns inserted id
  Future<int> createUser({required String email, required String password}) async {
    final db = await database;
    return await db.insert('users', {'email': email, 'password': password});
  }

  // Get user row by email (returns map or null)
  Future<Map<String, Object?>?> getUserByEmail(String email) async {
    final db = await database;
    final rows = await db.query('users', where: 'email = ?', whereArgs: [email], limit: 1);
    if (rows.isEmpty) return null;
    return rows.first;
  }

  // Get user row by id
  Future<Map<String, Object?>?> getUserById(int id) async {
    final db = await database;
    final rows = await db.query('users', where: 'id = ?', whereArgs: [id], limit: 1);
    if (rows.isEmpty) return null;
    return rows.first;
  }

  // --------------------
  // Poultry CRUD
  // --------------------

  Future<int> insertPoultry({
    required int userId,
    required String type,
    String? breed,
    required int quantity,
    required String dateAddedIso,
    String? notes,
  }) async {
    final db = await database;
    return await db.insert('poultry', {
      'user_id': userId,
      'type': type,
      'breed': breed,
      'quantity': quantity,
      'date_added': dateAddedIso,
      'notes': notes,
    });
  }

  Future<List<Map<String, Object?>>> getPoultryForUser(int userId) async {
    final db = await database;
    return await db.query('poultry', where: 'user_id = ?', whereArgs: [userId], orderBy: 'date_added DESC');
  }

  Future<int> getPoultryCountForUser(int userId) async {
    final db = await database;
    final rows = await db.rawQuery('SELECT COUNT(*) as cnt FROM poultry WHERE user_id = ?', [userId]);
    if (rows.isEmpty) return 0;
    final cnt = (rows.first['cnt'] as num).toInt();
    return cnt;
  }

  // Optional delete/update helpers (not used in minimal app)
  Future<int> deletePoultry(int id) async {
    final db = await database;
    return await db.delete('poultry', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updatePoultry(int id, Map<String, Object?> values) async {
    final db = await database;
    return await db.update('poultry', values, where: 'id = ?', whereArgs: [id]);
  }
}

// lib/db/DatabaseHelper.dart
// Simple sqflite helper for the poultry app.

import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._internal();
  factory DatabaseHelper() => instance;
  DatabaseHelper._internal();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDb();

  Future<void> init() async {
    _database ??= await _initDb();
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'poultry_pro.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    // users
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL
      );
    ''');

    // birds
    await db.execute('''
      CREATE TABLE birds (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        tag TEXT,
        breed TEXT,
        date_added TEXT,
        notes TEXT,
        owner_user_id INTEGER
      );
    ''');

    // feed entries
    await db.execute('''
      CREATE TABLE feed_entries (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        bird_id INTEGER,
        date TEXT,
        feed_type TEXT,
        quantity REAL,
        notes TEXT,
        owner_user_id INTEGER
      );
    ''');

    // labour entries
    await db.execute('''
      CREATE TABLE labour (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT,
        description TEXT,
        hours REAL,
        cost REAL,
        owner_user_id INTEGER
      );
    ''');

    // income
    await db.execute('''
      CREATE TABLE income (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT,
        source TEXT,
        amount REAL,
        notes TEXT,
        owner_user_id INTEGER
      );
    ''');

    // expenses
    await db.execute('''
      CREATE TABLE expenses (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT,
        description TEXT,
        amount REAL,
        notes TEXT,
        owner_user_id INTEGER
      );
    ''');
  }

  // Generic CRUD helpers
  Future<int> insert(String table, Map<String, dynamic> values) async {
    final db = await database;
    return await db.insert(table, values, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> query(String table,
      {String? where, List<Object?>? whereArgs, String? orderBy}) async {
    final db = await database;
    return await db.query(table, where: where, whereArgs: whereArgs, orderBy: orderBy);
  }

  Future<int> update(String table, Map<String, dynamic> values, {required String where, required List<Object?> whereArgs}) async {
    final db = await database;
    return await db.update(table, values, where: where, whereArgs: whereArgs);
  }

  Future<int> delete(String table, {required String where, required List<Object?> whereArgs}) async {
    final db = await database;
    return await db.delete(table, where: where, whereArgs: whereArgs);
  }

  Future close() async {
    final db = await database;
    await db.close();
    _database = null;
  }

  // Seed demo data (creates a sample user and a bird for easier demo)
  Future<void> seedDemoDataIfNeeded() async {
    final db = await database;
    final rows = await db.query('users', limit: 1);
    if (rows.isNotEmpty) return;

    await db.transaction((txn) async {
      final userId = await txn.insert('users', {'username': 'admin', 'password': 'password'});
      await txn.insert('birds', {
        'tag': 'B001',
        'breed': 'Layer',
        'date_added': DateTime.now().toIso8601String(),
        'notes': 'Demo bird',
        'owner_user_id': userId
      });
      await txn.insert('income', {
        'date': DateTime.now().toIso8601String(),
        'source': 'Demo sale',
        'amount': 30.0,
        'notes': 'Seed sale',
        'owner_user_id': userId
      });
    });
  }
}

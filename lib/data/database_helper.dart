import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    // Initializing FFI if not on mobile or web
    if (!kIsWeb && !Platform.isAndroid && !Platform.isIOS) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }

    final path = join(await getDatabasesPath(), 'khedmot.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS months(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        active INTEGER,
        jan INTEGER,
        feb INTEGER,
        mar INTEGER,
        apr INTEGER,
        may INTEGER,
        jun INTEGER,
        jul INTEGER,
        aug INTEGER,
        sep INTEGER,
        oct INTEGER,
        nov INTEGER,
        dec INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS settings(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        persent INTEGER
      )
    ''');


    final existingSettings = await db.query('settings');
    if (existingSettings.isEmpty) {
      await db.insert('settings', {"persent": 25});
    }
  }


  // Get persent

  Future<dynamic> getPersent() async {
    Database db = await database;
    var result = await db.query('settings', where: 'id = ?', whereArgs: [1]);
    return result.first["persent"];
  }

  // Insert an entry

  Future<int> insertUser(Map<String, dynamic> user) async {
    Database db = await database;
    return await db.insert('months', user);
  }

  // Get all users
  Future<List<Map<String, dynamic>>> getUsers() async {
    Database db = await database;
    return await db.query('months');
  }

  // Get a specific user by id
  Future<Map<String, dynamic>?> getUser(int id) async {
    Database db = await database;
    var result = await db.query('months', where: 'id = ?', whereArgs: [id]);
    return result.isNotEmpty ? result.first : null;
  }

  // Update a user
  Future<int> updateUser(Map<String, dynamic> user) async {
    Database db = await database;
    return await db.update(
      'months',
      user,
      where: 'id = ?',
      whereArgs: [user['id']],
    );
  }

  // Delete a user
  Future<int> deleteUser(int id) async {
    Database db = await database;
    return await db.delete('months', where: 'id = ?', whereArgs: [id]);
  }
}

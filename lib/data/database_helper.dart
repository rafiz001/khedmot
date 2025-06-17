import 'dart:async';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Directory, File, Platform;

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
    return await openDatabase(path, version: 1, onCreate: _onCreate);
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

  // Update persent
  Future<int> updatePersent(int number) async {
    Database db = await database;
    return await db.update(
      'settings',
      {"persent": number},
      where: 'id = ?',
      whereArgs: [1],
    );
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

  // Get month aggregate
  Future<List<Map<String, dynamic>>> getSum() async {
    Database db = await database;
    return await db.rawQuery('''
SELECT 
    SUM(jan) AS jan_sum,
    SUM(feb) AS feb_sum,
    SUM(mar) AS mar_sum,
    SUM(apr) AS apr_sum,
    SUM(may) AS may_sum,
    SUM(jun) AS jun_sum,
    SUM(jul) AS jul_sum,
    SUM(aug) AS aug_sum,
    SUM(sep) AS sep_sum,
    SUM(oct) AS oct_sum,
    SUM(nov) AS nov_sum,
    SUM(dec) AS dec_sum
FROM months;
''');
  }

  getDbPath() async {
    String dbPath = await getDatabasesPath();
    print("db path: $dbPath");

    Directory? external = await getExternalStorageDirectory();
    print("ffffffffff: $external");
  }

  Future<bool> backupDB() async {
    var status = await Permission.manageExternalStorage.status;
    if (!status.isGranted) {
      await Permission.manageExternalStorage.request();
    }
    var status2 = await Permission.storage.status;
    if (!status2.isGranted) {
      await Permission.storage.request();
    }
    try {
      File ourDB = File(
        "/data/user/0/com.example.khedmot/databases/khedmot.db",
      );
      Directory? toSave = Directory("/storage/emulated/0/khedmot");
      await toSave.create();
      await ourDB.copy("${toSave.path}/khedmot.db");
    } catch (e) {
      //print("Backup error: ${e.toString()}");
      return false;
    }
    return true;
  }

  Future<bool> restoreDB() async {
    var status = await Permission.manageExternalStorage.status;
    if (!status.isGranted) {
      await Permission.manageExternalStorage.request();
    }
    var status2 = await Permission.storage.status;
    if (!status2.isGranted) {
      await Permission.storage.request();
    }
    try {
      File savedDB = File("/storage/emulated/0/khedmot/khedmot.db");
      savedDB.copy("/data/user/0/com.example.khedmot/databases/khedmot.db");
    } catch (e) {
      //print("Restore error: ${e.toString()}");
      return false;
    }
    return true;
  }
}

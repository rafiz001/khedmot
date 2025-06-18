import 'dart:async';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Directory, File, Platform;
import 'package:device_info_plus/device_info_plus.dart';
import 'package:file_picker/file_picker.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _database;
  final dbname = "khedmot.db";
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

    final path = join(await getDatabasesPath(), dbname);
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

  Future<String> get _localDbPath async {
    final dbPath = await getDatabasesPath();
    return join(dbPath, dbname);
  }

  Future<void> _requestAndroidPermissions() async {
    if (!Platform.isAndroid) return;

    final androidInfo = await DeviceInfoPlugin().androidInfo;
    if (androidInfo.version.sdkInt >= 30) {
      await Permission.manageExternalStorage.request();
    } else {
      await Permission.storage.request();
    }
  }

  Future<bool> backupDB() async {
    try {
      if (Platform.isAndroid) await _requestAndroidPermissions();

      final sourcePath = await _localDbPath;
      final sourceFile = File(sourcePath);

      if (!await sourceFile.exists()) {
        throw Exception('Database file not found');
      }

      // For Linux: Suggest default download location
      String? destinationPath;
      if (Platform.isLinux) {
        final downloadsDir = await getDownloadsDirectory();
        destinationPath = await FilePicker.platform.saveFile(
          type: FileType.custom,
          dialogTitle: 'Export Database',
          fileName: dbname,
          initialDirectory: downloadsDir?.path,
          allowedExtensions: ['db'],
        );
        if (destinationPath == null) return false;
        await sourceFile.copy(destinationPath);
      } else {
        final bytes = await sourceFile.readAsBytes();
        destinationPath = await FilePicker.platform.saveFile(
          type: FileType.custom,
          dialogTitle: 'Export Database',
          fileName: dbname,
          allowedExtensions: ['db'],
          bytes: bytes,
        );
      }

      if (destinationPath == null) return false;

      return true;
    } catch (e) {
      //print('Export error: $e');
      return false;
    }
  }

  Future<bool> restoreDB() async {
    try {
      if (Platform.isAndroid) await _requestAndroidPermissions();

      final result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        //allowedExtensions: ['db', 'sqlite'],
        dialogTitle: 'Select Database File',
      );

      if (result == null) return false;

      final sourcePath = result.files.single.path!;
      final destPath = await _localDbPath;

      // Close existing connection if open

      _database = null;

      await File(sourcePath).copy(destPath);

      _database = await database;
      return true;
    } catch (e) {
      //print('Import error: $e');
      return false;
    }
  }
}

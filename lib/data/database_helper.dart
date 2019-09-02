import 'dart:io';

import 'package:path/path.dart';
import 'package:remind_me/models/word.dart';
import 'package:remind_me/models/setting.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static final _databaseName = "RemindMeDatabase.db";
  static final _databaseVersion = 1;

  // table and column names for Word table
  static final wTable = 'words';
  static final wColumnId = '_id';
  static final wColumnWord = 'word';
  static final wColumnFirst = 'first';
  static final wColumnSecond = 'second';
  static final wColumnThird = 'third';
  static final wColumnSynonyms = 'synonyms';
  static final wColumnActive = 'active';
  static final wColumnPriority = 'priority';

  // table and column names for Settings table
  static final sTable = 'settings';

  static final sColumnId = '_id';
  static final sColumnEnabled = 'enabled';
  static final sColumnEndDate = 'endDate';
  static final sColumnStartDate = 'startDate';
  static final sColumnWorkDays = 'workDays';
  static final sColumnWeekend = 'weekend';
  static final sColumnStartWeek = 'startWeek';

  // make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL code to create the database table
  void _onCreate(Database db, int version) async {
    // Create settings table
    await db.execute('''
      CREATE TABLE $sTable (
        $sColumnId INTEGER PRIMARY KEY,
        $sColumnEnabled INTEGER NOT NULL,
        $sColumnStartDate TEXT NOT NULL,
        $sColumnEndDate TEXT NOT NULL,
        $sColumnStartWeek TEXT NOT NULL,
        $sColumnWeekend INTEGER NOT NULL,
        $sColumnWorkDays INTEGER NOT NULL,
      )
    ''');

    // Create words table
    await db.execute('''
      CREATE TABLE $wTable (
        $wColumnId INTEGER PRIMARY KEY,
        $wColumnWord TEXT NOT NULL,
        $wColumnFirst TEXT NOT NULL,
        $wColumnSecond TEXT,
        $wColumnThird TEXT,
        $wColumnSynonyms TEXT,
        $wColumnActive INTEGER,
        $wColumnPriority INTEGER
      )
    ''');

    print("Table was created");
  }

  // Helper methods
  // Words Table
  // Inserts a row in the database where each key in the Map is a column name
  // and the value is the column value. The return value is the id of the
  // inserted row.
  Future<int> insertWord(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(wTable, row);
  }

  // Settings Table
  // Inserts a row in the database where each key in the Map is a column name
  // and the value is the column value. The return value is the id of the
  // inserted row.
  Future<int> insertSetting(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(sTable, row);
  }

  // Words Table
  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  Future<List<Map<String, dynamic>>> getAllWords() async {
    Database db = await instance.database;
    return await db.query(wTable);
  }

  // Settings Table
  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  Future<List<Map<String, dynamic>>> getAllSettings() async {
    Database db = await instance.database;
    return await db.query(sTable);
  }

  // Words Table
  // All of the methods (insert, query, update, delete) can also be done using
  // raw SQL commands. This method uses a raw query to give the row count.
  Future<int> wordsQueryRowCount() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $wTable'));
  }

  // Settings Table
  // All of the methods (insert, query, update, delete) can also be done using
  // raw SQL commands. This method uses a raw query to give the row count.
  Future<int> settingsQueryRowCount() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $sTable'));
  }

  // Words Table
  // We are assuming here that the id column in the map is set. The other
  // column values will be used to update the row.
  Future<int> updateWord(Word w) async {
    // row to update
    Map<String, dynamic> row = {
      DatabaseHelper.wColumnId: w.id,
      DatabaseHelper.wColumnWord: w.word,
      DatabaseHelper.wColumnFirst: w.first,
      DatabaseHelper.wColumnSecond: w.second,
      DatabaseHelper.wColumnThird: w.third,
      DatabaseHelper.wColumnSynonyms: w.synonyms,
      DatabaseHelper.wColumnActive: w.active,
      DatabaseHelper.wColumnPriority: w.priority
    };

    Database db = await instance.database;
    int id = row[wColumnId];
    return await db
        .update(wTable, row, where: '$wColumnId = ?', whereArgs: [id]);
  }

  // Settings Table
  // We are assuming here that the id column in the map is set. The other
  // column values will be used to update the row.
  Future<int> updateSetting(Setting s) async {
    // row to update
    Map<String, dynamic> row = {
      DatabaseHelper.wColumnId: s.id,
      DatabaseHelper.sColumnEnabled: s.enabled,
      DatabaseHelper.sColumnStartDate: s.startDate,
      DatabaseHelper.sColumnEndDate: s.endDate,
      DatabaseHelper.sColumnWorkDays: s.workDays,
      DatabaseHelper.sColumnWeekend: s.weekend,
      DatabaseHelper.sColumnStartWeek: s.startWeek,
    };

    Database db = await instance.database;
    int id = row[sColumnId];
    return await db
        .update(sTable, row, where: '$sColumnId = ?', whereArgs: [id]);
  }

  // Word Table
  // Read a word from db from id
  Future<Word> getWord(int id) async {
    Database db = await instance.database;
    var result =
        await db.rawQuery('SELECT * FROM $wTable WHERE $wColumnId = $id');

    if (result.length > 0) {
      return new Word.fromMap(result.first);
    }

    return null;
  }

  // Setting Table
  // Read a word from db from id
  Future<Setting> getSetting(int id) async {
    Database db = await instance.database;
    var result =
        await db.rawQuery('SELECT * FROM $sTable WHERE $sColumnId = $id');

    if (result.length > 0) {
      return new Setting.fromMap(result.first);
    }
    return null;
  }

  // Word Table
  // Deletes the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
  Future<int> deleteWord(int id) async {
    Database db = await instance.database;
    return await db.delete(wTable, where: '$wColumnId = ?', whereArgs: [id]);
  }

  // Setting Table
  // Deletes the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
  Future<int> deleteSetting(int id) async {
    Database db = await instance.database;
    return await db.delete(sTable, where: '$sColumnId = ?', whereArgs: [id]);
  }
}

import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io' as io;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import '../models/word.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = new DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;

  static Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }

    _db = await initDb();
    return _db;
  }

  DatabaseHelper.internal();

  initDb() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = p.join(documentDirectory.path, "remind_me_words.db");
    var ourDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return ourDb;
  }

  void _onCreate(Database db, int version) async {
    await db.execute(
      "CREATE TABLE Word("
      "id INTEGER PRIMARY KEY,"
      "word TEXT,"
      "first TEXT,"
      "second TEXT,"
      "third TEXT,"
      "synonyms TEXT,"
      "active INTEGER,"
      "priority INTEGER)",
    );
    print("Table is created");
  }

  //insertion
  Future<int> saveWord(Word word) async {
    var dbClient = await db;
    int res = await dbClient.insert("Word", word.toMap());
    return res;
  }

  //deletion
  Future<int> deleteWord(Word word) async {
    var dbClient = await db;
    int res = await dbClient.delete("Word");
    return res;
  }
}

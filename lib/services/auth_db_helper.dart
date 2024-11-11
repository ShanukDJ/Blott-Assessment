import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('user_data.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE user(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      firstName TEXT,
      lastName TEXT
    )
    ''');
  }

  Future<void> insertUser(String firstName, String lastName) async {
    final db = await database;
    await db.insert('user', {'firstName': firstName, 'lastName': lastName});
  }

  Future<Map<String, dynamic>?> getUser() async {
    final db = await database;
    final result = await db.query('user');
    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }
}

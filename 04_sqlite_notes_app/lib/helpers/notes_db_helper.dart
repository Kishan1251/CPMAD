import 'dart:async';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import '../core/database.dart';
import '../models/note_model.dart';

/// DatabaseHelper following Singleton pattern as explained in Udemy Section 16
class DatabaseHelper {
  static DatabaseHelper? _databaseHelper;
  static Database? _database;

  static const String tableName = 'notes';
  static const String colId = 'id';
  static const String colTitle = 'title';
  static const String colContent = 'content';
  static const String colDate = 'date';

  DatabaseHelper._createInstance();

  factory DatabaseHelper() {
    _databaseHelper ??= DatabaseHelper._createInstance();
    return _databaseHelper!;
  }

  Future<Database> get database async {
    _database ??= await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    String path = 'notes.db';
    try {
      final directory = await getApplicationDocumentsDirectory();
      path = join(directory.path, 'notes.db');
    } catch (_) {
      // Fallback for web/sandboxed environments
      path = '/tmp/notes.db';
    }

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDb,
    );
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
      'CREATE TABLE $tableName($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colTitle TEXT, $colContent TEXT, $colDate TEXT)',
    );
  }

  // Fetch all notes from SQLite table
  Future<List<Note>> getNotes() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      orderBy: '$colDate DESC',
    );
    return List.generate(maps.length, (i) => Note.fromMap(maps[i]));
  }

  // Insert a note
  Future<int> insertNote(Note note) async {
    final db = await database;
    return await db.insert(tableName, note.toMap());
  }

  // Update a note
  Future<int> updateNote(Note note) async {
    final db = await database;
    return await db.update(
      tableName,
      note.toMap(),
      where: '$colId = ?',
      whereArgs: [note.id],
    );
  }

  // Delete a note
  Future<int> deleteNote(int id) async {
    final db = await database;
    return await db.delete(
      tableName,
      where: '$colId = ?',
      whereArgs: [id],
    );
  }
}

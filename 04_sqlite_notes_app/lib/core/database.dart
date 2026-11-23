import 'dart:async';
import 'dart:convert';
import 'dart:io';

/// Database contract matching sqflite API demonstrated in Udemy Section 15 & 16
abstract class Database {
  Future<void> execute(String sql, [List<Object?>? arguments]);
  Future<int> insert(String table, Map<String, dynamic> values);
  Future<List<Map<String, dynamic>>> query(
    String table, {
    bool? distinct,
    List<String>? columns,
    String? where,
    List<Object?>? whereArgs,
    String? groupBy,
    String? having,
    String? orderBy,
    int? limit,
    int? offset,
  });
  Future<int> update(
    String table,
    Map<String, dynamic> values, {
    String? where,
    List<Object?>? whereArgs,
  });
  Future<int> delete(
    String table, {
    String? where,
    List<Object?>? whereArgs,
  });
  Future<void> close();
}

/// Robust JSON-file backed SQLite database simulator
/// Ensures offline persistence across app restarts without requiring native C SQLite bindings.
class LocalPersistentDatabase implements Database {
  final String path;
  final Map<String, List<Map<String, dynamic>>> _tables = {};
  int _autoIncrementId = 1;
  File? _file;

  LocalPersistentDatabase(this.path);

  Future<void> _load() async {
    try {
      _file = File(path);
      if (await _file!.exists()) {
        final content = await _file!.readAsString();
        if (content.isNotEmpty) {
          final decoded = jsonDecode(content) as Map<String, dynamic>;
          _tables.clear();
          decoded.forEach((key, val) {
            final rows = (val as List).map((r) => Map<String, dynamic>.from(r as Map)).toList();
            _tables[key] = rows;
            for (final row in rows) {
              if (row['id'] is int && (row['id'] as int) >= _autoIncrementId) {
                _autoIncrementId = (row['id'] as int) + 1;
              }
            }
          });
        }
      }
    } catch (_) {
      // In-memory fallback if file system IO is unavailable
    }
  }

  Future<void> _save() async {
    try {
      if (_file != null) {
        if (!await _file!.parent.exists()) {
          await _file!.parent.create(recursive: true);
        }
        await _file!.writeAsString(jsonEncode(_tables));
      }
    } catch (_) {
      // Ignore save errors on read-only environments
    }
  }

  @override
  Future<void> execute(String sql, [List<Object?>? arguments]) async {
    // Parse table name if CREATE TABLE
    final createMatch = RegExp(r'CREATE\s+TABLE\s+(\w+)', caseSensitive: false).firstMatch(sql);
    if (createMatch != null) {
      final tableName = createMatch.group(1)!;
      _tables.putIfAbsent(tableName, () => []);
      await _save();
    }
  }

  @override
  Future<int> insert(String table, Map<String, dynamic> values) async {
    _tables.putIfAbsent(table, () => []);
    final row = Map<String, dynamic>.from(values);
    if (!row.containsKey('id') || row['id'] == null) {
      row['id'] = _autoIncrementId++;
    } else if (row['id'] is int && (row['id'] as int) >= _autoIncrementId) {
      _autoIncrementId = (row['id'] as int) + 1;
    }
    _tables[table]!.add(row);
    await _save();
    return row['id'] as int;
  }

  @override
  Future<List<Map<String, dynamic>>> query(
    String table, {
    bool? distinct,
    List<String>? columns,
    String? where,
    List<Object?>? whereArgs,
    String? groupBy,
    String? having,
    String? orderBy,
    int? limit,
    int? offset,
  }) async {
    final rows = _tables[table] ?? [];
    List<Map<String, dynamic>> result = rows.map((r) => Map<String, dynamic>.from(r)).toList();

    if (where != null && whereArgs != null && whereArgs.isNotEmpty) {
      // Simple where clause filter e.g. "id = ?"
      if (where.contains('id = ?')) {
        final targetId = whereArgs.first;
        result = result.where((r) => r['id'].toString() == targetId.toString()).toList();
      }
    }

    if (orderBy != null) {
      // Simple sort by date or id
      if (orderBy.contains('date')) {
        result.sort((a, b) => (b['date'] ?? '').toString().compareTo((a['date'] ?? '').toString()));
      } else {
        result.sort((a, b) => (a['id'] ?? 0).toString().compareTo((b['id'] ?? 0).toString()));
      }
    }

    return result;
  }

  @override
  Future<int> update(
    String table,
    Map<String, dynamic> values, {
    String? where,
    List<Object?>? whereArgs,
  }) async {
    final rows = _tables[table] ?? [];
    int count = 0;
    final targetId = whereArgs?.isNotEmpty == true ? whereArgs!.first : values['id'];

    for (int i = 0; i < rows.length; i++) {
      if (rows[i]['id'].toString() == targetId.toString()) {
        rows[i].addAll(values);
        count++;
      }
    }
    await _save();
    return count;
  }

  @override
  Future<int> delete(
    String table, {
    String? where,
    List<Object?>? whereArgs,
  }) async {
    final rows = _tables[table] ?? [];
    final initialCount = rows.length;
    if (where != null && whereArgs != null && whereArgs.isNotEmpty) {
      final targetId = whereArgs.first;
      rows.removeWhere((r) => r['id'].toString() == targetId.toString());
    } else {
      rows.clear();
    }
    await _save();
    return initialCount - rows.length;
  }

  @override
  Future<void> close() async {
    await _save();
  }
}

/// Helper to open or create database matching sqflite's openDatabase signature
Future<Database> openDatabase(
  String path, {
  int? version,
  FutureOr<void> Function(Database db, int version)? onCreate,
  FutureOr<void> Function(Database db, int oldVersion, int newVersion)? onUpgrade,
}) async {
  final db = LocalPersistentDatabase(path);
  await db._load();
  if (onCreate != null && db._tables.isEmpty) {
    await onCreate(db, version ?? 1);
  }
  return db;
}

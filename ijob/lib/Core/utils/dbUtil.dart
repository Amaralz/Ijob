import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqlite_api.dart';

class Dbutil {
  static Future<sql.Database> database() async {
    final dbpath = await sql.getDatabasesPath();

    return sql.openDatabase(
      path.join(dbpath, 'users.db'),
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE users (id TEXT PRIMARY KEY, email TEXT NOT NULL, name TEXT NOT NULL, categor1 TEXT, categor2 TEXT, role INTEGER)',
        );
      },
      version: 1,
    );
  }

  static Future<void> loadUsers() async {
    final db = await Dbutil.database();

    await db.rawQuery("SELECT * FROM uses");
  }

  static Future<void> insert(String table, Map<String, dynamic> data) async {
    final db = await Dbutil.database();

    await db.insert(table, data, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<void> delete(String table, String id) async {
    final db = await Dbutil.database();

    await db.delete(table, where: 'id = ?', whereArgs: [id]);
  }

  static Future<void> update(
    String id,
    Map<String, dynamic> data,
    String table,
  ) async {
    final db = await Dbutil.database();

    await db.update(table, data, where: 'id = ?', whereArgs: [id]);
  }
}

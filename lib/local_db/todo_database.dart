import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

/// models
import '../models/todo.dart';

class TodoDatabase {
  static final TodoDatabase instance = TodoDatabase._init();
  static Database? _database;

  TodoDatabase._init();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    } else {
      _database = await _initDatabase('todo.db');
      return _database!;
    }
  }

  Future<Database> _initDatabase(String filePath) async {
    final databasePath = await getApplicationDocumentsDirectory();
    String path = join(databasePath.path, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDatabase);
  }

  Future _createDatabase(Database db, int version) async {
    await db.execute('''CREATE TABLE $tableTodo(
          ${TableTodoField.id} TEXT,
          ${TableTodoField.title} TEXT,
          ${TableTodoField.description} TEXT,
          ${TableTodoField.completed} INTEGER,
          ${TableTodoField.createDate} TEXT,
          ${TableTodoField.updateDate} TEXT
          )''');
  }

  Future closeDatabase() async {
    final database = await instance.database;
    database.close();
  }

  Future<void> addTodoOffline(String uid, title, description) async {
    try {
      final db = await instance.database;

      final todo = {
        '_id': uid,
        'title': title,
        'description': description,
        'completed': 0,
        'create_date': DateTime.now().toString(),
        'update_date': DateTime.now().toString()
      };

      await db.insert(tableTodo, todo).catchError((err) {
        debugPrint(err);
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Todo>> fetchTodosOffline() async {
    List<Todo> todos = [];
    try {
      final db = await instance.database;

      final response = await db.query(
        tableTodo,
        columns: [
          TableTodoField.id,
          TableTodoField.title,
          TableTodoField.description,
          TableTodoField.completed,
          TableTodoField.createDate,
          TableTodoField.updateDate,
        ],
      );

      if (response.isNotEmpty) {
        response.map((e) {
          todos.add(
            Todo(
              uid: e['_id'].toString(),
              title: e['title'].toString(),
              description: e['description'].toString(),
              completed: e['completed'].toString() == '1' ? true : false,
              createDate: Timestamp.fromDate(
                  DateTime.parse(e['create_date'].toString())),
              updateDate: Timestamp.fromDate(
                  DateTime.parse(e['create_date'].toString())),
            ),
          );
        }).toList();
      }
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }

    return todos;
  }

  Future<void> deleteTodoOffline(String uid) async {
    try {
      final db = await instance.database;

      db.delete(
        tableTodo,
        where: '_id = ?',
        whereArgs: [uid],
      ).catchError((err) {
        debugPrint(err);
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteAllData() async {
    try {
      final db = await instance.database;
      db.delete(tableTodo);
    } catch (e) {
      rethrow;
    }
  }
}

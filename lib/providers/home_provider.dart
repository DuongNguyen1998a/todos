import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todos/local_db/todo_database.dart';
import 'package:todos/models/todo.dart';

import '../services/services.dart';

class HomeProvider extends ChangeNotifier {
  Services services = Services();

  late List<Todo> _todos = [];
  List<Todo> get todos => _todos;

  final List<Todo> _tempTodos = [];

  List<Todo> get tempTodo => _tempTodos;

  bool _isLoading = false;
  bool get isLoading => _isLoading;



  bool _isCompleted = false;
  bool get isCompleted => _isCompleted;

  bool _isInternet = false;

  bool get isInternet => _isInternet;

  Future<void> fetchTodos() async {
    try {
      _isCompleted = false;
      _isLoading = true;
      await Future.delayed(const Duration(seconds: 1)).then((value) async {
        final response = await services.fetchTodos();
        if (response.isNotEmpty) {
          _todos.clear();
          _tempTodos.clear();
          _todos.addAll(response);
          _tempTodos.addAll(response);
          _isLoading = false;
          _isCompleted = true;
          notifyListeners();
        } else {
          _todos.clear();
          _tempTodos.clear();
          _isLoading = false;
          _isCompleted = true;
          notifyListeners();
        }
      });

    } catch (e) {
      _todos.clear();
      _tempTodos.clear();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> fetchTodosOffline() async {
    try {
      _todos.clear();
      _tempTodos.clear();
      _isLoading = true;
      notifyListeners();
      final response = await TodoDatabase.instance.fetchTodosOffline();
      if (response.isNotEmpty) {
        _todos.addAll(response);
        _tempTodos.addAll(response);
        _isLoading = false;
        notifyListeners();
      } else {
        _todos.clear();
        _tempTodos.clear();
        _isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      _todos.clear();
      _tempTodos.clear();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> syncFromOfflineToOnline() async {
    try {
      _isLoading = true;
      notifyListeners();
      final localTodos = await TodoDatabase.instance.fetchTodosOffline();
      final onlineTodos = await services.fetchTodos();

      if (localTodos.isNotEmpty) {
        localTodos.forEach((local) {
          if (onlineTodos.isEmpty) {
            services.addTodo(
              local.title,
              local.description,
              local.uid,
              Timestamp.fromDate(local.createDate.toDate()),
              Timestamp.fromDate(local.updateDate.toDate()),
            );
          } else {
            if (!onlineTodos.map((online) => online.uid).contains(local.uid)) {
              services.addTodo(
                local.title,
                local.description,
                local.uid,
                Timestamp.fromDate(local.createDate.toDate()),
                Timestamp.fromDate(local.updateDate.toDate()),
              );
            }
          }
        });
      } else {
        debugPrint('local todos empty');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> deleteTodo(String uid) async {
    try {
      final response = await services.deleteTodo(uid);
      if (response) {
        _todos.removeWhere((element) => element.uid == uid);
        notifyListeners();
        _tempTodos.clear();
        _tempTodos.addAll(_todos);
        notifyListeners();
      }
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteTodoOffline(String uid) async {
    try {
      await TodoDatabase.instance.deleteTodoOffline(uid).then((_) {
        _todos.removeWhere((element) => element.uid == uid);
        notifyListeners();
        _tempTodos.clear();
        _tempTodos.addAll(_todos);
        notifyListeners();
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> completeTodo(String uid) async {
    try {
      await services.completeTodo(uid);
      _todos[_todos.indexWhere((element) => element.uid == uid)].completed =
          true;
      notifyListeners();
      _tempTodos.clear();
      _tempTodos.addAll(_todos);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> editTodo(
      String uid, title, description, Timestamp updateDate) async {
    try {
      await services.editTodo(
        uid,
        title,
        description,
        updateDate,
      );
      _todos[_todos.indexWhere((element) => element.uid == uid)].title = title;
      _todos[_todos.indexWhere((element) => element.uid == uid)].description =
          description;
      _todos[_todos.indexWhere((element) => element.uid == uid)].updateDate =
          updateDate;
      notifyListeners();
      _tempTodos.clear();
      _tempTodos.addAll(_todos);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  void toggleInternet(bool value) {
    _isInternet = value;
    notifyListeners();
  }

  void filterTodos(String value) {
    if (value == 'completed') {
      _todos.clear();
      _todos.addAll(
          _tempTodos.where((element) => element.completed == true).toList());
      notifyListeners();
    } else if (value == 'uncompleted') {
      _todos.clear();
      _todos.addAll(
          _tempTodos.where((element) => element.completed == false).toList());
      notifyListeners();
    } else {
      _todos.clear();
      _todos.addAll(_tempTodos);
      notifyListeners();
    }
  }

  Future<void> deleteDataOffline() async {
    await TodoDatabase.instance.deleteAllData();
  }
}

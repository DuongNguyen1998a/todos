import 'package:cloud_firestore/cloud_firestore.dart';

final String tableTodo = 'todos';

class TableTodoField {
  static final String id = '_id';
  static final String title = 'title';
  static final String description = 'description';
  static final String completed = 'completed';
  static final String createDate = 'create_date';
  static final String updateDate = 'update_date';
}

class Todo {
  String uid;
  String title;
  String description;
  bool completed;
  Timestamp createDate;
  Timestamp  updateDate;

  Todo({
    required this.uid,
    required this.title,
    required this.description,
    required this.completed,
    required this.createDate,
    required this.updateDate,
  });

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      uid: json['uid'],
      title: json['title'],
      description: json['description'],
      completed: json['completed'],
      createDate: json['create_date'],
      updateDate: json['update_date'],
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['uid'] = this.uid;
    data['title'] = this.title;
    data['description'] = this.description;
    data['completed'] = this.completed;
    data['create_date'] = this.createDate;
    data['update_date'] = this.updateDate;
    return data;
  }
}

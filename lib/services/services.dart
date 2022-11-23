import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:todos/local_db/todo_database.dart';
import 'package:todos/models/todo.dart';
import 'package:todos/models/user.dart' as userModel;

class Services {
  Future<String> signUpWithEmailAndPassword(
      String email, String password, String fullName) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      credential.user!.updateDisplayName(fullName);
      credential.user!.sendEmailVerification();

      return '200';
    } on FirebaseAuthException catch (e) {
      return e.message ?? '500 - Unknown error.';
    }
  }

  Future<String> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final isVerify = credential.user!.emailVerified;

      if (isVerify) {
        return '200';
      } else {
        return 'Account is not active, please check email to active account';
      }
    } on FirebaseAuthException catch (e) {
      debugPrint(e.message);
      return e.message ?? '500 - Unkonwn error';
    }
  }

  Future<String> resetPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      return '200';
    } on FirebaseAuthException catch (e) {
      debugPrint(e.message);
      return e.message ?? '500 - Unkonwn error';
    }
  }

  Future<userModel.User?> fetchUserProfile() async {
    try {
      final currentUser = await FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        return userModel.User(
          uid: currentUser.uid,
          email: currentUser.email ?? '',
          fullName: currentUser.displayName ?? '',
        );
      } else {
        return null;
      }
    } on FirebaseAuthException catch (e) {
      debugPrint(e.message);
      return null;
    }
  }

  Future<void> logOut() async {
    try {
      await FirebaseAuth.instance.signOut();
    } on FirebaseAuthException catch (e) {
      debugPrint(e.message);
      rethrow;
    }
  }

  Future<String> changePassword(String password) async {
    try {
      final currentUser = await FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        currentUser.updatePassword(password);
        return '200';
      } else {
        return 'change password failed, please try again.';
      }
    } on FirebaseAuthException catch (e) {
      debugPrint(e.message);
      return e.message ?? '500 - Unkonwn error';
    }
  }

  Future<List<Todo>> fetchTodos() async {
    List<Todo> todos = [];
    try {
      await InternetConnectionChecker().hasConnection.then((value) async {
        if (value) {
          await FirebaseFirestore.instance
              .collection('todos')
              .get()
              .then((value) {
            if (value.docs.isNotEmpty) {
              value.docs.forEach((element) {
                final todo = Todo(
                  uid: element.id,
                  title: element['title'],
                  description: element['description'],
                  completed: element['completed'],
                  createDate: element['create_date'],
                  updateDate: element['update_date'],
                );
                todos.add(todo);
              });
            }
          }).catchError((err) {
            debugPrint(err.toString());
          });
        }
      });
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
    return todos;
  }

  Future<bool> deleteTodo(String docId) async {
    bool isDeleted = false;
    try {
      await FirebaseFirestore.instance
          .collection('todos')
          .doc(docId)
          .delete()
          .then((_) {
        isDeleted = true;
      }).catchError((err) {
        debugPrint(err.toString());
        isDeleted = false;
      });
      return isDeleted;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<String> addTodo(String title, description, String? uid,
      Timestamp? createDate, Timestamp? updateDate) async {
    try {
      final todo = {
        'title': title,
        'description': description,
        'completed': false,
        'create_date': createDate != null
            ? createDate
            : Timestamp.fromDate(DateTime.now()),
        'update_date': updateDate != null
            ? updateDate
            : Timestamp.fromDate(DateTime.now()),
      };

      if (uid != null) {
        await FirebaseFirestore.instance
            .collection('todos')
            .doc(uid)
            .set(todo)
            .catchError((err) {
          debugPrint(err);
        });
        return '200';
      } else {
        final response = await FirebaseFirestore.instance
            .collection('todos')
            .add(todo)
            .catchError((err) {
          debugPrint(err);
        });
        return response.id;
      }
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<void> completeTodo(String uid) async {
    try {
      final todo = {
        'completed': true,
        'update_date': Timestamp.fromDate(DateTime.now()),
      };
      await FirebaseFirestore.instance
          .collection('todos')
          .doc(uid)
          .update(todo)
          .catchError((err) {
        debugPrint(err.toString());
      });
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<void> editTodo(
      String uid, title, description, Timestamp updateDate) async {
    try {
      final todo = {
        'title': title,
        'description': description,
        'update_date': updateDate,
      };
      await FirebaseFirestore.instance
          .collection('todos')
          .doc(uid)
          .update(todo)
          .catchError((err) {
        debugPrint(err.toString());
      });
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }
}

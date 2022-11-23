import 'package:flutter/cupertino.dart';
import 'package:flutter_launcher_icons/constants.dart';
import 'package:todos/local_db/todo_database.dart';
import 'package:todos/utils/helper.dart';

/// screens
import '../screens/screens.dart';
import '../services/services.dart';

class BottomNavigationProvider extends ChangeNotifier {
  Services services = Services();

  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  final List<Widget> _screens = [
    HomeScreen(),
    ProfileScreen(),
  ];

  List<Widget> get screens => _screens;

  void onChangeScreen(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  Future<String> addTodo(String title, description) async {
    try {
      final value = await services
          .addTodo(title, description, null, null, null);
      return value;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addTodoOffline(String? uid, String title, description) async {
    try {
      await TodoDatabase.instance
          .addTodoOffline(uid != null ? uid : UniqueKey().toString(), title, description);
    } catch (e) {
      rethrow;
    }
  }
}

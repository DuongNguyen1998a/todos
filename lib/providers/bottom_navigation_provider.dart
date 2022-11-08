import 'package:flutter/cupertino.dart';
import 'package:flutter_launcher_icons/constants.dart';
/// screens
import '../screens/screens.dart';

class BottomNavigationProvider extends ChangeNotifier {
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

}
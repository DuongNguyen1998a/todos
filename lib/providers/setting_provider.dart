import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingProvider extends ChangeNotifier {
  List<String> _languages = ['English', 'Vietnamese'];
  List<String> get languages => _languages;

  int _selected = 0;
  int get selected => _selected;

  bool _notification = true;
  bool get notification =>_notification;

  void toggleNotification() {
    _notification = !_notification;
    notifyListeners();
  }

  void onChangeLanguage(int index, BuildContext context) {
    _selected = index;
    notifyListeners();
    if (_selected == 1) {
      context.setLocale(Locale('vi', 'VI'));
    }
    else {
      context.setLocale(Locale('en', 'US'));
    }
  }

  Future<void> saveSetting() async {
    final prefs = await SharedPreferences.getInstance();

    prefs.setString('LANGUAGE', _selected == 1 ? 'vi' : 'en');
    prefs.setBool('NOTIFICATION', _notification);

    exit(0);
  }

  Future<void> initLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getString('LANGUAGE') != null) {
      if (prefs.getString('LANGUAGE') == 'vi') {
        _selected = 1;
        notifyListeners();
      }
      else {
        _selected = 0;
        notifyListeners();
      }
    }
  }

}
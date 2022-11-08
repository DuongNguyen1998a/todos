import 'package:flutter/cupertino.dart';

class SignInProvider extends ChangeNotifier {
  bool _obscureText = true;
  bool get obscureText => _obscureText;

  void toggleObscureText() {
    _obscureText = !_obscureText;
    notifyListeners();
  }
}
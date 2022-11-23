import 'package:flutter/cupertino.dart';
/// services
import '../services/services.dart';

class SignInProvider extends ChangeNotifier {
  Services services = Services();

  bool _obscureText = true;
  bool get obscureText => _obscureText;

  void toggleObscureText() {
    _obscureText = !_obscureText;
    notifyListeners();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<String> signInWithEmailAndPassword(String email, password) async {
    try {
      _isLoading = true;
      notifyListeners();
      final response = await services.signInWithEmailAndPassword(email, password);
      _isLoading = false;
      notifyListeners();
      return response;
    }
    catch (e) {
      rethrow;
    }
  }

  void resetScreenState() {
    _obscureText = true;
    _isLoading = false;
    notifyListeners();
  }
}
import 'package:flutter/cupertino.dart';

/// services
import '../services/services.dart';

class SignUpProvider extends ChangeNotifier {
  Services services = Services();

  bool _hidePassword = true;

  bool get hidePassword => _hidePassword;

  void togglePassword() {
    _hidePassword = !_hidePassword;
    notifyListeners();
  }

  bool _hideConfirmPassword = true;

  bool get hideConfirmPassword => _hideConfirmPassword;

  void toggleConfirmPassword() {
    _hideConfirmPassword = !_hideConfirmPassword;
    notifyListeners();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<String> signUpWithEmailAndPassword(
    String email,
    String password,
    String fullName,
  ) async {
    try {
      _isLoading = true;
      notifyListeners();
      final response = await services.signUpWithEmailAndPassword(email, password, fullName);
      _isLoading = false;
      notifyListeners();
      return response;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }
}

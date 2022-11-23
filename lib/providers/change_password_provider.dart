import 'package:flutter/cupertino.dart';

import '../services/services.dart';

class ChangePasswordProvider extends ChangeNotifier {
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

  Future<String> changePassword(String password) async {
    try {
      _isLoading = true;
      notifyListeners();
      final response = await services.changePassword(password);
      _isLoading = false;
      notifyListeners();
      return response;
    }
    catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  void resetScreenState() {
    _hidePassword = true;
    _hideConfirmPassword = true;
    _isLoading = false;
    notifyListeners();
  }

}
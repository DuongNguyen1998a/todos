import 'package:flutter/material.dart';
/// services
import '../services/services.dart';

class ForgotPasswordProvider extends ChangeNotifier {
  Services services = Services();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<String> resetPassword(String password) async {
    try {
      _isLoading = true;
      notifyListeners();
      final response = await services.resetPassword(password);
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


}
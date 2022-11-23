import 'package:flutter/cupertino.dart';
import '../models/user.dart';
/// services
import '../services/services.dart';

class ProfileProvider extends ChangeNotifier {
  Services services = Services();

  User? _userProfile = null;
  User? get userProfile => _userProfile;


  Future<void> fetchUserProfile() async {
    try {
      final response = await services.fetchUserProfile();

      if (response != null) {
        _userProfile = response;
        notifyListeners();
      }
    }
    catch (e) {
      rethrow;
    }
  }

  Future<void> logOut() async {
    try {
      await services.logOut();
    }
    catch (e) {
      rethrow;
    }
  }
}
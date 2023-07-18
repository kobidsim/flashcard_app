import 'package:flashcard_app/entities/user.dart' as app_user;
import 'package:flutter/material.dart';

class UserData extends ChangeNotifier {
  final app_user.User _user = app_user.user;

  int get xp => _user.xp;
  String get name => _user.username;

  bool get loggedIn => _user.session != null;

  Future<bool> signIn(String email, String password) async {
    bool success = false;
    await _user.signIn(email, password).then((value) {
      success = value;
      //debugPrint("DEBUG::Outside xp = $xp");
      notifyListeners();
    });
    return success;
  }

  Future<bool> signUp(String username, String email, String password) async {
    bool success = false;
    await _user.signUp(username, email, password).then((value) {
      success = value;
      notifyListeners();
    });
    return success;
  }

  void signOut() {
    _user.signOut().then((value) => notifyListeners());
  }
}

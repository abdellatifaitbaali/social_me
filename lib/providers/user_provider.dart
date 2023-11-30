import 'package:flutter/cupertino.dart';
import 'package:social_me/models/user.dart';
import 'package:social_me/resources/auth_methods.dart';

class UserProvider with ChangeNotifier {
  MUser? _user;
  final AuthMethods _authMethods = AuthMethods();

  MUser get getUser => _user!;

  Future<void> refreshUser() async {
    MUser user = await _authMethods.getUserDetails();
    _user = user;
    notifyListeners();
  }
}

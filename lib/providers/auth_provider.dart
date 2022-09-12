import 'package:flutter/cupertino.dart';
import 'package:kikis_app/models/auth.dart';

class AuthProvider extends ChangeNotifier {
  late Auth _auth;

  bool _inLoad = false;

  bool get inLoad => _inLoad;

  Auth get auth => _auth;
  set auth(Auth value) => _auth = value;

  void changeLoad(bool value) {
    _inLoad = value;
    notifyListeners();
  }
}

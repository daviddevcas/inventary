import 'package:flutter/cupertino.dart';

class AuthProvider extends ChangeNotifier {
  bool _inLoad = false;
  List<String> errorBag = [];

  bool get inLoad => _inLoad;

  void changeLoad(bool value) {
    _inLoad = value;
    notifyListeners();
  }

  void addError(String error) {
    errorBag.add(error);
    notifyListeners();
  }

  void cleanErrorBag() {
    errorBag = [];
    notifyListeners();
  }
}

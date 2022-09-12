import 'package:flutter/cupertino.dart';

class AdminProvider extends ChangeNotifier {
  int _page = 0;

  int get page => _page;

  void changePage(int value) {
    _page = value;
    notifyListeners();
  }
}

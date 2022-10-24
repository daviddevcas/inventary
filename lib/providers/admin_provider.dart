import 'package:flutter/cupertino.dart';
import 'package:kikis_app/models/product.dart';
import 'package:kikis_app/models/user.dart';

class AdminProvider extends ChangeNotifier {
  int _page = 0;

  int get page => _page;

  List<User> users = [
    User(name: 'david', email: 'daviddisjoint@gmail.com', password: 'password'),
    User(name: 'alan', email: 'alan12@hotmail.com', password: 'password'),
  ];

  List<Product> products = [
    Product(
        name: 'silla',
        description: 'silla',
        classroom: 'E05',
        count: 5,
        reports: null)
  ];

  void hoverProduct(int index) {
    products[index].size = products[index].size == 250 ? 300 : 250;
    notifyListeners();
  }

  void changePage(int value) {
    _page = value;
    notifyListeners();
  }
}

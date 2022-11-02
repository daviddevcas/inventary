import 'package:flutter/cupertino.dart';
import 'package:kikis_app/models/product.dart';
import 'package:kikis_app/models/user.dart';
import 'package:kikis_app/services/admin_service.dart';

class AdminProvider extends ChangeNotifier {
  int page = 0;

  List<User> users = [];
  List<Product> products = [];

  final adminService = AdminService();

  void hoverProduct(Product product) {
    int index = products.indexOf(product);
    products[index].size = products[index].size == 250 ? 300 : 250;
    notifyListeners();
  }

  void changePage(int value) {
    page = value;
    notifyListeners();
  }

  void updateUsers() {
    adminService.getUsers().then((value) {
      var map = value;

      if (map['success'] == true) {
        users = map['users'];
        notifyListeners();
      }
    });
  }

  void updateUser(User user) {
    adminService.updateUser(user);
    notifyListeners();
  }

  void updateProducts() {
    adminService.getProducts().then((value) {
      var map = value;

      if (map['success'] == true) {
        products = map['products'];
        notifyListeners();
      }
    });
  }
}

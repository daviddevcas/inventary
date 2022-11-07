import 'package:flutter/cupertino.dart';
import 'package:kikis_app/models/product.dart';
import 'package:kikis_app/models/user.dart';
import 'package:kikis_app/services/admin_service.dart';

class AdminProvider extends ChangeNotifier {
  int page = 0;

  List<User> users = [];
  List<Product> products = [];

  bool isUpdateUsers = false, isUpdateProducts = false;

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

  Future updateUsers() async {
    isUpdateUsers = true;
    notifyListeners();
    Map<String, dynamic> map = await adminService.getUsers();

    if (map['success'] == true) {
      users = map['users'];
    }

    isUpdateUsers = false;
    notifyListeners();
  }

  void updateUser(User user) {
    adminService.updateUser(user);
    notifyListeners();
  }

  Future updateProducts() async {
    isUpdateProducts = true;
    notifyListeners();
    Map<String, dynamic> map = await adminService.getProducts();
    if (map['success'] == true) {
      products = map['products'];
    }
    isUpdateProducts = false;
    notifyListeners();
  }
}

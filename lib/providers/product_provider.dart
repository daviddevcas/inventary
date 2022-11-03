import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:kikis_app/models/product.dart';
import 'package:kikis_app/services/admin_service.dart';

class ProductProvider extends ChangeNotifier {
  Product? product;
  File? pictureFile;
  bool isLoading = false, isSaving = false;
  int page = 0;

  final adminService = AdminService();

  void changePage(int value) {
    page = value;
    notifyListeners();
  }

  void stateLoaging(bool value) {
    isLoading = value;
    notifyListeners();
  }

  void stateSaving(bool value) {
    isSaving = value;
    notifyListeners();
  }

  void updateSelectedProductImage(String path) {
    product?.pathPhoto = path;
    pictureFile = File.fromUri(Uri(path: path));
    notifyListeners();
  }

  void updateProduct() {
    adminService.updateProduct(product!, pictureFile).then((value) {
      var map = value;

      if (map['success'] == true) {
        notifyListeners();
        pictureFile = null;
      }
    });
  }
}

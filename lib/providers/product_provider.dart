import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:kikis_app/models/product.dart';

class ProductProvider extends ChangeNotifier {
  int page = 0;
  Product? product;
  File? pictureFile;
  bool isLoading = true, isSaving = false;

  void changePage(int value) {
    page = value;
    notifyListeners();
  }

  void updateSelectedProductImage(String path) {
    product?.pathPhoto = path;
    pictureFile = File.fromUri(Uri(path: path));
    notifyListeners();
  }
}

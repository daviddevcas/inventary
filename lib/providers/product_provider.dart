import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:kikis_app/models/product.dart';
import 'package:kikis_app/models/report.dart';
import 'package:kikis_app/services/admin_service.dart';

class ProductProvider extends ChangeNotifier {
  Product product = Product(name: '', description: '', classroom: '');
  List<Report> reports = [];

  bool isLoading = false, isSaving = false;
  int page = 0;

  File? pictureFile;

  final adminService = AdminService();

  void changePage(int value) {
    page = value;
    notifyListeners();
  }

  void stateLoaging(bool value) {
    isLoading = value;
    notifyListeners();
  }

  void updateSelectedProductImage(String path) {
    product.pathPhoto = path;
    pictureFile = File.fromUri(Uri(path: path));
    notifyListeners();
  }

  void addReport() {
    if (product.reports == null) {
      product.reports = <Report>[
        Report(subject: 'Reporte nuevo', description: '', classroom: '')
      ];
    } else {
      product.reports!.add(
          Report(subject: 'Reporte nuevo', description: '', classroom: ''));
    }
    notifyListeners();
  }

  void refreshProduct() async {
    isLoading = true;
    notifyListeners();

    if (product.id != null) {
      String id = product.id!;

      var response = await adminService.getProduct(id);

      if (response['success'] == true && response['product'] != null) {
        product = response['product'];
        product.id = id;
      }
    }

    isLoading = false;
    notifyListeners();
  }

  void updateProduct() async {
    isSaving = true;
    notifyListeners();

    var request = await adminService.updateProduct(product, pictureFile);

    if (request['success']) {
      product = request['product'];
    }

    pictureFile = null;

    isSaving = false;
    notifyListeners();
  }
}

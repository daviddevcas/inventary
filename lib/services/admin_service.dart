import 'dart:io';

import 'package:dio/dio.dart';
import 'package:kikis_app/models/product.dart';
import 'package:kikis_app/models/user.dart';

class AdminService {
  final Dio _dio = Dio(BaseOptions(
      baseUrl: 'https://inventario-24e0c-default-rtdb.firebaseio.com'));

  final Dio _dioStorage = Dio(BaseOptions(
      baseUrl: 'https://inventario-24e0c-default-rtdb.firebaseio.com'));

  Future<Map<String, dynamic>> getUsers() async {
    List<User> users = [];

    try {
      final request = await _dio.get(
        '/inventario/usuarios.json',
      );

      final Map<String, dynamic> maps = request.data;

      maps.forEach((key, value) {
        User user = User.fromJson(value);
        user.id = key;

        users.add(user);
      });
    } catch (e) {
      return {'success': false};
    }
    return {'users': users, 'success': true};
  }

  Future<Map<String, dynamic>> updateUser(User user) async {
    try {
      await _dio.put('/inventario/usuarios/${user.id}.json',
          data: user.toJson());
    } catch (e) {
      return {'success': false};
    }
    return {'success': true};
  }

  Future<Map<String, dynamic>> getProducts() async {
    List<Product> products = [];

    try {
      final request = await _dio.get(
        '/inventario/productos.json',
      );

      final Map<String, dynamic> maps = request.data;

      maps.forEach((key, value) {
        Product product = Product.fromJson(value);
        product.id = key;

        products.add(product);
      });
    } catch (e) {
      return {'success': false};
    }
    return {'products': products, 'success': true};
  }

  Future<Map<String, dynamic>> uploadImage(File pictureFile) async {
    try {
      String fileName = pictureFile.path.split('/').last;

      FormData data = FormData.fromMap({
        "file": await MultipartFile.fromFile(
          pictureFile.path,
          filename: fileName,
        ),
      });

      final request =
          _dioStorage.post("http://192.168.43.225/api/media", data: data);
    } catch (e) {
      return {'success': false};
    }
    return {'success': true};
  }
}

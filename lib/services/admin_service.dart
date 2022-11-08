import 'dart:io';

import 'package:dio/dio.dart';
import 'package:kikis_app/models/product.dart';
import 'package:kikis_app/models/user.dart';

class AdminService {
  final Dio _dio = Dio(BaseOptions(
      baseUrl: 'https://inventario-24e0c-default-rtdb.firebaseio.com'));

  final Dio _dioStorage = Dio(BaseOptions(
      baseUrl:
          'https://api.cloudinary.com/v1_1/instituto-tecnol-gico-superior-de-poza-rica/image/'));

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
        '/inventario/productos.json?orderBy="nombre"&limitToLast=100',
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

  Future<Map<String, dynamic>> getProduct(String id) async {
    Product? product;

    try {
      final request = await _dio.get(
        '/inventario/productos/$id.json',
      );

      product = Product.fromJson(request.data);
    } catch (e) {
      return {'success': false};
    }
    return {'product': product, 'success': true};
  }

  Future<Map<String, dynamic>> updateProduct(
      Product product, File? file) async {
    try {
      if (file != null) {
        if (product.id != null) {
          _uploadImage(file).then((value) {
            product.pathPhoto = value;
            _dio.put('/inventario/productos/${product.id}.json',
                data: product.toJson());
          });
        } else {
          _uploadImage(file).then((value) async {
            product.pathPhoto = value;
            final request = await _dio.post('/inventario/productos.json',
                data: product.toJson());
            product.id = request.data['name'];
          });
        }
      } else {
        if (product.id != null) {
          await _dio.put('/inventario/productos/${product.id}.json',
              data: product.toJson());
        } else {
          final request = await _dio.post('/inventario/productos.json',
              data: product.toJson());
          product.id = request.data['name'];
        }
      }
    } catch (e) {
      return {'success': false};
    }
    return {'success': true, 'product': product};
  }

  Future<Map<String, dynamic>> deleteProduct(String id) async {
    try {
      _dio.delete('/inventario/productos/$id.json');
    } catch (e) {
      return {'success': false};
    }
    return {'success': true};
  }

  Future<String> _uploadImage(File pictureFile) async {
    FormData formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(pictureFile.path,
          filename: pictureFile.path.split('/').last),
    });
    final response =
        await _dioStorage.post('upload?upload_preset=lhjj81vx', data: formData);

    return response.data['secure_url'];
  }
}

import 'package:dio/dio.dart';
import 'package:kikis_app/models/user.dart';
import 'package:kikis_app/models/auth.dart';

class LoginService {
  final Dio _dio =
      Dio(BaseOptions(baseUrl: 'https://api-kikis-pr.herokuapp.com/'));

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _dio
          .post('login', data: {'email': email, 'password': password});

      switch (response.statusCode) {
        case 200:
          return {
            'succes': true,
            'user': Auth.fromJson(response.data),
            'token': response.data['token']
          };
        default:
          return {'succes': false, 'msg': 'Status not valid'};
      }
    } on DioError catch (exception) {
      return {'succes': false, 'msg': exception.toString()};
    }
  }

  Future<Map<String, dynamic>> register(User user) async {
    try {
      final response = await _dio.post('register', data: user.toJson());

      switch (response.statusCode) {
        case 200:
          return {'succes': true};
        default:
          return {'succes': false, 'msg': 'Status not valid'};
      }
    } on DioError catch (exception) {
      return {'succes': false, 'msg': exception.toString()};
    }
  }
}

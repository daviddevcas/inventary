import 'package:dio/dio.dart';
import 'package:kikis_app/models/user.dart';
import 'package:kikis_app/models/auth.dart';

class LoginService {
  final Dio _dioAuth = Dio(BaseOptions(
      baseUrl: 'https://identitytoolkit.googleapis.com/v1/accounts'));

  final String projectKey = 'AIzaSyAIPVYYXqdk4N86zMrwiK_27h7tP0Peepw';

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _dioAuth.post(
          ":signInWithPassword?key=$projectKey",
          data: {'email': email, 'password': password});

      switch (response.statusCode) {
        case 200:
          return {
            'success': true,
          };
        default:
          return {'success': false, 'msg': 'Status not valid'};
      }
    } on DioError catch (exception) {
      return {
        'success': false,
        'msg': 'Correo o contraseña incorrectos.',
        'exception': exception
      };
    }
  }

  Future<Map<String, dynamic>> register(User user, String password) async {
    try {
      final response = await _dioAuth.post(':signUp?key=$projectKey',
          data: {'email': user.email, 'password': password});

      switch (response.statusCode) {
        case 200:
          return {'success': true};
        default:
          return {'success': false, 'msg': 'Status not valid'};
      }
    } on DioError catch (exception) {
      return {
        'success': false,
        'msg': 'Ha ocurrido algún error.',
        'exception': exception
      };
    }
  }
}

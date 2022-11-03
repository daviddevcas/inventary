import 'package:dio/dio.dart';
import 'package:kikis_app/models/auth.dart';
import 'package:kikis_app/models/user.dart';

class LoginService {
  final Dio _dioAuth = Dio(BaseOptions(
      baseUrl: 'https://identitytoolkit.googleapis.com/v1/accounts'));
  final Dio _dio = Dio(BaseOptions(
      baseUrl: 'https://inventario-24e0c-default-rtdb.firebaseio.com'));

  final String projectKey = 'AIzaSyAIPVYYXqdk4N86zMrwiK_27h7tP0Peepw';

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final User? user = await _getUser(email);

      if (user == null || !user.status) {
        throw Exception('No access');
      }

      final response = await _dioAuth
          .post(":signInWithPassword?key=$projectKey", data: {
        'email': email,
        'password': password,
        'returnSecureToken': true
      });

      final Auth auth = Auth(
          name: user.name,
          email: user.email,
          token: response.data['idToken'],
          status: user.status);

      switch (response.statusCode) {
        case 200:
          return {'success': true, 'auth': auth};
        default:
          return {'success': false, 'msg': 'Status not valid'};
      }
    } catch (exception) {
      return {
        'success': false,
        'msg': 'Correo o contraseña incorrectos.',
        'exception': exception
      };
    }
  }

  Future<Map<String, dynamic>> register(User user, String password) async {
    try {
      final response = await _dioAuth.post(':signUp?key=$projectKey', data: {
        'email': user.email,
        'password': password,
        'returnSecureToken': true
      });
      await _createUser(user);

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

  Future<User?> _getUser(String email) async {
    User? user;
    final request = await _dio.get(
      '/inventario/usuarios.json',
    );

    final Map<String, dynamic> maps = request.data;

    user = User.fromJson(
        maps.values.firstWhere((element) => element['correo'] == email));

    return user;
  }

  Future _createUser(User user) async {
    await _dio.post('/inventario/usuarios.json', data: user.toJson());
  }
}

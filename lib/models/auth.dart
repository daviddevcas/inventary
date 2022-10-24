import 'package:kikis_app/models/user.dart';

class Auth extends User {
  Auth(
      {required super.name,
      required super.email,
      required super.password,
      required this.token});

  String? token;

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['email'] = email;
    data['token'] = token;
    return data;
  }

  static Auth fromJson(Map<String, dynamic> data) {
    return Auth(
        name: data['name'],
        email: data['email'],
        password: data['password'],
        token: data['token']);
  }
}

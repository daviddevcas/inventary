class User {
  User({required this.name, required this.email, required this.password});

  final String name;
  final String email;
  final String? password;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['nombre'] = name;
    data['correo'] = email;
    return data;
  }

  static User fromJson(Map<String, dynamic> data) {
    return User(
        name: data['nombre'],
        email: data['correo'],
        password: data['contraseña']);
  }
}

class User {
  User(
      {this.id, required this.name, required this.email, required this.status});

  String name;
  String email;
  String? id;
  bool status;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['nombre'] = name;
    data['correo'] = email;
    data['estado'] = status;
    return data;
  }

  static User fromJson(Map<String, dynamic> data) {
    return User(
        name: data['nombre'], email: data['correo'], status: data['estado']);
  }
}

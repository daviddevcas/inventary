class User {
  User({required this.name, required this.email});

  final String? name;
  final String? email;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['email'] = email;
    return data;
  }

  static User fromJson(Map<String, dynamic> data) {
    return User(name: data['name'], email: data['email']);
  }
}

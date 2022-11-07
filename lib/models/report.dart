class Report {
  Report(
      {required this.subject,
      required this.description,
      required this.classroom});
  String subject;
  String description;
  String classroom;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['asunto'] = subject;
    data['descripcion'] = description;
    data['aula'] = classroom;

    return data;
  }

  static Report fromJson(Map<String, dynamic> data) {
    return Report(
        subject: data['asunto'],
        description: data['descripcion'],
        classroom: data['aula']);
  }
}

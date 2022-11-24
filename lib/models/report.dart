class Report {
  Report(
      {required this.subject,
      required this.description,
      required this.classroom,
      this.verified});
  String subject;
  String description;
  String classroom;
  bool? verified;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['asunto'] = subject;
    data['descripcion'] = description;
    data['aula'] = classroom;
    data['verified'] = verified ?? false;

    return data;
  }

  static Report fromJson(Map<String, dynamic> data) {
    return Report(
        subject: data['asunto'],
        description: data['descripcion'],
        classroom: data['aula'],
        verified: data['verified'] ?? false);
  }
}

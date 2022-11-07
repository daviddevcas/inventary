import 'package:kikis_app/models/report.dart';

class Product {
  Product(
      {required this.name,
      required this.description,
      required this.classroom,
      this.reports,
      this.pathPhoto});
  String name;
  String description;
  String classroom;
  String? pathPhoto;
  String? id;
  List<Report>? reports;
  double size = 250;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    final List list = [];

    data['nombre'] = name;
    data['descripcion'] = description;
    data['aula'] = classroom;
    data['link_foto'] = pathPhoto;
    if (reports != null) {
      for (var i = 0; i < reports!.length; i++) {
        list.add(reports![i].toJson());
      }
    }
    data['reportes'] = list;
    return data;
  }

  static Product fromJson(Map<String, dynamic> data) {
    List<Report> reports = [];

    if (data['reportes'] != null) {
      for (var element in data['reportes']) {
        reports.add(Report.fromJson(element));
      }
    }

    return Product(
        name: data['nombre'],
        description: data['descripcion'],
        classroom: data['aula'],
        reports: reports,
        pathPhoto: data['link_foto']);
  }

  List<Report> getReportsInOrden() {
    List<Report> reports = [];

    if (this.reports != null) {
      for (var i = this.reports!.length - 1; i >= 0; i--) {
        reports.add(this.reports![i]);
      }
    }

    return reports;
  }
}

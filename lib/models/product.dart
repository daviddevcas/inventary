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
    data['nombre'] = name;
    data['descripcion'] = description;
    data['aula'] = classroom;
    data['link_foto'] = pathPhoto;
    data['reportes'] = reports;
    return data;
  }

  static Product fromJson(Map<String, dynamic> data) {
    return Product(
        name: data['nombre'],
        description: data['descripcion'],
        classroom: data['aula'],
        reports: data['reportes'],
        pathPhoto: data['link_foto']);
  }
}

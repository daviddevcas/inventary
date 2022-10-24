import 'package:kikis_app/models/report.dart';

class Product {
  Product(
      {required this.name,
      required this.description,
      required this.classroom,
      required this.count,
      required this.reports});
  final String name;
  final String description;
  final String classroom;
  final int count;
  final List<Report>? reports;
  double size = 250;
}

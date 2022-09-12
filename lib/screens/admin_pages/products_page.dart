import 'package:fluent_ui/fluent_ui.dart';

class ProductsPage extends StatelessWidget {
  const ProductsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      header: const PageHeader(
        title: Text('Productos'),
      ),
      content: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Column(children: []),
      ),
    );
  }
}

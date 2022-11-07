import 'package:fluent_ui/fluent_ui.dart';
import 'package:kikis_app/providers/providers.dart';
import 'package:kikis_app/screens/product_pages/product_pages.dart';
import 'package:provider/provider.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final adminProvider = Provider.of<AdminProvider>(context, listen: false);

    return NavigationView(
      pane: NavigationPane(
          header: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Button(
              onPressed: () {
                adminProvider.updateProducts();
                Navigator.pop(context);
              },
              child: const Text(
                'Regresar',
              ),
            ),
          ),
          displayMode: PaneDisplayMode.top,
          selected: productProvider.page,
          onChanged: (i) {
            productProvider.changePage(i);
          },
          items: [
            PaneItem(
                mouseCursor: SystemMouseCursors.click,
                icon: const Icon(FluentIcons.screen_time),
                title: const Text('Información'),
                body: InformationPage(
                  productProvider: productProvider,
                )),
            PaneItem(
                mouseCursor: SystemMouseCursors.click,
                icon: const Icon(FluentIcons.product),
                title: const Text('Reportes'),
                body: ReportsPage(
                  productProvider: productProvider,
                ))
          ]),
    );
  }
}

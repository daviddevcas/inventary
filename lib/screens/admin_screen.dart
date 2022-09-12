import 'package:fluent_ui/fluent_ui.dart';
import 'package:kikis_app/providers/admin_provider.dart';
import 'package:kikis_app/screens/admin_pages/admin_pages.dart';
import 'package:provider/provider.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final adminProvider = Provider.of<AdminProvider>(context);

    return NavigationView(
      appBar: const NavigationAppBar(
          leading: Center(
        child: FlutterLogo(
          size: 25,
        ),
      )),
      pane: NavigationPane(
          displayMode: PaneDisplayMode.auto,
          selected: adminProvider.page,
          onChanged: (i) {
            adminProvider.changePage(i);
          },
          header: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: DefaultTextStyle(
                style: FluentTheme.of(context).typography.title!,
                child: const Text('Administración')),
          ),
          items: [
            PaneItem(
                icon: const Icon(FluentIcons.screen_time),
                title: const Text('Panel')),
            PaneItem(
                icon: const Icon(FluentIcons.product),
                title: const Text('Menú'))
          ]),
      content: NavigationBody(index: adminProvider.page, children: const [
        PanelPage(),
        ProductsPage(),
      ]),
    );
  }
}

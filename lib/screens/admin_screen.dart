import 'package:fluent_ui/fluent_ui.dart';
import 'package:kikis_app/providers/admin_provider.dart';
import 'package:kikis_app/providers/auth_provider.dart';
import 'package:kikis_app/screens/admin_pages/admin_pages.dart';
import 'package:provider/provider.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final adminProvider = Provider.of<AdminProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);

    return NavigationView(
      appBar: NavigationAppBar(
          title: Text(
            "Bienvenido ${authProvider.auth?.name ?? ''}",
            style: const TextStyle(fontSize: 19),
          ),
          leading: const Center(
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
                mouseCursor: SystemMouseCursors.click,
                icon: const Icon(FluentIcons.user_window),
                title: const Text('Usuarios'),
                body: PanelPage(
                  adminProvider: adminProvider,
                )),
            PaneItem(
                mouseCursor: SystemMouseCursors.click,
                icon: const Icon(FluentIcons.product),
                title: const Text('Menú'),
                body: ProductsPage(
                  adminProvider: adminProvider,
                ))
          ]),
    );
  }
}

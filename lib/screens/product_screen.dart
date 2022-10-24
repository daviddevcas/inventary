import 'package:fluent_ui/fluent_ui.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NavigationView(
      pane: NavigationPane(
          header: Button(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Regresar',
            ),
          ),
          displayMode: PaneDisplayMode.top,
          selected: 1,
          onChanged: (i) {},
          items: [
            PaneItem(
                icon: const Icon(FluentIcons.screen_time),
                title: const Text('Información'),
                body: Container()),
            PaneItem(
                icon: const Icon(FluentIcons.product),
                title: const Text('Reportes'),
                body: Container())
          ]),
    );
  }
}

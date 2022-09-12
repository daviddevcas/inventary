import 'package:fluent_ui/fluent_ui.dart';

class PanelPage extends StatelessWidget {
  const PanelPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      header: const PageHeader(
        title: Text('Panel'),
      ),
      content: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Column(children: []),
      ),
    );
  }
}

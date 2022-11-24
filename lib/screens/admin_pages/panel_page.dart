import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material;
import 'package:kikis_app/models/user.dart';
import 'package:kikis_app/providers/admin_provider.dart';

class PanelPage extends StatelessWidget {
  const PanelPage({Key? key, required this.adminProvider}) : super(key: key);

  final AdminProvider adminProvider;

  @override
  Widget build(BuildContext context) {
    final users = adminProvider.users;

    double width = MediaQuery.of(context).size.width;

    return ScaffoldPage(
      header: const PageHeader(
        title: Text('Usuarios'),
      ),
      content: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 30),
              child: Row(children: [
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Button(
                      onPressed: !adminProvider.isUpdateUsers
                          ? () {
                              adminProvider.refreshUsers();
                            }
                          : null,
                      child: const Text('Actualizar')),
                )
              ]),
            ),
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(1),
                  child: width > 1024
                      ? DataTable(users: users, adminProvider: adminProvider)
                      : DataList(adminProvider: adminProvider, users: users),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class DataTable extends StatelessWidget {
  const DataTable({Key? key, required this.adminProvider, required this.users})
      : super(key: key);

  final AdminProvider adminProvider;
  final List<User> users;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: material.DataTable(
        columns: <material.DataColumn>[
          material.DataColumn(
              label: Text(
            "ID",
            style: styleColumn(),
          )),
          material.DataColumn(
              label: Text(
            "Nombre",
            style: styleColumn(),
          )),
          material.DataColumn(
            label: Text(
              "Correo",
              style: styleColumn(),
            ),
          ),
          material.DataColumn(
              label: Text(
            "Estado",
            style: styleColumn(),
          )),
        ],
        rows: users
            .map((user) => material.DataRow(cells: [
                  material.DataCell(Text(user.id!)),
                  material.DataCell(Text(user.name)),
                  material.DataCell(Text(user.email)),
                  material.DataCell(MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Checkbox(
                      checked: user.status,
                      onChanged: (value) {
                        user.status = value!;
                        adminProvider.updateUser(user);
                      },
                    ),
                  )),
                ]))
            .toList(),
      ),
    );
  }

  TextStyle styleColumn() =>
      const TextStyle(fontSize: 16, fontWeight: FontWeight.bold);
}

class DataList extends StatelessWidget {
  const DataList({Key? key, required this.adminProvider, required this.users})
      : super(key: key);

  final AdminProvider adminProvider;
  final List<User> users;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: users
          .map((user) => ElementList(
              name: user.name,
              email: user.email,
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Checkbox(
                  content: const Text('Estado'),
                  checked: user.status,
                  onChanged: (value) {
                    user.status = value!;
                    adminProvider.updateUser(user);
                  },
                ),
              )))
          .toList(),
    );
  }
}

class ElementList extends StatelessWidget {
  const ElementList({
    Key? key,
    required this.child,
    required this.name,
    required this.email,
  }) : super(key: key);

  final Widget child;
  final String name, email;

  @override
  Widget build(BuildContext context) {
    return Expander(
        header: Row(children: [
          const Icon(FluentIcons.user_window),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(name),
          )
        ]),
        content: Row(
          children: [
            Expanded(child: Text(email)),
            Expanded(
              child: Center(
                child: child,
              ),
            )
          ],
        ));
  }
}

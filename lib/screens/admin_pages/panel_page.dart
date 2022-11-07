import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material;
import 'package:kikis_app/providers/admin_provider.dart';

class PanelPage extends StatelessWidget {
  const PanelPage({Key? key, required this.adminProvider}) : super(key: key);

  final AdminProvider adminProvider;

  @override
  Widget build(BuildContext context) {
    final users = adminProvider.users;

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
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                child: SingleChildScrollView(
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
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  TextStyle styleColumn() =>
      const TextStyle(fontSize: 16, fontWeight: FontWeight.bold);
}

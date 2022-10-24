import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart';
import 'package:kikis_app/providers/admin_provider.dart';
import 'package:provider/provider.dart';

class PanelPage extends StatelessWidget {
  const PanelPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final adminService = Provider.of<AdminProvider>(context);

    final users = adminService.users;

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
              child: Row(children: const [
                Button(onPressed: null, child: Text('Actualizar'))
              ]),
            ),
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                child: DataTable(
                  columns: <DataColumn>[
                    DataColumn(
                        label: Text(
                      "Nombre",
                      style: styleColumn(),
                    )),
                    DataColumn(
                      label: Text(
                        "Correo",
                        style: styleColumn(),
                      ),
                    ),
                    DataColumn(
                        label: Text(
                      "Editar",
                      style: styleColumn(),
                    )),
                    DataColumn(
                        label: Text(
                      "Eliminar",
                      style: styleColumn(),
                    )),
                  ],
                  rows: users
                      .map((user) => DataRow(cells: [
                            DataCell(Text(user.name)),
                            DataCell(Text(user.email)),
                            const DataCell(Button(
                              onPressed: null,
                              child: Text('Editar'),
                            )),
                            const DataCell(Button(
                              onPressed: null,
                              child: Text('Eliminar'),
                            )),
                          ]))
                      .toList(),
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

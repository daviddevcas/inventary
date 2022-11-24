import 'package:fluent_ui/fluent_ui.dart';
import 'package:kikis_app/models/report.dart';
import 'package:kikis_app/providers/product_provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class ReportsPage extends StatelessWidget {
  const ReportsPage({Key? key, required this.productProvider})
      : super(key: key);

  final ProductProvider productProvider;

  @override
  Widget build(BuildContext context) {
    final reports = productProvider.product.getReportsInOrden();

    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              verticalDirection: VerticalDirection.down,
              children: [
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Button(
                      onPressed: !productProvider.isLoading
                          ? productProvider.refreshProduct
                          : null,
                      child: const Text('Actualizar')),
                ),
                const SizedBox(
                  width: 30,
                ),
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Button(
                      onPressed: productProvider.addReport,
                      child: const Text('Crear reporte')),
                )
              ],
            ),
          ),
          Expanded(
            child: reports.isNotEmpty
                ? SingleChildScrollView(
                    child: Column(
                      children: reports
                          .map((report) => ExpanderReport(
                                productProvider: productProvider,
                                report: report,
                              ))
                          .toList(),
                    ),
                  )
                : const Center(
                    child: Icon(
                      FluentIcons.document_management,
                      size: 100,
                    ),
                  ),
          )
        ],
      ),
    );
  }
}

class ExpanderReport extends StatelessWidget {
  const ExpanderReport({
    required this.report,
    required this.productProvider,
    Key? key,
  }) : super(key: key);

  final Report report;
  final ProductProvider productProvider;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Expander(
        leading: const Icon(FluentIcons.report_document),
        header: Text(report.subject),
        content: ReportPalette(
          report: report,
          productProvider: productProvider,
        ),
      ),
    );
  }
}

class ReportPalette extends StatelessWidget {
  ReportPalette({
    required this.report,
    required this.productProvider,
    Key? key,
  }) : super(key: key);

  final ProductProvider productProvider;

  final Report report;
  final List<TextEditingController> controllers = List.generate(3, (i) {
    return TextEditingController();
  });

  @override
  Widget build(BuildContext context) {
    controllers[0].text = report.subject;
    controllers[1].text = report.classroom;
    controllers[2].text = report.description;

    return Column(children: [
      Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            Expanded(
                flex: 3,
                child: TextBox(
                  header: 'Asunto',
                  placeholder: 'Asunto',
                  controller: controllers[0],
                )),
            const SizedBox(
              width: 60,
            ),
            Expanded(
                flex: 2,
                child: TextBox(
                  header: 'Aula',
                  placeholder: 'Aula',
                  controller: controllers[1],
                )),
            const SizedBox(
              width: 60,
            ),
            Expanded(
                child: Center(
              child: Checkbox(
                content: const Text('Problema atendido'),
                checked: report.verified ?? false,
                onChanged: (value) {
                  report.verified = value!;
                  productProvider.verifiedReport(report);
                },
              ),
            ))
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8),
        child: TextBox(
          header: 'Descripción',
          placeholder: 'Esto fue lo que ocurrió con este elemento...',
          controller: controllers[2],
          maxLines: 10,
          minLines: 1,
          minHeight: 100,
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8),
        child: Wrap(children: [
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Button(
                onPressed: !productProvider.isSaving
                    ? () {
                        if (controllers[0].text != '' &&
                            controllers[1].text != '' &&
                            controllers[2].text != '') {
                          report.subject = controllers[0].text;
                          report.classroom = controllers[1].text;
                          report.description = controllers[2].text;
                          productProvider.updateProduct();
                          Alert(
                            context: context,
                            title: "Se ha actualizado el reporte.",
                            buttons: [
                              DialogButton(
                                onPressed: () => Navigator.pop(context),
                                width: 120,
                                child: const Text(
                                  "Cerrar",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                              )
                            ],
                          ).show();
                        }
                      }
                    : null,
                child: const Text('Guardar')),
          ),
          const SizedBox(
            width: 30,
          ),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Button(
                onPressed: !productProvider.isSaving
                    ? () {
                        productProvider.product.reports!.remove(report);
                        productProvider.updateProduct();
                        Alert(
                          context: context,
                          title: "Se ha eliminado el reporte.",
                          buttons: [
                            DialogButton(
                              onPressed: () => Navigator.pop(context),
                              width: 120,
                              child: const Text(
                                "Cerrar",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                            )
                          ],
                        ).show();
                      }
                    : null,
                child: const Text('Eliminar')),
          )
        ]),
      )
    ]);
  }
}

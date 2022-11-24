import 'dart:io';

import 'package:file_picker_cross/file_picker_cross.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:kikis_app/models/product.dart';
import 'package:kikis_app/providers/admin_provider.dart';
import 'package:kikis_app/widgets/image_path.dart';
import 'package:path_provider/path_provider.dart'
    show getApplicationDocumentsDirectory;
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:kikis_app/providers/product_provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:screenshot/screenshot.dart';

class InformationPage extends StatelessWidget {
  InformationPage({Key? key, required this.productProvider}) : super(key: key);

  final ProductProvider productProvider;
  final ScreenshotController screenshotController = ScreenshotController();
  final List<TextEditingController> controllers = List.generate(4, (i) {
    return TextEditingController();
  });

  @override
  Widget build(BuildContext context) {
    final adminProvider = Provider.of<AdminProvider>(context, listen: false);
    double width = MediaQuery.of(context).size.width;

    final product = productProvider.product;

    controllers[0].text = product.name;
    controllers[1].text = product.classroom;
    controllers[2].text = product.description;

    return width > 1024
        ? SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: SingleChildScrollView(
                    child: QrPart(
                        product: product,
                        screenshotController: screenshotController),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: double.infinity,
                    color: const Color.fromARGB(40, 50, 49, 48),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(8.0),
                      child: DataPart(
                          product: product,
                          controllers: controllers,
                          productProvider: productProvider,
                          adminProvider: adminProvider),
                    ),
                  ),
                ),
              ],
            ))
        : SingleChildScrollView(
            child: Column(children: [
              Container(
                color: const Color.fromARGB(40, 50, 49, 48),
                padding: const EdgeInsets.all(8),
                child: DataPart(
                    product: product,
                    controllers: controllers,
                    productProvider: productProvider,
                    adminProvider: adminProvider),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: QrPart(
                    product: product,
                    screenshotController: screenshotController),
              )
            ]),
          );
  }
}

class DataPart extends StatelessWidget {
  const DataPart({
    Key? key,
    required this.product,
    required this.controllers,
    required this.productProvider,
    required this.adminProvider,
  }) : super(key: key);

  final Product product;
  final List<TextEditingController> controllers;
  final ProductProvider productProvider;
  final AdminProvider adminProvider;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
            width: 300, height: 300, child: ImagePath(path: product.pathPhoto)),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextBox(
            header: 'Nombre',
            placeholder: 'Nombre',
            controller: controllers[0],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextBox(
            header: 'Aula',
            placeholder: 'Aula',
            controller: controllers[1],
          ),
        ),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextBox(
              header: 'Descripción',
              placeholder: 'Este elemento está conformado por ...',
              controller: controllers[2],
              maxLines: 10,
              minLines: 1,
              minHeight: 100,
            )),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Wrap(
            verticalDirection: VerticalDirection.down,
            children: [
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Button(
                    onPressed: !productProvider.isLoading
                        ? () async {
                            productProvider.stateLoaging(true);
                            try {
                              FilePickerCross file =
                                  await FilePickerCross.importFromStorage(
                                type: FileTypeCross.image,
                              );

                              productProvider
                                  .updateSelectedProductImage(file.path!);
                            } catch (e) {
                              productProvider.stateLoaging(false);
                              return;
                            }
                            productProvider.stateLoaging(false);
                          }
                        : null,
                    child: Wrap(
                      children: const [
                        Text('Subir imágen '),
                        Icon(FluentIcons.upload)
                      ],
                    )),
              ),
              const SizedBox(
                width: 30,
              ),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Button(
                    onPressed: !productProvider.isSaving
                        ? () {
                            if (controllers[0].text != '' &&
                                controllers[1].text != '' &&
                                controllers[2].text != '') {
                              product.name = controllers[0].text;
                              product.classroom = controllers[1].text;
                              product.description = controllers[2].text;
                              productProvider.updateProduct();
                              Alert(
                                context: context,
                                title: "Se ha actualizado el producto.",
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
                    child: const Text('Guardar información')),
              ),
              const SizedBox(
                width: 30,
              ),
              MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Button(
                    child: const Text('Eliminar'),
                    onPressed: () {
                      Alert(
                        context: context,
                        title: "¿Desea eliminar el producto?",
                        buttons: [
                          DialogButton(
                            onPressed: () async {
                              adminProvider.subProduct(product);

                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                            width: 120,
                            child: const Text(
                              "Eliminar",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ),
                          DialogButton(
                            onPressed: () => Navigator.pop(context),
                            width: 120,
                            child: const Text(
                              "Cerrar",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          )
                        ],
                      ).show();
                    },
                  ))
            ],
          ),
        )
      ],
    );
  }
}

class QrPart extends StatelessWidget {
  const QrPart({
    Key? key,
    required this.product,
    required this.screenshotController,
  }) : super(key: key);

  final Product product;
  final ScreenshotController screenshotController;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: product.id == null
          ? const ProgressRing()
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Screenshot(
                  controller: screenshotController,
                  child: QrImage(
                    data: product.id!,
                    version: QrVersions.auto,
                    size: 320,
                    errorStateBuilder: (cxt, err) {
                      return const Center(
                        child: Text(
                          'Ha ocurrido algún problema...',
                          textAlign: TextAlign.center,
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Button(
                        onPressed: () async {
                          try {
                            await screenshotController
                                .capture(
                                    delay: const Duration(milliseconds: 10))
                                .then((image) async {
                              if (image != null) {
                                final directory =
                                    await getApplicationDocumentsDirectory();
                                final imagePath = await File(
                                        '${directory.path}/qr-${product.id}.png')
                                    .create();
                                await imagePath.writeAsBytes(image);
                                Alert(
                                  context: context,
                                  title:
                                      "Se ha almacenado la imagen en documentos.",
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
                            });
                          } catch (e) {
                            return;
                          }
                        },
                        child: const Text('Obtener imagen')),
                  ),
                )
              ],
            ),
    );
  }
}

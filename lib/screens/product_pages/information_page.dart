import 'package:file_picker_cross/file_picker_cross.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:kikis_app/models/product.dart';
import 'package:kikis_app/ui/image_path.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:kikis_app/providers/product_provider.dart';

class InformationPage extends StatelessWidget {
  InformationPage({Key? key, required this.productProvider}) : super(key: key);

  final ProductProvider productProvider;
  final List<TextEditingController> controllers = List.generate(4, (i) {
    return TextEditingController();
  });

  @override
  Widget build(BuildContext context) {
    final product = productProvider.product ??
        Product(name: '', description: '', classroom: '');

    controllers[0].text = product.name;
    controllers[1].text = product.classroom;
    controllers[2].text = product.description;

    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Center(
              child: product.id == null
                  ? const ProgressRing()
                  : QrImage(
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
          ),
          Expanded(
            child: Container(
              height: double.infinity,
              color: const Color.fromARGB(40, 50, 49, 48),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                        width: 300,
                        height: 300,
                        child: ImagePath(path: product.pathPhoto)),
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
                      child: Row(
                        verticalDirection: VerticalDirection.down,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Button(
                              onPressed: !productProvider.isLoading
                                  ? () async {
                                      productProvider.stateLoaging(true);
                                      try {
                                        FilePickerCross file =
                                            await FilePickerCross
                                                .importFromStorage(
                                          type: FileTypeCross.image,
                                        );

                                        productProvider
                                            .updateSelectedProductImage(
                                                file.path!);
                                      } catch (e) {
                                        productProvider.stateLoaging(false);
                                        return;
                                      }
                                      productProvider.stateLoaging(false);
                                    }
                                  : null,
                              child: Row(
                                children: const [
                                  Text('Subir imágen '),
                                  Icon(FluentIcons.upload)
                                ],
                              )),
                          const SizedBox(
                            width: 30,
                          ),
                          Button(
                              onPressed: !productProvider.isSaving
                                  ? () {
                                      productProvider.stateSaving(true);
                                      product.name = controllers[0].text;
                                      product.classroom = controllers[1].text;
                                      product.description = controllers[2].text;
                                      productProvider.updateProduct();
                                      productProvider.stateSaving(false);
                                    }
                                  : null,
                              child: const Text('Guardar información'))
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
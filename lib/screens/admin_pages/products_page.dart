import 'dart:io' show Platform;

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:kikis_app/models/product.dart';
import 'package:kikis_app/providers/admin_provider.dart';
import 'package:kikis_app/providers/product_provider.dart';
import 'package:kikis_app/screens/product_screen.dart';
import 'package:kikis_app/widgets/image_path.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class ProductsPage extends StatelessWidget {
  const ProductsPage({Key? key, required this.adminProvider}) : super(key: key);

  final AdminProvider adminProvider;
  @override
  Widget build(BuildContext context) {
    final products = adminProvider.getProductsInOrden();
    final productProvider = Provider.of<ProductProvider>(context);

    return ScaffoldPage(
      header: const PageHeader(
        title: Text('Productos'),
      ),
      content: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 30),
          child: Wrap(children: [
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Button(
                  onPressed: !adminProvider.isUpdateProducts
                      ? () {
                          adminProvider.refreshProducts();
                        }
                      : null,
                  child: const Text('Actualizar')),
            ),
            const SizedBox(
              width: 30,
            ),
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Button(
                  onPressed: () {
                    adminProvider.addProduct();
                  },
                  child: const Text('Crear producto')),
            ),
            const SizedBox(
              width: 30,
            ),
            if (Platform.isAndroid)
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Button(
                    onPressed: () {
                      FlutterBarcodeScanner.scanBarcode(
                              '#3D8BEF', 'Cancelar', false, ScanMode.QR)
                          .then((value) {
                        if (value != '-1') {
                          Product product = adminProvider.products
                              .firstWhere((product) => product.id == value);

                          productProvider.product = product;

                          Navigator.push(
                              context,
                              FluentPageRoute(
                                  builder: (context) => const ProductScreen()));
                        } else {
                          Alert(
                            context: context,
                            title: "Producto no encontrado.",
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
                    },
                    child: const Text('Escanear')),
              )
          ]),
        ),
        Expanded(
            child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Center(
              child: Wrap(
                children: products
                    .map((product) => ProductWidget(
                          productProvider: productProvider,
                          adminProvider: adminProvider,
                          product: product,
                        ))
                    .toList(),
              ),
            ),
          ),
        ))
      ]),
    );
  }
}

class ProductWidget extends StatelessWidget {
  const ProductWidget(
      {Key? key,
      required this.product,
      required this.adminProvider,
      required this.productProvider})
      : super(key: key);

  final AdminProvider adminProvider;
  final ProductProvider productProvider;
  final Product product;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () {
        productProvider.product = product;

        Navigator.push(context,
            FluentPageRoute(builder: (context) => const ProductScreen()));
      },
      child: MouseRegion(
          onEnter: width > 1024
              ? (event) {
                  adminProvider.hoverProduct(product);
                }
              : null,
          onExit: width > 1024
              ? (event) {
                  adminProvider.hoverProduct(product);
                }
              : null,
          cursor: SystemMouseCursors.click,
          child: AnimatedContainer(
            margin: const EdgeInsets.all(10),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            decoration: const BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(
                      5.0,
                      5.0,
                    ),
                    blurRadius: 10.0,
                    spreadRadius: 2.0,
                  )
                ],
                color: Color.fromARGB(29, 50, 49, 48),
                borderRadius: BorderRadius.all(Radius.circular(15))),
            constraints: const BoxConstraints(maxHeight: 300, maxWidth: 300),
            duration: const Duration(milliseconds: 300),
            width: product.size,
            height: product.size,
            child: Stack(
              fit: StackFit.expand,
              children: [
                ImagePath(path: product.pathPhoto),
                Positioned(
                    bottom: 15,
                    left: 15,
                    right: 25,
                    child: Container(
                        width: 200,
                        decoration: const BoxDecoration(
                            color: Colors.grey,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          product.name,
                          maxLines: 2,
                          overflow: TextOverflow.fade,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16),
                        )))
              ],
            ),
          )),
    );
  }
}

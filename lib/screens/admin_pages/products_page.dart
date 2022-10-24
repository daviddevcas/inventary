import 'package:fluent_ui/fluent_ui.dart';
import 'package:kikis_app/providers/admin_provider.dart';
import 'package:kikis_app/screens/product_screen.dart';
import 'package:provider/provider.dart';

class ProductsPage extends StatelessWidget {
  const ProductsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final adminProvider = Provider.of<AdminProvider>(context);

    return ScaffoldPage(
      header: const PageHeader(
        title: Text('Productos'),
      ),
      content: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              FluentPageRoute(
                                  builder: (context) => const ProductScreen()));
                        },
                        child: MouseRegion(
                            onEnter: (event) {
                              adminProvider.hoverProduct(0);
                            },
                            onExit: (event) {
                              adminProvider.hoverProduct(0);
                            },
                            cursor: SystemMouseCursors.click,
                            child: AnimatedContainer(
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
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15))),
                              constraints: const BoxConstraints(
                                  maxHeight: 300, maxWidth: 300),
                              duration: const Duration(milliseconds: 300),
                              width: adminProvider.products[0].size,
                              height: adminProvider.products[0].size,
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  Image.network(
                                      'https://image.shutterstock.com/image-vector/vector-qr-code-sample-smartphone-600w-521220724.jpg'),
                                  Positioned(
                                      bottom: 15,
                                      left: 15,
                                      right: 25,
                                      child: Container(
                                          width: 200,
                                          decoration: const BoxDecoration(
                                              color: Colors.grey,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10))),
                                          padding: const EdgeInsets.all(10),
                                          child: const Text(
                                            'Producto',
                                            maxLines: 2,
                                            overflow: TextOverflow.fade,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16),
                                          )))
                                ],
                              ),
                            )),
                      )
                    ],
                  )))
        ]),
      ),
    );
  }
}

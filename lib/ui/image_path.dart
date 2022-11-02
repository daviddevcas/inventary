import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluent_ui/fluent_ui.dart';

class ImagePath extends StatelessWidget {
  const ImagePath({Key? key, this.path}) : super(key: key);

  final String? path;

  @override
  Widget build(BuildContext context) {
    if (path == null) {
      return CachedNetworkImage(
        fit: BoxFit.fill,
        imageUrl:
            'https://firebasestorage.googleapis.com/v0/b/inventario-24e0c.appspot.com/o/default_product.jpg?alt=media&token=441b44aa-2a3e-446f-8e21-6939cc1e34a1',
        placeholder: (context, url) => const Center(child: ProgressRing()),
        errorWidget: (context, url, error) =>
            const Center(child: Icon(FluentIcons.error)),
      );
    } else if (path!.startsWith('http')) {
      return CachedNetworkImage(
        fit: BoxFit.fill,
        imageUrl: path!,
        placeholder: (context, url) => const Center(child: ProgressRing()),
        errorWidget: (context, url, error) =>
            const Center(child: Icon(FluentIcons.error)),
      );
    } else {
      return Image.file(
        File(path!),
        fit: BoxFit.cover,
      );
    }
  }
}

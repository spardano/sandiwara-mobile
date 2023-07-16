import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageNews extends StatelessWidget {
  const ImageNews({
    Key? key,
    required this.image,
  }) : super(key: key);
  final String image;
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      // imageUrl: snapshot.data![index]!.image!,
      imageUrl: image,
      imageBuilder: (context, imageProvider) {
        return Container(
          height: 100,
          width: 100,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(
              Radius.circular(8.0),
            ),
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,
            ),
          ),
        );
      },
      progressIndicatorBuilder: (context, url, downloadProgress) =>
          CircularProgressIndicator(value: downloadProgress.progress),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
  }
}

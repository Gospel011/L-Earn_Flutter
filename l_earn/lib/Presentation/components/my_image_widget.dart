import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:l_earn/Presentation/components/my_image_loading_placeholder_widget.dart';

class MyImageWidget extends StatelessWidget {
  const MyImageWidget(
      {super.key, required this.image, this.borderRadius, this.boxfit});

  final double? borderRadius;
  final BoxFit? boxfit;

  final String image;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(borderRadius ?? 16.0)),
      child: CachedNetworkImage(
        imageUrl: image,
        fit: boxfit,
        placeholder: (context, url) => const ImageLoadingPlaceHolderWidget(),
        errorWidget: (context, url, error) =>
            const ImageLoadingPlaceHolderWidget(),
        fadeInDuration: const Duration(milliseconds: 1),
        fadeInCurve: Curves.linear,
      ),
    );
  }
}

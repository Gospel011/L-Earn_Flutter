import 'package:flutter/material.dart';
import 'package:l_earn/Presentation/components/my_image_loading_placeholder_widget.dart';

class MyImageWidget extends StatelessWidget {
  const MyImageWidget({super.key, required this.image, this.borderRadius});

  final double? borderRadius;

  final String image;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(borderRadius ?? 16.0)),
        child: Image.network(
          image,
          loadingBuilder: (context, child, progress) {            
            if (progress == null) return child; 
            return const ImageLoadingPlaceHolderWidget(); 
          },
        ));
  }
}


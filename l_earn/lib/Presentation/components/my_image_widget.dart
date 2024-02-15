import 'package:flutter/material.dart';

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
            print(progress);
            if (progress == null) return child; 
            return Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
              ),
            ); 
          },
        ));
  }
}

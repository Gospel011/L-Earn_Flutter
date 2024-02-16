import 'package:flutter/material.dart';

class ImageLoadingPlaceHolderWidget extends StatelessWidget {
  const ImageLoadingPlaceHolderWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
      ),
    );
  }
}

// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class ImageLoadingPlaceHolderWidget extends StatelessWidget {
  const ImageLoadingPlaceHolderWidget(
      {super.key, this.width, this.height, this.placeHolderText});

  final double? width;
  final double? height;
  final String? placeHolderText;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? 200,
      height: height ?? 200,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
      ),
      child: Center(child: Text(placeHolderText ?? ''),),
    );
  }
}

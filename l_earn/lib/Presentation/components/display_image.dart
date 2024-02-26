import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class DisplayImage extends StatelessWidget {
  const DisplayImage(
      {super.key,
      required XFile? pickedImage,
      this.minHeight = 0.0,
      this.maxHeight = 500,
      this.borderRadius})
      : _pickedImage = pickedImage;

  final XFile? _pickedImage;
  final double minHeight;
  final double maxHeight;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.maxFinite,
        constraints: BoxConstraints(maxHeight: maxHeight, minHeight: minHeight),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(borderRadius ?? 16),
            child: _pickedImage != null
                ? Image.file(
                    File(_pickedImage!.path),
                    fit: BoxFit.cover,
                  )
                : const SizedBox()));
  }
}

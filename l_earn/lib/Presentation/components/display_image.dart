import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class DisplayImage extends StatelessWidget {
  const DisplayImage({
    super.key,
    required XFile? pickedImage,
  }) : _pickedImage = pickedImage;

  final XFile? _pickedImage;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.maxFinite,
        constraints: const BoxConstraints(maxHeight: 500),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: _pickedImage != null ? Image.file(
              File(_pickedImage!.path),
              fit: BoxFit.fill,
            ): const SizedBox()));
  }
}
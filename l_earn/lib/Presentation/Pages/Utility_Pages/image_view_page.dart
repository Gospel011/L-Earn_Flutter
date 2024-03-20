import 'package:flutter/material.dart';
import 'package:l_earn/Presentation/components/my_image_widget.dart';

class ImageViewPage extends StatelessWidget {
  const ImageViewPage({super.key, required this.image});

  final String image;

  static final TransformationController transformationController =
      TransformationController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text('Pinch to Zoom'),
      ),
      body: GestureDetector(
        onDoubleTap: (){
          transformationController.value = Matrix4.identity();
        },
        child: InteractiveViewer(
            transformationController: transformationController,
            maxScale: 8,
            child: Center(child: MyImageWidget(image: image, borderRadius: 0))),
      ),
    );
  }
}

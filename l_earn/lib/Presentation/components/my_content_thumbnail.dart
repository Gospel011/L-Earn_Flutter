import 'package:flutter/material.dart';
import 'package:l_earn/DataLayer/Models/content_model.dart';
import 'package:l_earn/Presentation/components/my_image_widget.dart';
import 'package:l_earn/utils/constants.dart';

class MyContentThumbnail extends StatelessWidget {
  const MyContentThumbnail({super.key, required this.content, this.borderRadius});

  final Content content;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
            width: double.maxFinite,
            child: MyImageWidget(image: content.thumbnailUrl, borderRadius: borderRadius)),
        Positioned(
            bottom: 8,
            right: 8,
            child: SizedBox(
                height: 48,
                width: 48,
                child:
                    content.type == 'book' ? AppIcons.book : AppIcons.appLogo))
      ],
    );
  }
}

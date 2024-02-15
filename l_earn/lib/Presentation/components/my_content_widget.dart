import 'package:flutter/material.dart';
import 'package:l_earn/DataLayer/Models/content_model.dart';

import 'package:l_earn/Presentation/components/content_meta_widget.dart';
import 'package:l_earn/Presentation/components/my_content_thumbnail.dart';
import 'package:l_earn/Presentation/components/my_post_header.dart';

class MyContent extends StatelessWidget {
  const MyContent(
      {super.key,
      required this.content,
      required this.onThumbnailPressed,
      required this.onMetaPressed});

  final Content content;
  final void Function() onThumbnailPressed;
  final void Function() onMetaPressed;

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      //? Content Header
      MyPostHeader(user: content.author),

      //? Content thumbnail
      GestureDetector(
          onTap: onThumbnailPressed,
          child: MyContentThumbnail(content: content)),

      //? Content meta
      GestureDetector(
        onTap: onMetaPressed,
        child: ContentMetaWidget(
          content: content,
        ),
      )
    ]);
  }
}

import 'package:flutter/material.dart';
import 'package:l_earn/DataLayer/Models/content_model.dart';

import 'package:l_earn/Presentation/components/content_meta_widget.dart';
import 'package:l_earn/Presentation/components/my_content_thumbnail.dart';
import 'package:l_earn/Presentation/components/my_elevated_button.dart';
import 'package:l_earn/Presentation/components/my_post_header.dart';

class MyContent extends StatelessWidget {
  const MyContent(
      {super.key,
      required this.content,
      required this.onThumbnailPressed,
      required this.onMetaPressed,
      this.onHeaderPressed,
      this.moreActions});

  final Content content;
  final void Function() onThumbnailPressed;
  final void Function() onMetaPressed;
  final void Function()? onHeaderPressed;
  final List<PopupMenuEntry<String>>? moreActions;

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      //? Content Header
      GestureDetector(
          onTap: onHeaderPressed,
          child: MyPostHeader(
            user: content.author,
            moreActions: moreActions,
          )),

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
      ),
    ]);
  }
}

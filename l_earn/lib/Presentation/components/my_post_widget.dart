import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:l_earn/DataLayer/Models/post_model.dart';

import 'package:l_earn/Presentation/components/my_expandable_text.dart';
import 'package:l_earn/Presentation/components/my_image_widget.dart';
import 'package:l_earn/Presentation/components/my_like_comment_share_widget.dart';

import 'package:l_earn/Presentation/components/my_post_header.dart';

class MyPostWidget extends StatelessWidget {
  const MyPostWidget({
    super.key,
    required this.post,
    required this.index,
    this.moreActions
  });

  final Post post;
  final int index;
  final List<PopupMenuEntry<String>>? moreActions;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //? ROW WITH PROFILE PICTURE, NAME, HANDLE AND MORE ICON
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, '/profile-page', arguments: post.user),
            child: MyPostHeader(user: post.user, moreActions: moreActions)),

          //? TEXT
          MyExpandableText(text: post.text),

          //? [POLL -- > next launch] OR IMAGE
          // BarChart()
          post.image != null
              ? GestureDetector(
                onTap:() {
                  Navigator.pushNamed(context, '/image-view-page', arguments: post.image!);
                },
                child: Container(
                    width: double.maxFinite,
                    constraints: const BoxConstraints(maxHeight: 500),
                    child: MyImageWidget(image: post.image!)),
              )
              : const SizedBox(),

          //? LIKES COMMENTS SHARES
          MyLikeCommentShareWidget(post: post, index: index)
        ],
      ),
    );
  }
}

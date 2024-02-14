import 'package:flutter/material.dart';
import 'package:l_earn/DataLayer/Models/post_model.dart';
import 'package:l_earn/DataLayer/Models/user_model.dart';
import 'package:l_earn/Presentation/components/my_like_comment_share_widget.dart';
import 'package:l_earn/Presentation/components/my_list_tile.dart';
import 'package:l_earn/Presentation/components/my_profile_picture.dart';
import 'package:l_earn/Presentation/components/render_user_name.dart';
import 'package:l_earn/utils/colors.dart';
import 'package:l_earn/utils/constants.dart';

class MyPostWidget extends StatelessWidget {
  const MyPostWidget({
    super.key,
    required this.post,
    required this.index,
  });

  final Post post;
  final int index;

  @override
  Widget build(BuildContext context) {
    final String fullName = '${post.user.firstName} ${post.user.lastName}';
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //? ROW WITH PROFILE PICTURE, NAME, HANDLE AND MORE ICON
          MyPostHeader(user: post.user),

          //? TEXT
          MyExpandableText(text: post.text),

          //? [POLL -- > next launch] OR IMAGE
          // BarChart()
          post.image != null
              ? Container(
                  width: double.maxFinite,
                  constraints: const BoxConstraints(maxHeight: 500),
                  child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(16)),
                      child: Image.network(post.image!)))
              : const SizedBox(),

          //? LIKES COMMENTS SHARES
          MyLikeCommentShareWidget(post: post, index: index)
        ],
      ),
    );
  }
}

class MyExpandableText extends StatefulWidget {
  const MyExpandableText({
    super.key,
    required this.text,
  });

  final String text;

  @override
  State<MyExpandableText> createState() => _MyExpandableTextState();
}

class _MyExpandableTextState extends State<MyExpandableText> {
  int? maxLines = 4;
  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    print("Expanded: $isExpanded");
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: GestureDetector(
        onTap: () {
          setState(() {
            isExpanded = !isExpanded;
          });
        },
        child: Text(
          widget.text,
          maxLines: isExpanded ? null : maxLines,
          overflow: isExpanded ? null : TextOverflow.ellipsis,
        ),
      ),
    );
  }
}

class MyPostHeader extends StatelessWidget {
  const MyPostHeader(
      {super.key,
      required this.user,
      this.tagOnly,
      this.radius,
      this.fontSize});

  final User user;
  final bool? tagOnly;
  final double? radius;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    final String fullName = '${user.firstName} ${user.lastName}';
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //? PROFILE PICTURE
            MyProfilePicture(
              user: user,
              radius: radius ?? 24,
            ),

            const SizedBox(
              width: 5,
            ),

            MyListTile(
              children: [
                //? FULL NAME
                tagOnly == true
                    ? const SizedBox()
                    : RenderUserName(user: user, fontWeight: FontWeight.bold),

                //? HANDLE
                Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                    user.handle ?? '',
                    textAlign: TextAlign.left,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColor.textColor.withOpacity(0.7),
                        fontSize: fontSize ?? 16),
                  ),
                ),
              ],
            ),

          ],
        ),

        //? MORE
        IconButton(
            splashRadius: 30,
            onPressed: () {
              print("More Icon for $fullName pressed");
            },
            icon: const Icon(Icons.more_vert_outlined))
      ],
    );
  }
}

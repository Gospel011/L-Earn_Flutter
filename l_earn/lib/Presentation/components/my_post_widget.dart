import 'package:flutter/material.dart';
import 'package:l_earn/DataLayer/Models/post_model.dart';
import 'package:l_earn/Presentation/components/my_like_comment_share_widget.dart';
import 'package:l_earn/Presentation/components/my_list_tile.dart';
import 'package:l_earn/Presentation/components/my_profile_picture.dart';
import 'package:l_earn/Presentation/components/render_user_name.dart';
import 'package:l_earn/utils/colors.dart';

class MyPostWidget extends StatelessWidget {
  const MyPostWidget({
    super.key,
    required this.post,
  });

  final Post post;

  @override
  Widget build(BuildContext context) {
    final String fullName = '${post.user.firstName} ${post.user.lastName}';
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //? ROW WITH PROFILE PICTURE, NAME, HANDLE AND MORE ICON
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  //? PROFILE PICTURE
                  MyProfilePicture(
                    user: post.user,
                    radius: 24,
                  ),

                  const SizedBox(
                    width: 5,
                  ),

                  MyListTile(
                    children: [
                      //? FULL NAME
                      RenderUserName(
                          user: post.user, fontWeight: FontWeight.bold),

                      //? HANDLE
                      Text(
                        post.user.handle ?? '',
                        textAlign: TextAlign.left,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColor.textColor.withOpacity(0.7)),
                      )
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
          ),

          //? TEXT
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: Text(post.text),
          ),

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
          MyLikeCommentShareWidget(post: post)
        ],
      ),
    );
  }
}

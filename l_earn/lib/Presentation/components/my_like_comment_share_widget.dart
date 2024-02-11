import 'package:flutter/material.dart';
import 'package:l_earn/DataLayer/Models/post_model.dart';
import 'package:l_earn/Presentation/Pages/Home_Pages/home.dart';
import 'package:l_earn/Presentation/components/my_list_tile_widget.dart';
import 'package:l_earn/utils/constants.dart';

class MyLikeCommentShareWidget extends StatelessWidget {
  const MyLikeCommentShareWidget({
    super.key,
    required this.post,
  });

  final Post post;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      //? LIKE
      MyListTileWidget(
          title: AppIcons.likeCompact,
          subtitle: Text('${post.likes}'),
          onPressed: () {
            //TODO: IMPLEMENT LIKING FUNCTIONALITY
            print('like pressed');
          }),

      const SizedBox(width: 10),

      //? COMMENT
      MyListTileWidget(
          title: AppIcons.comment,
          subtitle: Text('${post.comment.length}'),
          onPressed: () {
            //TODO: IMPLEMENT LIKING FUNCTIONALITY
            print('like pressed');
          }),

      const SizedBox(width: 10),

      //? SHARE
      MyListTileWidget(
          title: AppIcons.share,
          subtitle: Text('${post.shares}'),
          onPressed: () {
            //TODO: IMPLEMENT LIKING FUNCTIONALITY
            print('SHARE pressed');
          }),
    ]);
  }
}
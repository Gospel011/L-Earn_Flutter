import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:l_earn/BusinessLogic/PostCubit/post_cubit.dart';
import 'package:l_earn/BusinessLogic/commentCubit/comment_cubit.dart';
import 'package:l_earn/Presentation/components/build_comments_widget.dart';
import 'package:l_earn/utils/mixins.dart';

class ExpandedPostPage extends StatelessWidget with AppBarMixin {
  const ExpandedPostPage({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: Builder(builder: (context) {
        var postState = context.watch<PostCubit>().state;
        var commentState = context.watch<CommentCubit>().state;

        print("expanded post state is $postState");
        print("expanded comment state is $commentState");

        print("\n" * 10);
        return Column(
          children: [
            //? Post
            Text("Post")

            //? Comments
            // BuildComments(comments: commentState.comments, post: postState.post!)
          ],
        );
      }),
    );
  }
}

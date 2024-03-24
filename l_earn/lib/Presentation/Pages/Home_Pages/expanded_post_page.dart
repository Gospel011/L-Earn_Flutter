import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:l_earn/BusinessLogic/AuthCubit/auth/auth_cubit.dart';
import 'package:l_earn/BusinessLogic/PostCubit/post_cubit.dart';
import 'package:l_earn/BusinessLogic/commentCubit/comment_cubit.dart';
import 'package:l_earn/DataLayer/Models/user_model.dart';
import 'package:l_earn/Presentation/components/build_comments_widget.dart';
import 'package:l_earn/Presentation/components/my_circular_progress_indicator.dart';
import 'package:l_earn/Presentation/components/my_comment_item.dart';
import 'package:l_earn/Presentation/components/my_post_widget.dart';
import 'package:l_earn/utils/mixins.dart';

class ExpandedPostPage extends StatefulWidget with AppBarMixin {
  const ExpandedPostPage({super.key, required this.id});

  final String id;

  @override
  State<ExpandedPostPage> createState() => _ExpandedPostPageState();
}

class _ExpandedPostPageState extends State<ExpandedPostPage> {
  void getComments(BuildContext context) {
    User? user = context.read<AuthCubit>().state.user;

    context
        .read<CommentCubit>()
        .getNewComments(widget.id, user?.token, user?.id);
  }

  void getPost(BuildContext context) {
    User? user = context.read<AuthCubit>().state.user;

    context
        .read<PostCubit>()
        .getPost(userId: user!.id!, token: user.token!, postId: widget.id);
  }

  @override
  void initState() {
    super.initState();

    getPost(context);
    getComments(context);
  }

  final BoxDecoration containerDecoration = BoxDecoration(
      color: Colors.grey.shade300, borderRadius: BorderRadius.circular(8));


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.buildAppBar(context),
      body: Builder(builder: (context) {
        var postState = context.watch<PostCubit>().state;
        var commentState = context.watch<CommentCubit>().state;

        print("expanded post state is $postState");
        print("expanded comment state is $commentState");

        print("\n" * 10);
        return CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(child: SizedBox(height: 16)),
            //? Post
            // true
            postState is GettingPost
                ? SliverToBoxAdapter(
                    child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: const PostPlaceholderWidget().animate(onComplete: (controller) => controller.repeat()).shimmer(duration: const Duration(seconds: 2)),
                  ))
                : SliverToBoxAdapter(
                    child: MyPostWidget(
                        post: postState.post!, showComments: false, index: 0)),

            //? Comments
            // commentState is CommentsLoading && postState is! GettingPost ? MyCircularProgressIndicator : BuildComments(comments: commentState.comments, post: postState.post!)

            SliverToBoxAdapter(
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 8.0, bottom: 8, left: 16, right: 16),
                    child: Text(
                      "Comments",
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  )
                ],
              ),
            ),

            commentState is CommentsLoading && postState is GettingPost
                ? const SliverToBoxAdapter(child: MyCircularProgressIndicator())
                : SliverList.builder(
                    itemCount: commentState.comments.length,
                    itemBuilder: (BuildContext context, int index) {
                      return MyCommentItem(
                        comment: commentState.comments[index],
                        parentResourceId: widget.id,
                        index: index,
                      );
                    },
                  ),
          ],
        );
      }),
    );
  }
}

class PostPlaceholderWidget extends StatelessWidget {
  const PostPlaceholderWidget({
    super.key,
    
  });

  Random get random => Random();

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      //? header
      const PlaceHolderPostHeader(),
    
      const SizedBox(height: 4,),
    
      //? post
    
      Wrap(
        spacing: 4,
        runSpacing: 8,
        children: [
        ...List.generate(random.nextInt(10) + 10, (index) => PlaceHolderContainer(width: (random.nextDouble() + 1) * 70))
      ],),
    
      //? like comment share
    
      const SizedBox(height: 10,),
    
      const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          children: [
            PlaceHolderContainer(width: 24, height: 24,),
        
            SizedBox(width: 10,),
        
            PlaceHolderContainer(width: 24, height: 24,),
        
            SizedBox(width: 10,),
        
            PlaceHolderContainer(width: 24, height: 24,),
          ],
        ),
      )
    ]);
  }
}

class PlaceHolderPostHeader extends StatelessWidget {
  const PlaceHolderPostHeader({
    super.key,
  });

  

  @override
  Widget build(BuildContext context) {
    return const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //? profile picture
            PlaceHolderContainer(
              width: 24 * 2,
              height: 24 * 2,
              borderRadiusAll: 24,
            ),
    
            SizedBox(
              width: 10,
            ),
    
            //? name and handle
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                PlaceHolderContainer(
                  width: 180,
                ),
    
                SizedBox(
                  height: 4,
                ),
    
                PlaceHolderContainer(
                  width: 180,
                ),
              ],
            )
          ],
        ),
        
        
        const PlaceHolderContainer(width: 20, height: 48,)
      ],
    );
  }
}

class PlaceHolderContainer extends StatelessWidget {
  const PlaceHolderContainer(
      {super.key,
      required this.width,
      this.height,
      this.borderRadius,
      this.borderRadiusAll,
      this.color});

  final double width;
  final double? height;
  final double? borderRadiusAll;
  final BorderRadius? borderRadius;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: width,
        height: height ?? 18,
        decoration: BoxDecoration(
          color: color ?? Colors.grey.shade300,
          borderRadius: borderRadius ?? BorderRadius.circular(borderRadiusAll ?? 8),
        ));
  }
}

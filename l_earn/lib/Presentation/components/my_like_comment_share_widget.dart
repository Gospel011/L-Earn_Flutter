import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:l_earn/BusinessLogic/AuthCubit/auth/auth_cubit.dart';
import 'package:l_earn/BusinessLogic/PostCubit/post_cubit.dart';
import 'package:l_earn/BusinessLogic/commentCubit/comment_cubit.dart';
import 'package:l_earn/BusinessLogic/contentCubit/content_cubit.dart';
import 'package:l_earn/BusinessLogic/likeCubit/like_cubit.dart';
import 'package:l_earn/DataLayer/Models/comment_model.dart';

import 'package:l_earn/DataLayer/Models/post_model.dart';
import 'package:l_earn/DataLayer/Models/user_model.dart';
import 'package:l_earn/Presentation/components/build_comments_widget.dart';
import 'package:l_earn/Presentation/components/my_circular_progress_indicator.dart';

import 'package:l_earn/Presentation/components/my_list_tile_widget.dart';

import 'package:l_earn/Presentation/components/my_profile_picture.dart';
import 'package:l_earn/Presentation/components/my_textformfield.dart';
import 'package:l_earn/utils/colors.dart';
import 'package:l_earn/utils/constants.dart';
import 'package:l_earn/utils/mixins.dart';
import 'package:share_plus/share_plus.dart';

class MyLikeCommentShareWidget extends StatefulWidget {
  const MyLikeCommentShareWidget(
      {super.key,
      required this.post,
      required this.index,
      this.showComments = true});

  final Post post;
  final int index;
  final bool showComments;

  @override
  State<MyLikeCommentShareWidget> createState() =>
      _MyLikeCommentShareWidgetState();
}

class _MyLikeCommentShareWidgetState extends State<MyLikeCommentShareWidget>
    with AppBarMixin {
  final TextEditingController _commentController = TextEditingController();

  final GlobalKey<FormState> _commentFormKey = GlobalKey<FormState>();
  final FocusNode _commentFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) =>
                LikeCubit(widget.post.likes, widget.post.liked)),
      ],
      child: BlocListener<LikeCubit, LikeState>(
        listener: (contex, state) {
          Post targetPost =
              context.read<PostCubit>().state.newPosts[state.index];

          context.read<PostCubit>().state.newPosts[state.index] =
              targetPost.copyWith(likes: state.likes, liked: state.liked);

          print('Changed');
        },
        child: Row(children: [
          //? LIKE
          BlocBuilder<LikeCubit, LikeState>(builder: (context, state) {
            return MyListTileWidget(
                title: state.liked
                    ? SizedBox(height: 18, child: AppIcons.liked)
                    : SizedBox(height: 18, child: AppIcons.likeCompact),
                subtitle: Text('${state.likes}',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(height: 1)),
                onPressed: () {
                  context.read<LikeCubit>().like(
                      context.read<AuthCubit>().state.user?.token,
                      widget.post.id,
                      'posts',
                      widget.index);
                  print('like pressed');
                });
          }),

          const SizedBox(width: 10),

          //? COMMENT
          widget.showComments == false
              ? const SizedBox()
              : Builder(builder: (BuildContext context) {
                  return MyListTileWidget(
                      title: SizedBox(height: 18, child: AppIcons.comment),
                      subtitle: Text('${widget.post.comments}',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(height: 1)),
                      onPressed: () {
                        //? BOTTOM MODAL FOR COMMENTS

                        //* SHOW BOTTOM MODAL
                        showModalBottomSheet(
                            context: context,
                            backgroundColor: Colors.transparent,
                            builder: (context) {
                              return BlocProvider<CommentCubit>(
                                create: (context) => CommentCubit(),
                                child: Builder(builder: (context) {
                                  //* REQUEST COMMENTS

                                  getComments(context);

                                  return ClipRRect(
                                    borderRadius:
                                        const BorderRadiusDirectional.only(
                                            topStart: Radius.circular(16),
                                            topEnd: Radius.circular(16)),
                                    child: Scaffold(
                                      resizeToAvoidBottomInset: true,
                                      appBar: buildAppBar(context,
                                          title:
                                              "Comments for ${widget.post.user.firstName}'s post",
                                          titleTextStyle: Theme.of(context)
                                              .textTheme
                                              .bodyMedium),
                                      body: BlocBuilder<CommentCubit,
                                              CommentState>(
                                          builder: (context, state) {
                                        print("Current state is $state");
                                        return state is CommentsLoading
                                            ? const Center(
                                                child:
                                                    MyCircularProgressIndicator())
                                            : BuildComments(
                                                comments: state.comments,
                                                post: widget.post,
                                              );
                                      }),
                                    ),
                                  );
                                }),
                              );
                            });
                      });
                }),

          IconButton(
              onPressed: () {
                print('share');
                Share.share("${Uri.parse("${NetWorkConstants.baseShareUrl}/posts/${widget.post.id}?author=${widget.post.user.firstName} ${widget.post.user.lastName}")}");
              },
              icon: AppIcons.share)
        ]),
      ),
    );
  }

  void getComments(BuildContext context) {
    context.read<CommentCubit>().getNewComments(
        widget.post.id,
        context.read<AuthCubit>().state.user?.token,
        context.read<AuthCubit>().state.user?.id);
  }

  //* METHODS

  Row buildHeaderText(BuildContext context) {
    return Row(
      children: [
        Text(
          "Comments for ${widget.post.user.firstName}'s post",
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  void suffixOnPressed() {}
}

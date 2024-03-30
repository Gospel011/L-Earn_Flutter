import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:l_earn/BusinessLogic/AuthCubit/auth/auth_cubit.dart';
import 'package:l_earn/BusinessLogic/PostCubit/post_cubit.dart';
import 'package:l_earn/BusinessLogic/commentCubit/comment_cubit.dart';
import 'package:l_earn/BusinessLogic/likeCubit/like_cubit.dart';
import 'package:l_earn/DataLayer/Models/comment_model.dart';

import 'package:l_earn/DataLayer/Models/post_model.dart';
import 'package:l_earn/DataLayer/Models/user_model.dart';
import 'package:l_earn/Presentation/components/comment_text_field.dart';
import 'package:l_earn/Presentation/components/my_comment_item.dart';

import 'package:l_earn/Presentation/components/my_list_tile_widget.dart';
import 'package:l_earn/Presentation/components/my_post_widget.dart';
import 'package:l_earn/Presentation/components/my_profile_picture.dart';
import 'package:l_earn/Presentation/components/my_textformfield.dart';
import 'package:l_earn/utils/colors.dart';
import 'package:l_earn/utils/constants.dart';
import 'package:l_earn/utils/mixins.dart';
import 'package:share_plus/share_plus.dart';

class MyLikeCommentShareWidget extends StatefulWidget {
  const MyLikeCommentShareWidget(
      {super.key, required this.post, required this.index, this.showComments});

  final Post post;
  final bool? showComments;
  final int index;

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
                                  context.read<CommentCubit>().getNewComments(
                                      widget.post.id,
                                      context
                                          .read<AuthCubit>()
                                          .state
                                          .user
                                          ?.token,
                                      context.read<AuthCubit>().state.user?.id);
                                  return BlocListener<CommentCubit,
                                      CommentState>(
                                    listener: (context, state) {
                                      if (state is CommentPosted) {
                                        _commentController.text = '';
                                        _commentFocusNode.unfocus();
                                      }
                                    },
                                    child: ClipRRect(
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
                                          return Stack(children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 48.0),
                                              child: CustomScrollView(
                                                slivers: [
                                                  //* SPACING FROM TOP
                                                  const SliverPadding(
                                                      padding: EdgeInsets.only(
                                                          top: 8)),

                                                  //? SCROLLABLE LIST OF COMMENTS
                                                  SliverList.builder(
                                                    itemCount:
                                                        state.comments.length,
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int index) {
                                                      return MyCommentItem(
                                                        comment: state
                                                            .comments[index],
                                                        parentResourceId:
                                                            widget.post.id,
                                                        index: index,
                                                      );
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),

                                            //* WRITE COMMENT TEXTFIELD
                                            Form(
                                              key: _commentFormKey,
                                              child: Align(
                                                alignment:
                                                    Alignment.bottomCenter,
                                                child: Container(
                                                  color: Colors.white,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: CommentTextField(post: widget.post),
                                                  ),
                                                ),
                                              ),
                                            )
                                          ]);
                                        }),
                                      ),
                                    ),
                                  );
                                }),
                              );
                            });
                      });
                }),

          // const SizedBox(width: 10),
          IconButton(onPressed: (){
            Share.share("${Uri.parse("${NetWorkConstants.baseShareUrl}/posts/${widget.post.id}?author=${widget.post.user.firstName} ${widget.post.user.lastName}")}");
          }, icon: AppIcons.share)
        ]),
      ),
    );
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

  // String? commentValidator(value) {
  //   if (value?.trim().isEmpty == true) {
  //     return 'Your comment cannot be empty';
  //   }
  //   return null;
  // }
}



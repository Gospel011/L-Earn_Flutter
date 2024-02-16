import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:l_earn/BusinessLogic/AuthCubit/auth/auth_cubit.dart';
import 'package:l_earn/BusinessLogic/PostCubit/post_cubit.dart';
import 'package:l_earn/BusinessLogic/commentCubit/comment_cubit.dart';
import 'package:l_earn/BusinessLogic/likeCubit/like_cubit.dart';
import 'package:l_earn/DataLayer/Models/comment_model.dart';

import 'package:l_earn/DataLayer/Models/post_model.dart';
import 'package:l_earn/DataLayer/Models/user_model.dart';

import 'package:l_earn/Presentation/components/my_list_tile_widget.dart';
import 'package:l_earn/Presentation/components/my_post_widget.dart';
import 'package:l_earn/Presentation/components/my_profile_picture.dart';
import 'package:l_earn/Presentation/components/my_textformfield.dart';
import 'package:l_earn/utils/colors.dart';
import 'package:l_earn/utils/constants.dart';
import 'package:l_earn/utils/mixins.dart';

class MyLikeCommentShareWidget extends StatefulWidget {
  const MyLikeCommentShareWidget(
      {super.key, required this.post, required this.index});

  final Post post;
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
          Builder(builder: (BuildContext context) {
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
                                context.read<AuthCubit>().state.user?.token,
                                context.read<AuthCubit>().state.user?.id);
                            return BlocListener<CommentCubit, CommentState>(
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
                                  body: BlocBuilder<CommentCubit, CommentState>(
                                      builder: (context, state) {
                                    return Stack(children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 48.0),
                                        child: CustomScrollView(
                                          slivers: [
                                            //* SPACING FROM TOP
                                            const SliverPadding(
                                                padding:
                                                    EdgeInsets.only(top: 8)),

                                            //? SCROLLABLE LIST OF COMMENTS
                                            SliverList.builder(
                                              itemCount: state.comments.length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return MyCommentItem(
                                                  comment:
                                                      state.comments[index],
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
                                          alignment: Alignment.bottomCenter,
                                          child: Container(
                                            color: Colors.white,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: BlocBuilder<CommentCubit,
                                                      CommentState>(
                                                  builder: (context, state) {
                                                return MyTextFormField(
                                                    controller:
                                                        _commentController,
                                                    focusNode:
                                                        _commentFocusNode,
                                                    hintText: 'Write a comment',
                                                    maxLines: 5,
                                                    minLines: 1,
                                                    suffixIcon:
                                                        state is CommentPosting
                                                            ? const SizedBox(
                                                                width: 24,
                                                                height: 24,
                                                                child:
                                                                    CircularProgressIndicator(
                                                                  color: Colors
                                                                      .blueGrey,
                                                                ),
                                                              )
                                                            : const Icon(
                                                                Icons.send),
                                                    suffixOnpressed: () {
                                                      print(
                                                          "S E N D   P R E S S E D");

                                                      final bool? canComment =
                                                          _commentFormKey
                                                              .currentState
                                                              ?.validate();

                                                      if (canComment == true) {
                                                        final User user =
                                                            context
                                                                .read<
                                                                    AuthCubit>()
                                                                .state
                                                                .user!;
                                                        context
                                                            .read<
                                                                CommentCubit>()
                                                            .postComment(
                                                                userId:
                                                                    user.id!,
                                                                token:
                                                                    user.token!,
                                                                endpoint:
                                                                    'posts/${widget.post.id}/comments?type=post',
                                                                comment:
                                                                    _commentController
                                                                        .text
                                                                        .trim());
                                                      }
                                                    },
                                                    validator:
                                                        commentValidator);
                                              }),
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

          const SizedBox(width: 10),
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

  String? commentValidator(value) {
    if (value?.trim().isEmpty == true) {
      return 'Your comment cannot be empty';
    }
    return null;
  }
}

class MyCommentItem extends StatelessWidget {
  const MyCommentItem(
      {super.key,
      required this.comment,
      required this.parentResourceId,
      required this.index});

  final Comment comment;
  final int index;
  final String parentResourceId;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //* profile picture
          MyProfilePicture(
            user: comment.user,
            radius: 12,
          ),

          //** COLUMN OF TAG AND POST
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                //? tag
                Row(
                  children: [
                    Text(
                      comment.user.handle!,
                      softWrap: true,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 14,
                          color: AppColor.textColor.withOpacity(0.8)),
                    ),
                    SizedBox(height: 14, child: comment.user.isVerified == true ? AppIcons.verifiedIcon : const SizedBox())
                  ],
                ),

                const SizedBox(
                  height: 2,
                ),

                //? comment
                Text(comment.comment,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontSize: 16, fontWeight: FontWeight.w500)),

                //? likes
                BlocProvider<LikeCubit>(
                  create: (context) => LikeCubit(comment.likes, comment.liked),
                  child: BlocBuilder<LikeCubit, LikeState>(
                      builder: (context, state) {
                    return MyListTileWidget(
                        title: state.liked == true
                            ? SizedBox(
                                height: 16,
                                child: AppIcons.likeSolidCompact,
                              )
                            : SizedBox(
                                height: 16,
                                child: AppIcons.likeCompact,
                              ),
                        subtitle: Text(
                          '${state.likes}',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(height: 0.8),
                        ),
                        onPressed: () {
                          print("Like pressed");

                          context.read<LikeCubit>().like(
                              context.read<AuthCubit>().state.user?.token,
                              comment.id,
                              "posts/$parentResourceId/comments/",
                              index);
                        });
                  }),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

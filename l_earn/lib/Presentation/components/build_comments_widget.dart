import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:l_earn/BusinessLogic/AuthCubit/auth/auth_cubit.dart';
import 'package:l_earn/BusinessLogic/commentCubit/comment_cubit.dart';
import 'package:l_earn/DataLayer/Models/comment_model.dart';
import 'package:l_earn/DataLayer/Models/post_model.dart';
import 'package:l_earn/DataLayer/Models/user_model.dart';
import 'package:l_earn/Presentation/components/my_comment_item.dart';
import 'package:l_earn/Presentation/components/my_textformfield.dart';

class BuildComments extends StatelessWidget {
  const BuildComments(
      {super.key,
      required this.comments,
      required this.post,
      });

  final List<Comment> comments;
  final Post post;


  TextEditingController get commentController => TextEditingController();
  GlobalKey<FormState> get commentFormKey => GlobalKey<FormState>();
  FocusNode get commentFocusNode => FocusNode();

  String? commentValidator(value) {
    if (value?.trim().isEmpty == true) {
      return 'Your comment cannot be empty';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CommentCubit, CommentState>(
      listener: (context, state) {
        if (state is CommentPosted) {
          commentController.text = '';
          commentFocusNode.unfocus();
        }
      },
      child: Stack(children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 48.0),
          child: CustomScrollView(
            slivers: [
              //* SPACING FROM TOP
              const SliverPadding(padding: EdgeInsets.only(top: 8)),

              //? SCROLLABLE LIST OF COMMENTS
              SliverList.builder(
                itemCount: comments.length,
                itemBuilder: (BuildContext context, int index) {
                  return MyCommentItem(
                    comment: comments[index],
                    parentResourceId: post.id,
                    index: index,
                  );
                },
              ),
            ],
          ),
        ),

        //* WRITE COMMENT TEXTFIELD
        Form(
          key: commentFormKey,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: BlocBuilder<CommentCubit, CommentState>(
                    builder: (context, state) {
                  return MyTextFormField(
                      controller: commentController,
                      focusNode: commentFocusNode,
                      hintText: 'Write a comment',
                      maxLines: 5,
                      minLines: 1,
                      suffixIcon: state is CommentPosting
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Colors.blueGrey,
                              ),
                            )
                          : const Icon(Icons.send),
                      suffixOnpressed: () {
                        print("S E N D   P R E S S E D");

                        final bool? canComment =
                            commentFormKey.currentState?.validate();

                        if (canComment == true) {
                          final User user =
                              context.read<AuthCubit>().state.user!;
                          context.read<CommentCubit>().postComment(
                              userId: user.id!,
                              token: user.token!,
                              endpoint: 'posts/${post.id}/comments?type=post',
                              comment: commentController.text.trim());
                        }
                      },
                      validator: commentValidator);
                }),
              ),
            ),
          ),
        )
      ]),
    );
  }
}
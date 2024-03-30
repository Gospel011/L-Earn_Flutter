import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:l_earn/BusinessLogic/AuthCubit/auth/auth_cubit.dart';
import 'package:l_earn/BusinessLogic/commentCubit/comment_cubit.dart';
import 'package:l_earn/DataLayer/Models/post_model.dart';
import 'package:l_earn/DataLayer/Models/user_model.dart';
import 'package:l_earn/Presentation/components/my_textformfield.dart';

class CommentTextField extends StatefulWidget {
  const CommentTextField({super.key, required this.post});
  final Post post;

  static final TextEditingController _commentController =
      TextEditingController();
  static final FocusNode _commentFocusNode = FocusNode();
  static final GlobalKey<FormState> _commentFormKey = GlobalKey<FormState>();

  @override
  State<CommentTextField> createState() => _CommentTextFieldState();
}

class _CommentTextFieldState extends State<CommentTextField> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommentCubit, CommentState>(builder: (context, state) {
      return Form(
        key: CommentTextField._commentFormKey,
        child: MyTextFormField(
            controller: CommentTextField._commentController,
            focusNode: CommentTextField._commentFocusNode,
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
                  CommentTextField._commentFormKey.currentState?.validate();

              print("Can comment: $canComment");

              if (canComment == true) {
                final User user = context.read<AuthCubit>().state.user!;
                context.read<CommentCubit>().postComment(
                    userId: user.id!,
                    token: user.token!,
                    endpoint: 'posts/${widget.post.id}/comments?type=post',
                    comment: CommentTextField._commentController.text.trim());
                CommentTextField._commentController.text = "";
                setState(() {});
                CommentTextField._commentFocusNode.unfocus();
              }
            },
            validator: commentValidator),
      );
    });
  }

  String? commentValidator(value) {
    if (value?.trim().isEmpty == true) {
      return 'Your comment cannot be empty';
    }
    return null;
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:l_earn/DataLayer/Models/content_model.dart';
import 'package:l_earn/Presentation/Pages/Home_Pages/Content_Pages/my_quill_editor.dart';
import 'package:l_earn/BusinessLogic/AuthCubit/auth/auth_cubit.dart';
import 'package:l_earn/BusinessLogic/ContentCubit/content_cubit.dart';
// import 'package:l_earn/BusinessLogic/Models/content_model.dart';
// C:\Users\user\FLUTTER_PROJECTS\L-EARN\L-Earn_Flutter\l_earn\lib\BusinessLogic\contentCubit\content_cubit.dart

import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:l_earn/utils/mixins.dart';
import 'package:l_earn/Presentation/components/my_container_button.dart';
import 'package:l_earn/Presentation/components/my_dialog.dart';

class WriteABookPage extends StatelessWidget with AppBarMixin {
  const WriteABookPage({super.key, this.content, this.chapterId});

  static final _contentController = QuillController.basic();
  static final _titleController = TextEditingController();
  final Content? content;
  final String? chapterId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ContentCubit>(
      create: (context) => ContentCubit(),
      child: BlocListener<ContentCubit, ContentState>(
          listener: (context, state) async {
            if (state is ChapterCreationFailed) {
              showDialog(
                  context: context,
                  builder: (context) {
                    return MyDialog(
                        title: state.error!.title,
                        content: state.error!.content);
                  });
            } else if (state is ChapterCreated) {
              await showDialog(
                  context: context,
                  builder: (context) {
                    return MyDialog(
                        title: "Successful",
                        content:
                            "A new chapter has been added to \"${content?.title}\"");
                  });

              if (context.mounted) {
                Navigator.pushReplacementNamed(context, '/profile-page',
                    arguments: context.read<AuthCubit>().state.user);
              }

              _titleController.text = '';
              _contentController.document = Document.fromJson([
                {"insert": "\n"}
              ]);
            }
          },
          child: Scaffold(
              resizeToAvoidBottomInset: true,
              appBar: buildAppBar(context, actions: [
                Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Builder(builder: (context) {
                      return BlocBuilder<ContentCubit, ContentState>(
                          builder: (context, state) {
                        print(state);
                        return MyContainerButton(
                            text: 'Add',
                            loading: state is CreatingChapter,
                            onPressed: () {
                              //TODO: IMPLEMENT POSTING FUNCTIONALITY FOR CONTENT
                              if (state is CreatingChapter) return;

                              print("post pressed");

                              print(
                                  ":::::::::::::::::: P R I N T I N G   U S E R   C O N T E N T :::::::::::::::::::::::::");

                              Map<String, String> body = {
                                "title": _titleController.text,
                              };

                              var encodedBody = jsonEncode(_contentController
                                  .document
                                  .toDelta()
                                  .toJson());
                              body['content'] = encodedBody;

                              context.read<ContentCubit>().createChapter(
                                  token: context
                                      .read<AuthCubit>()
                                      .state
                                      .user
                                      ?.token,
                                  contentId: content!.id,
                                  details: body);
                            });
                      });
                    }))
              ]),
              body: MyQuillEditor(
                  controller: _contentController,
                  textEditingController: _titleController,
                  user: context.read<AuthCubit>().state.user,
                  readOnly: false,
                  fresh: true))),
    );
  }
}

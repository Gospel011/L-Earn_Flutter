import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:l_earn/DataLayer/Models/drafts/drafts_model.dart';
import 'package:l_earn/Presentation/Pages/Home_Pages/Content_Pages/my_quill_editor.dart';
import 'package:l_earn/BusinessLogic/AuthCubit/auth/auth_cubit.dart';
import 'package:l_earn/BusinessLogic/ContentCubit/content_cubit.dart';
import 'package:l_earn/DataLayer/Models/content_model.dart';
// C:\Users\user\FLUTTER_PROJECTS\L-EARN\L-Earn_Flutter\l_earn\lib\BusinessLogic\contentCubit\content_cubit.dart

import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:l_earn/utils/constants.dart';
import 'package:l_earn/utils/mixins.dart';
import 'package:l_earn/Presentation/components/my_container_button.dart';
import 'package:l_earn/Presentation/components/my_dialog.dart';

import 'package:l_earn/providers/drafts_provider.dart';

class WriteABookPage extends StatefulWidget with AppBarMixin {
  const WriteABookPage({super.key, this.chapterContent, this.content, this.title, this.chapterId, this.bookName, this.chapter});

  /// The parent book of this chapter
  final Content? content;

  /// The content of this chapter
  final List<dynamic>? chapterContent;

  /// The title of this chapter
  final String? title;

  /// The unique id for this chapter. If this has been saved to drafts, this
  /// would be this chapter's id in the drafts.
  final String? chapterId;

  /// This is the title of the parent book
  final String? bookName;

  /// The current chapter being written
  final int? chapter;

  @override
  State<WriteABookPage> createState() => _WriteABookPageState();
}

class _WriteABookPageState extends State<WriteABookPage> {
  final _contentController = QuillController.basic();

  final _titleController = TextEditingController();

  Map<String, String> get body => convertToBody();

  static final id = AppConstants.uuid.v4();

  void saveToDrafts() {
    // Return if title and content is empty
    final savedDrafts = context.read<DraftsProvider>().drafts;
    if (_titleController.text.trim() == '' &&
        _contentController.document.toDelta().toJson().toString().length ==
            13) {
    //   print(
    //       "T I M E IS  ${DateTime.now()} content is ${widget.content!.title}");
    //   print("Title and content is empty so no drafts saved");
    // print("S A V E D   D R A F T S (${savedDrafts.length})   $savedDrafts");
      return;
    }

    final Drafts draft = Drafts(
        id: widget.chapterId ?? id,
        bookName: widget.bookName ?? widget.content!.title,
        chapter: widget.chapter ?? widget.content!.articles + 1,
        title: _titleController.text == '' ? 'untitled' : _titleController.text,
        content: _contentController.document.toDelta().toJson(),
        dateLastUpdated: DateTime.now());


    // TODO: save to draft provider
    context.read<DraftsProvider>().put(draft);

    // final savedDrafts = context.read<DraftsProvider>().drafts;

    print("S A V E D   D R A F T S (${savedDrafts.length})   $savedDrafts");

    print("Draft is $draft");
  }

  late final Timer timer;
  @override
  void initState() {
    super.initState();
    

    if (widget.title != null && widget.title != 'untitled') _titleController.text = widget.title!;
    if (widget.content != null) {
      _contentController.document =
              Document.fromJson(widget.chapterContent!);
    }
    timer = Timer.periodic(const Duration(seconds: 1), (time) {
      // print("Timer is $time");
      saveToDrafts();
    });
  }

  @override
  void dispose() {
    timer.cancel();
    print("C A N C E L E D timer");
    super.dispose();
  }

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
              // TODO: Delete chapter from drafts
              await showDialog(
                  context: context,
                  builder: (context) {
                    return MyDialog(
                        title: "Successful",
                        content:
                            "A new chapter has been added to \"${widget.content?.title}\"");
                  });

              if (context.mounted) {
                context.goNamed(AppRoutes.profile, queryParameters: {
                  "user": context.read<AuthCubit>().state.user!.id!
                });
                // context.goNamed(AppRoutes.profile,
                //     extra: context.read<AuthCubit>().state.user);
                //! avigator.pushReplacementNamed(context, '/profile-page',
                //     arguments: context.read<AuthCubit>().state.user);
              }

              _titleController.text = '';
              _contentController.document = Document.fromJson([
                {"insert": "\n"}
              ]);
            }
          },
          child: Scaffold(
              resizeToAvoidBottomInset: true,
              appBar: widget.buildAppBar(context,
                  automaticallyImplyLeading: Platform.isWindows,
                  actions: [
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
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

                                  context.read<ContentCubit>().createChapter(
                                      token: context
                                          .read<AuthCubit>()
                                          .state
                                          .user
                                          ?.token,
                                      contentId: widget.content!.id,
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

  Map<String, String> convertToBody() {
    Map<String, String> body = {
      "title": _titleController.text,
    };

    var encodedBody =
        jsonEncode(_contentController.document.toDelta().toJson());
    body['content'] = encodedBody;
    return body;
  }
}

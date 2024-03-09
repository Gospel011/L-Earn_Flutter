import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:l_earn/BusinessLogic/contentCubit/content_cubit.dart';

import 'package:l_earn/Presentation/Pages/Home_Pages/Content_Pages/content_description_page.dart';
import 'package:l_earn/Presentation/Pages/Home_Pages/Content_Pages/my_quill_editor.dart';

import 'package:l_earn/Presentation/components/my_outline_button.dart';

import '../../../../utils/mixins.dart';

class ChapterPage extends StatefulWidget with AppBarMixin {
  const ChapterPage({super.key});

  @override
  State<ChapterPage> createState() => _ChapterPageState();
}

class _ChapterPageState extends State<ChapterPage> {
  final TextEditingController textEditingController = TextEditingController();
  final QuillController quillController = QuillController.basic();

  @override
  void dispose() {
    quillController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: Drawer(
        child: SingleChildScrollView(
            child: Column(
          children: [
            DrawerHeader(
                child: Center(
                    child: Text(
              "Chapters",
              style: Theme.of(context).textTheme.bodyLarge,
            ))),
            Builder(builder: (context) {
              return ChaptersColumn(
                chapters:
                    context.read<ContentCubit>().state.content!.bookChapters ??
                        [],
                contentId: context.read<ContentCubit>().state.content?.id ?? '',
                type: context.read<ContentCubit>().state.content?.type ?? '',
                preRequestAction: () {
                  Scaffold.of(context).closeEndDrawer();
                },
              );
            }),
          ],
        )),
      ),
      appBar: widget.buildAppBar(context, actions: [
        BlocBuilder<ContentCubit, ContentState>(builder: (context, state) {
          return state.article != null
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: MyOutlineButton(
                      onPressed: () {
                        Scaffold.of(context).openEndDrawer();
                      },
                      text:
                          'Chapter ${state is RequestingChapterById ? '_' : state.article!.chapter}'),
                )
              : const SizedBox();
        }),
        const SizedBox(
          width: 16,
        )
      ]),
      
      body: BlocBuilder<ContentCubit, ContentState>(builder: (context, state) {
        if (state is RequestingChapterById) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.blueGrey,
            ),
          );
        } else if (state is ChapterFound) {
          List<dynamic>? parsedContent;

          parsedContent = jsonDecode(state.article?.content! ?? '[]');
          List<Map<String, dynamic>> deltaList =
              List<Map<String, dynamic>>.from(parsedContent!);
          print('Decoded Delta: $deltaList');

          quillController.document =
              Document.fromJson(jsonDecode(state.article?.content ?? '[]'));
          textEditingController.text =
              'Chapter ${state.article?.chapter}: ${state.article?.title}';
          return MyQuillEditor(
              controller: quillController,
              textEditingController: textEditingController,
              user: state.content?.author);
        } else {
          return const Center(
              child: Text("No available chapters found for you"));
        }
      }),
    );
  }
}

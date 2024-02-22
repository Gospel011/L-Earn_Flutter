import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:l_earn/BusinessLogic/AuthCubit/auth/auth_cubit.dart';
import 'package:l_earn/BusinessLogic/contentCubit/content_cubit.dart';
import 'package:l_earn/BusinessLogic/tabCubit/tab_cubit.dart';

import 'package:l_earn/DataLayer/Models/content_model.dart';
import 'package:l_earn/Presentation/Pages/Home_Pages/Content_Pages/my_quill_editor.dart';
import 'package:l_earn/Presentation/components/content_meta_widget.dart';
import 'package:l_earn/Presentation/components/my_container_button.dart';
import 'package:l_earn/Presentation/components/my_content_thumbnail.dart';
import 'package:l_earn/Presentation/components/my_dialog.dart';

import 'package:l_earn/utils/colors.dart';

import 'package:flutter_quill/flutter_quill.dart';

class ContentDescriptionPage extends StatelessWidget {
  const ContentDescriptionPage({super.key, required this.content});

  final Content content;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TabCubit>(
      create: (context) => TabCubit(),
      child: Scaffold(
        body:
            BlocBuilder<ContentCubit, ContentState>(builder: (context, state) {
          return SafeArea(
            child: state is RequestingContentById
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Colors.blueGrey,
                    ),
                  )
                : Column(
                    children: [
                      Expanded(
                        child: CustomScrollView(
                          slivers: [
                            //? Thumbnail
                            SliverToBoxAdapter(
                                child: MyContentThumbnail(
                                    content: content, borderRadius: 0)),

                            //? title
                            SliverToBoxAdapter(
                                child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 8),
                              child: ContentMetaWidget(content: content),
                            )),

                            //? tab with description, chapters, reviews
                            const SliverPadding(
                              padding: EdgeInsets.all(16),
                            ),

                            SliverToBoxAdapter(
                              child: BlocBuilder<TabCubit, TabState>(
                                  builder: (context, tabState) {
                                print("B U I L D I N G   $content");
                                return Column(
                                  children: [
                                    //* TAB
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0),
                                      child: MyTabBar(
                                        tabs: [
                                          MyContainerButton(
                                              text: 'Description',
                                              textColor: tabState.index == 0
                                                  ? Colors.white
                                                  : AppColor.mainColorBlack,
                                              buttonColor: tabState.index == 0
                                                  ? AppColor.mainColorBlack
                                                  : Colors.transparent,
                                              onPressed: () {
                                                print('ButtonPressed');
                                                context
                                                    .read<TabCubit>()
                                                    .setTabIndex(0);
                                              }),
                                          const SizedBox(width: 10),
                                          MyContainerButton(
                                              text: 'Chapters',
                                              textColor: tabState.index == 1
                                                  ? Colors.white
                                                  : AppColor.mainColorBlack,
                                              buttonColor: tabState.index == 1
                                                  ? AppColor.mainColorBlack
                                                  : Colors.transparent,
                                              onPressed: () {
                                                print('ButtonPressed');
                                                context
                                                    .read<TabCubit>()
                                                    .setTabIndex(1);
                                              })
                                        ],
                                      ),
                                    ),

                                    tabState.index == 0

                                        //? D E S C R I P T I O N   P A G E
                                        ? BuildDescription(
                                            content: content,
                                          )

                                        //? C H A P T E R S   T A B
                                        : BuildChapters(
                                            chapters: content.type == 'book'
                                                ? content.bookChapters!
                                                : content.videoChapters!,
                                            contentId: content.id,
                                            type: content.type,
                                          )
                                  ],
                                );
                              }),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
          );
        }),
      ),
    );
  }
}

class MyTabBar extends StatelessWidget {
  const MyTabBar(
      {super.key,
      required this.tabs,
      this.mainAxisAlignment = MainAxisAlignment.start});

  final List<Widget> tabs;
  final MainAxisAlignment mainAxisAlignment;

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: mainAxisAlignment, children: tabs);
  }
}

class BuildDescription extends StatefulWidget {
  const BuildDescription({super.key, required this.content});

  final Content content;

  @override
  State<BuildDescription> createState() => _BuildDescriptionState();
}

class _BuildDescriptionState extends State<BuildDescription> {
  late final QuillController _controller;

  @override
  Widget build(BuildContext context) {
    try{

    _controller = QuillController(
        document:
            Document.fromJson(jsonDecode(widget.content.description ?? '[]')),
        selection: const TextSelection.collapsed(offset: 0));


    return Padding(
      padding: const EdgeInsets.only(top: 16, right: 16, left: 16, bottom: 24),
      child: Row(
        children: [
          Expanded(
              child: QuillEditor.basic(
            configurations: QuillEditorConfigurations(
              controller: _controller,
              readOnly: true,
              showCursor: false,
              // padding: const EdgeInsets.symmetric(horizontal: 16),
              sharedConfigurations: const QuillSharedConfigurations(
                locale: Locale('en'),
              ),
            ),
          ))
        ],
      ),
    );
    } catch (e) {
      print(':::: E R R O R   I S   $e');

      return Padding(
        padding: const EdgeInsets.only(top: 16, right: 16, left: 16, bottom: 24),
        child: Row(children: [Text(widget.content.description!)])
        );
    }
  }
}

class BuildChapters extends StatelessWidget {
  const BuildChapters(
      {super.key,
      required this.chapters,
      required this.contentId,
      required this.type});

  final List<dynamic> chapters;
  final String contentId;
  final String type;

  @override
  Widget build(BuildContext context) {
    return ChaptersColumn(
      chapters: chapters,
      contentId: contentId,
      type: type,
      preRequestAction: () => Navigator.pushNamed(context, '/chapter-page'),
    );
  }
}

class ChaptersColumn extends StatelessWidget {
  const ChaptersColumn({
    super.key,
    required this.chapters,
    required this.contentId,
    required this.preRequestAction,
    required this.type,
  });

  final List chapters;
  final String contentId;
  final String type;
  final void Function() preRequestAction;

  @override
  Widget build(BuildContext context) {
    return BlocListener<ContentCubit, ContentState>(
      listener: (context, state) {
        if (state is ChapterNotFound) {
          //? return to description page
          Navigator.pop(context);

          //? show error message
          showDialog(
              context: context,
              builder: (context) => MyDialog(
                  title: state.error!.content ==
                          'Please complete checkout to continue'
                      ? 'Payment required'
                      : state.error!.title,
                  content: state.error!.content));
        }
      },
      child: Column(
        children: [
          const SizedBox(
            height: 24,
          ),
          ...List<Widget>.generate(
              chapters.length,
              //? C H A P T E R  __________________
              (index) => GestureDetector(
                    onTap: () {
                      print(
                          "R E Q U E S T I N G   C H A P T E R   W I T H  ID: ${chapters[index].id}   A N D   N A M E  ${chapters[index].title}");

                      preRequestAction();

                      context.read<ContentCubit>().getChapterById(
                          token: context.read<AuthCubit>().state.user!.token,
                          chapterId: chapters[index].id,
                          contentId: contentId,
                          type: type);
                    },
                    child: Padding(
                      padding:
                          const EdgeInsets.only(top: 8.0, left: 16, right: 16),
                      child: Container(
                        decoration: BoxDecoration(
                            color: const Color(0xFFAEB4B4),
                            borderRadius: BorderRadius.circular(16)),

                        //? C H A P T E R   N U M B E R
                        child: ListTile(
                            title: Text('Chapter ${chapters[index].chapter}',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                        fontSize: 18, color: Colors.black)),

                            //? T I T L E
                            subtitle: Text(chapters[index].title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                        color: Colors.black.withOpacity(0.8)))),
                      ),
                    ),
                  )),
          const SizedBox(height: 24)
        ],
      ),
    );
  }
}

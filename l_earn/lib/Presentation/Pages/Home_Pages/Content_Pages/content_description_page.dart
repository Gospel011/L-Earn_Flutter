import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:l_earn/BusinessLogic/AuthCubit/auth/auth_cubit.dart';
import 'package:l_earn/BusinessLogic/contentCubit/content_cubit.dart';
import 'package:l_earn/BusinessLogic/tabCubit/tab_cubit.dart';

import 'package:l_earn/DataLayer/Models/content_model.dart';
import 'package:l_earn/Presentation/components/content_meta_widget.dart';
import 'package:l_earn/Presentation/components/my_container_button.dart';
import 'package:l_earn/Presentation/components/my_content_thumbnail.dart';

import 'package:l_earn/utils/colors.dart';

class ContentDescriptionPage extends StatelessWidget {
  const ContentDescriptionPage({super.key});

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
                      MyContentThumbnail(
                          content: state.content!, borderRadius: 0),

                      //? title
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8),
                        child: ContentMetaWidget(content: state.content!),
                      ),

                      Expanded(
                        child: CustomScrollView(
                          slivers: [
                            //? tab with description, chapters, reviews
                            const SliverPadding(
                              padding: EdgeInsets.all(16),
                            ),

                            SliverToBoxAdapter(
                              child: BlocBuilder<TabCubit, TabState>(
                                  builder: (context, tabState) {
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
                                            content: state.content!,
                                          )

                                        //? C H A P T E R S   T A B
                                        : BuildChapters(
                                            chapters: state.content!.type ==
                                                    'book'
                                                ? state.content!.bookChapters!
                                                : state.content!.videoChapters!,
                                          contentId: state.content!.id,      
                                          type: state.content!.type,
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

class BuildDescription extends StatelessWidget {
  const BuildDescription({super.key, required this.content});

  final Content content;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
      child: Row(
        children: [
          Expanded(
              child: Text(
            content.description!,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(fontSize: 18, fontWeight: FontWeight.w500),
          ))
        ],
      ),
    );
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
    return Column(
      children: [
        const SizedBox(
          height: 24,
        ),
        ...List<Widget>.generate(
            chapters.length,
            //? C H A P T E R
            (index) => GestureDetector(
                  onTap: () {
                    print(
                        "R E Q U E S T I N G   C H A P T E R   W I T H  ID: ${chapters[index].id}   A N D   N A M E  ${chapters[index].title}");
                    context.read<ContentCubit>().getChapterById(
                        token: context.read<AuthCubit>().state.user!.token,
                        chapterId: chapters[index].id,
                        contentId: contentId,
                        type: type);
                    Navigator.pushNamed(context, '/chapter-page');
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
                ))
      ],
    );
  }
}

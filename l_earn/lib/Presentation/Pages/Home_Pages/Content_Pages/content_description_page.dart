import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:l_earn/BusinessLogic/learnCubit/content_cubit.dart';
import 'package:l_earn/BusinessLogic/tabCubit/tab_cubit.dart';
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
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        //? imagge
                        MyContentThumbnail(
                            content: state.content!, borderRadius: 0),

                        //? title
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: ContentMetaWidget(content: state.content!),
                        ),
                        //? tab with description, chapters, reviews

                        // MyExpandableText(text: state.content!.description!)

                        const SizedBox(
                          height: 24,
                        ),

                        BlocBuilder<TabCubit, TabState>(
                            builder: (context, tabState) {
                          return Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: Row(
                                  children: [
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
                                  ? Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
                                    child: Row(
                                        children: [
                                          Expanded(child: Text(state.content!.description!, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 18, fontWeight: FontWeight.w500),))
                                        ],
                                      ),
                                  )
                                  : Column(
                                      children: List<Widget>.generate(
                                          state.content!.bookChapters!.length,
                                          (index) => Padding(
                                            padding: const EdgeInsets.only(top: 8.0, left: 16, right: 16),
                                            child: Container(
                                              decoration: BoxDecoration(color: const Color(0xFFAEB4B4), borderRadius: BorderRadius.circular(16)),
                                                  child: ListTile(
                                                      title: Text(
                                                          'Chapter ${state.content!.bookChapters![index].chapter}', style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 18, color: Colors.black)),
                                                      subtitle: Text(
                                                          state.content!.bookChapters![index].title, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.black.withOpacity(0.8)))
                                                          ),
                                                ),
                                          )),
                                    )
                            ],
                          );
                        }),
                      ],
                    ),
                  ),
          );
        }),
      ),
    );
  }
}

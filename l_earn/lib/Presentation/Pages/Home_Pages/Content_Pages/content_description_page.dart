import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:l_earn/BusinessLogic/AuthCubit/auth/auth_cubit.dart';
import 'package:l_earn/BusinessLogic/contentCubit/content_cubit.dart';
import 'package:l_earn/BusinessLogic/paymentCubit/payment_cubit.dart';
import 'package:l_earn/BusinessLogic/tabCubit/tab_cubit.dart';

import 'package:l_earn/DataLayer/Models/content_model.dart';

import 'package:l_earn/Presentation/components/content_meta_widget.dart';
import 'package:l_earn/Presentation/components/my_container_button.dart';
import 'package:l_earn/Presentation/components/my_content_thumbnail.dart';
import 'package:l_earn/Presentation/components/my_dialog.dart';
import 'package:l_earn/Presentation/components/my_elevated_button.dart';

import 'package:l_earn/utils/colors.dart';

import 'package:flutter_quill/flutter_quill.dart';
import 'package:l_earn/utils/constants.dart';

class ContentDescriptionPage extends StatefulWidget {
  const ContentDescriptionPage({super.key, required this.contentId});

  final String contentId;

  @override
  State<ContentDescriptionPage> createState() => _ContentDescriptionPageState();
}

class _ContentDescriptionPageState extends State<ContentDescriptionPage> {
  @override
  void initState() {
    super.initState();

    context.read<ContentCubit>().getContentById(
        context.read<AuthCubit>().state.user?.token, widget.contentId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TabCubit>(
      create: (context) => TabCubit(),
      child: BlocListener<PaymentCubit, PaymentState>(
        listener: (context, state) {
          print("CURRENT PAYMENT STATE IS $state");
          if (state is PaymentInvoiceGenerated) {
            // NAVIGATE TO PAYMENT PAGE
            context.pushNamed(AppRoutes.payment,
                extra: context.read<ContentCubit>().state.content);
            //! avigator.of(context)
            //     .pushNamed('/payment-page', arguments: content);
          } else if (state is GeneratingPaymentInvoiceFailed) {
            showDialog(
                context: context,
                builder: (context) {
                  return MyDialog(
                      title: state.error!.title, content: state.error!.content);
                });
          }
        },
        child: BlocListener<ContentCubit, ContentState>(
          listener: (context, state) {
            print('STATE IS $state');

             if (state is ContentLoadingFailed ||
                state is ContentNotFound) {
              var content = state.error!.content;

              if (state.error!.content == 'Invalid  "content" id') {
                content = 'No content was found';
              }
              showDialog(
                  context: context,
                  builder: ((context) =>
                      MyDialog(title: state.error!.title, content: content)));
            } 
          },
        
          child: Scaffold(
            body: BlocBuilder<ContentCubit, ContentState>(
                builder: (context, state) {
              return SafeArea(
                child: state.content == null
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
                                        content: state.content!,
                                        borderRadius: 0)),
          
                                //? title
                                SliverToBoxAdapter(
                                    child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0, vertical: 8),
                                  child:
                                      ContentMetaWidget(content: state.content!),
                                )),
          
                                //? Pay Button
                                state.content!.author.id ==
                                            context
                                                .read<AuthCubit>()
                                                .state
                                                .user
                                                ?.id ||
                                        state.content!.price == 0
                                    ? const SliverToBoxAdapter(child: SizedBox())
                                    : SliverToBoxAdapter(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16.0),
                                          child: BlocBuilder<PaymentCubit,
                                                  PaymentState>(
                                              builder: (context, paymentState) {
                                            return MyElevatedButton(
                                              text: 'Purchase',
                                              loading: paymentState
                                                  is GeneratingPaymentInvoice,
                                              onPressed: () {
                                                // GENERATE INVOICE
                                                print("state $state");
                                                context
                                                    .read<PaymentCubit>()
                                                    .generateInvoice(
                                                        context
                                                            .read<AuthCubit>()
                                                            .state
                                                            .user
                                                            ?.token,
                                                        state.content!.id);
          
                                                print(
                                                    "A B O U T   T O   R E C E I V E   ${state.content!.price}");
                                              },
                                            );
                                          }),
                                        ),
                                      ),
          
                                //? tab with description, chapters, reviews
                                const SliverPadding(
                                  padding: EdgeInsets.all(16),
                                ),
          
                                SliverToBoxAdapter(
                                  child: BlocBuilder<TabCubit, TabState>(
                                      builder: (context, tabState) {
                                    // print("B U I L D I N G   $content");
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
                                                    : state
                                                        .content!.videoChapters!,
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
        ),
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
    try {
      _controller = QuillController(
          document:
              Document.fromJson(jsonDecode(widget.content.description ?? '[]')),
          selection: const TextSelection.collapsed(offset: 0));

      return Padding(
        padding:
            const EdgeInsets.only(top: 16, right: 16, left: 16, bottom: 24),
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
          padding:
              const EdgeInsets.only(top: 16, right: 16, left: 16, bottom: 24),
          child: Row(
              children: [Expanded(child: Text(widget.content.description!))]));
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
        preRequestAction: () => context.pushNamed(AppRoutes
            .chapterPage, pathParameters: {"id": contentId}) //! avigator.pushNamed(context, '/chapter-page'),
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
          //! avigator.pop(context);
          context.pop();

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
                      // print(
                      //     "R E Q U E S T I N G   C H A P T E R   W I T H  ID: ${chapters[index].id}   A N D   N A M E  ${chapters[index].title}");

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

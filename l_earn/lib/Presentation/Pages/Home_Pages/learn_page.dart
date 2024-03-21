import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:l_earn/BusinessLogic/AuthCubit/auth/auth_cubit.dart';
import 'package:l_earn/Presentation/components/my_circular_progress_indicator.dart';
import 'package:l_earn/Presentation/components/my_dialog.dart';
import 'package:l_earn/Presentation/components/my_elevated_button.dart';
import 'package:l_earn/utils/colors.dart';
import 'package:l_earn/utils/constants.dart';
import 'package:share_plus/share_plus.dart';
import '../../../BusinessLogic/contentCubit/content_cubit.dart';
import '../../../DataLayer/Models/content_model.dart';

import '../../components/my_content_widget.dart';

import '../../../utils/mixins.dart';

class LearnPage extends StatefulWidget {
  const LearnPage({super.key});

  @override
  State<LearnPage> createState() => _LearnPageState();
}

class _LearnPageState extends State<LearnPage>
    with PriceParserMixin, TimeParserMixin {
  final ScrollController _scrollController = ScrollController();

  TextStyle? textTheme;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    // context
    //     .read<ContentCubit>()
    //     .loadContents(context.read<AuthCubit>().state.user?.token);

    //? ADD LISTENER TO SCROLL LISTENER TO LISTEN FOR WHEN THE USER REACHES
    //? THE BOTTOM OF THE PAGE
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    // print(
    //     'Offset: ${_scrollController.offset}, maxScrollEXtent: ${_scrollController.position.maxScrollExtent}'); 8134556771

    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent - 10 &&
        !_scrollController.position.outOfRange &&
        context.read<ContentCubit>().state is! ContentLoading) {
      print("getting contents");
      getContents();
    }
  }

  Future<void> getContents({int? page}) async {
    print("::: geting posts :::");
    await context
        .read<ContentCubit>()
        .loadContents(context.read<AuthCubit>().state.user!.token, page: page);
  }

  @override
  Widget build(BuildContext context) {
    textTheme = Theme.of(context).textTheme.bodyMedium;

    return RefreshIndicator(
      color: AppColor.mainColorBlack,
      onRefresh: () async => await getContents(page: 1),
      child: CustomScrollView(
        controller: _scrollController,
        slivers: [
          //? Spacing from top
          const SliverPadding(padding: EdgeInsets.all(8)),

          //? Scrollable list of contents
          BlocBuilder<ContentCubit, ContentState>(builder: (context, state) {
            print("Building content page with state $state");
            return SliverList.builder(
                itemCount: state.contents.length,
                itemBuilder: (content, index) {
                  final Content content = state.contents[index];
                  const padding =
                      EdgeInsets.only(left: 16.0, right: 16, bottom: 16);

                  return Padding(
                    padding: padding,

                    //* CONTENT
                    child: MyContent(
                      onHeaderPressed: () => context.goNamed(AppRoutes.profile,
                          queryParameters: {
                            "user": state.contents[index].author.id!
                          }),
                      content: content,
                      onThumbnailPressed: () {
                        //? REQUEST FOR A PARTICULAR CONTENT
                        print('${content.title} thumbnail pressed');

                        //? NAVIGATE TO CONTENT DESCRIPTION PAGE
                        context.goNamed(AppRoutes.contentDescription,
                            pathParameters: {"id": content.id});
                      },
                      onMetaPressed: () {
                        print('${content.title} meta pressed');
                      },
                      moreActions: [
                        PopupMenuItem(
                            child: Text(
                              "Share ${content.type}",
                              style: textTheme,
                            ),
                            onTap: () {
                              Share.share("${NetWorkConstants.baseShareUrl}/contents/${content.id}");
                            }),
                        PopupMenuItem(
                            child: Text(
                          "Save",
                          style: textTheme,
                        )),
                        PopupMenuItem(
                          child: Text(
                            "Report",
                            style: textTheme,
                          ),
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text("${content.type} flagged")));
                          },
                        ),
                      ],
                    ),
                  );
                });
          }),

          BlocBuilder<ContentCubit, ContentState>(builder: (context, state) {
            return SliverToBoxAdapter(
                child: state is ContentLoading
                    ? const MyCircularProgressIndicator()
                    : state is ContentLoadingFailed || state.contents.isEmpty
                        ? Center(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: MyElevatedButton(
                                text: 'Reload',
                                onPressed: () {
                                  print('RELOADING');
                                  getContents();
                                },
                              ),
                            ),
                          )
                        : const SizedBox());
          }),
        ],
      ),
    );
    ;
  }
}

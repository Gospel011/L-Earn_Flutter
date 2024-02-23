import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:l_earn/BusinessLogic/AuthCubit/auth/auth_cubit.dart';
import 'package:l_earn/Presentation/components/my_dialog.dart';
import 'package:l_earn/utils/colors.dart';
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

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    //? ADD LISTENER TO SCROLL LISTENER TO LISTEN FOR WHEN THE USER REACHES
    //? THE BOTTOM OF THE PAGE
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    // print(
    //     'Offset: ${_scrollController.offset}, maxScrollEXtent: ${_scrollController.position.maxScrollExtent}');

    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent - 10 &&
        !_scrollController.position.outOfRange &&
        context.read<ContentCubit>().state is! ContentLoading) {
      getPosts();
    }
  }

  Future<void> getPosts({int? page}) async {
    print("::: geting posts :::");
    await context
        .read<ContentCubit>()
        .loadContents(context.read<AuthCubit>().state.user!.token, page: page);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ContentCubit, ContentState>(
      listener: (context, state) {
        print('STATE IS $state');
        if (state is RequestingContentById) {
          showDialog(
              context: context,
              builder: (context) => const Center(
                  child: CircularProgressIndicator(color: Colors.blueGrey)));
        } else if (state is ContentLoadingFailed || state is ContentNotFound) {
          showDialog(
              context: context,
              builder: ((context) => MyDialog(
                  title: state.error!.title, content: state.error!.content)));
        } else if (state is ContentFound) {
          Navigator.pop(context);
          //? NAVIGATE TO CONTENT DESCRIPTION PAGE
          Navigator.of(context)
              .pushNamed('/content-description', arguments: state.content!);
        }
      },
      child: RefreshIndicator(
        color: AppColor.mainColorBlack,
        onRefresh: () async => await getPosts(page: 1),
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            //? Spacing from top
            const SliverPadding(padding: EdgeInsets.all(8)),

            //? Scrollable list of contents
            BlocBuilder<ContentCubit, ContentState>(builder: (context, state) {
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
                        onHeaderPressed: () => Navigator.pushNamed(context, '/profile-page', arguments: state.contents?[index].author),
                        content: content,
                        onThumbnailPressed: () {
                          //? REQUEST FOR A PARTICULAR CONTENT
                          print('${content.title} thumbnail pressed');
                          context.read<ContentCubit>().getContentById(
                              context.read<AuthCubit>().state.user?.token,
                              content.id);
                        },
                        onMetaPressed: () {
                          print('${content.title} meta pressed');
                        },
                      ),
                    );
                  });
            })
          ],
        ),
      ),
    );
    ;
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:l_earn/BusinessLogic/AuthCubit/auth/auth_cubit.dart';
import 'package:l_earn/Presentation/components/my_circularProgressIndicator.dart';
import 'package:l_earn/Presentation/components/my_circular_progress_indicator.dart';
import 'package:l_earn/Presentation/components/my_elevated_button.dart';
import 'package:l_earn/Presentation/components/my_post_widget.dart';
import 'package:l_earn/utils/colors.dart';

import '../../../BusinessLogic/PostCubit/post_cubit.dart';
import '../../../DataLayer/Models/post_model.dart';
import '../../components/my_dialog.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final ScrollController _scrollController = ScrollController();
  // int page = 1;
  late TextStyle? textTheme;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    print(
        'Offset: ${_scrollController.offset}, maxScrollEXtent: ${_scrollController.position.maxScrollExtent}');

    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent - 10 &&
        !_scrollController.position.outOfRange &&
        context.read<PostCubit>().state is! NewPostsLoading) {
      getPosts();
    }
  }

  Future<void> getPosts({int? page}) async {
    print("::: geting posts :::");
    await context.read<PostCubit>().getNewPosts(
        context.read<AuthCubit>().state.user!.id,
        context.read<AuthCubit>().state.user!.token,
        page: page);
  }

  @override
  Widget build(BuildContext context) {
    textTheme = Theme.of(context).textTheme.bodyMedium;

    return BlocListener<PostCubit, PostState>(
      listener: ((context, state) {
        if (state is NewPostsFailed) {
          showDialog(
              context: context,
              builder: (context) {
                return MyDialog(
                    title: state.error!.title, content: state.error!.content);
              });
        } else if (state is NewPostsLoaded) {
          // page++;
        }
      }),
      child: RefreshIndicator(
        color: AppColor.mainColorBlack,
        onRefresh: () async {
          await getPosts(page: 1);
        },
        child: Scaffold(
          body: BlocBuilder<PostCubit, PostState>(
            builder: (context, state) {
              return CustomScrollView(
                controller: _scrollController,
                slivers: [
                  //? TOP SPACING
                  const SliverToBoxAdapter(
                    child: SizedBox(
                      height: 16,
                    ),
                  ),

                  //? SCROLLABLE LIST OF POSTS
                  SliverList.builder(
                      itemCount: state.newPosts.length,
                      itemBuilder: (context, index) {
                        final Post post = state.newPosts[index];

                        return MyPostWidget(
                          post: post,
                          index: index,
                          moreActions: [
                            PopupMenuItem(
                                child: Text(
                              "Share post",
                              style: textTheme,
                            )),
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
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text("post flagged")));
                              },
                            ),
                          ],
                        );
                      }),

                  SliverToBoxAdapter(
                      child: state is NewPostsLoading
                          ? const MyCircularProgressIndicator()
                          : state is NewPostsFailed
                              ? Center(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0),
                                    child: MyElevatedButton(
                                      text: 'Reload',
                                      onPressed: () {
                                        print('RELOADING');
                                        getPosts();
                                      },
                                    ),
                                  ),
                                )
                              : const SizedBox()),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

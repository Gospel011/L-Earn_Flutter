import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:l_earn/BusinessLogic/AuthCubit/auth/auth_cubit.dart';
import 'package:l_earn/BusinessLogic/contentCubit/content_cubit.dart';
import 'package:l_earn/DataLayer/Models/content_model.dart';
import 'package:l_earn/DataLayer/Models/user_model.dart';
import 'package:l_earn/Presentation/components/my_content_widget.dart';
import 'package:l_earn/Presentation/components/my_dialog.dart';
import 'package:l_earn/Presentation/components/my_image_widget.dart';
import 'package:l_earn/Presentation/components/my_profile_picture.dart';
import 'package:l_earn/Presentation/components/my_text_button.dart';
import 'package:l_earn/Presentation/components/my_container_button.dart';
import 'package:l_earn/BusinessLogic/tabCubit/tab_cubit.dart';
import 'package:l_earn/Presentation/components/render_user_name.dart';

import 'package:l_earn/utils/mixins.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfilePage extends StatefulWidget with AppBarMixin {
  const ProfilePage({super.key, required this.user});
  final User user;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // late final User user;

  @override
  void initState() {
    super.initState();
    print('Asking__________________');

    // user = context.read<AuthCubit>().state.user!;

    context.read<ContentCubit>().loadContents(
        context.read<AuthCubit>().state.user!.token,
        userId: widget.user.id);
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
      child: Scaffold(
        appBar: widget.buildAppBar(context,
            actions: context.read<AuthCubit>().state.user?.id == widget.user.id
                ? [
                    PopupMenuButton(
                        onSelected: (value) {
                          print('$value pressed');
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        itemBuilder: (context) {
                          return [
                            const PopupMenuItem(
                              value: 'Edit',
                              child: Text("Edit profile"),
                            ),

                            // const PopupMenuItem(
                            //   value: 'Share',
                            //   child: Text("Share profile"),
                            // )
                          ];
                        })
                  ]
                : null),
        body: CustomScrollView(
          // controller: _scrollController,
          slivers: [
            //? BANNER
            SliverToBoxAdapter(
              child: SizedBox(
                  width: double.maxFinite,
                  height: 150,
                  child: MyImageWidget(
                    image: widget.user.banner ?? 'default.png',
                    borderRadius: 0,
                  )),
            ),

            const SliverPadding(padding: EdgeInsets.all(8)),

            //? PROFILE PICTURE | MINI DESCRIPTION
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //* PROFILE PICTURE
                      MyProfilePicture(user: widget.user, radius: 32),

                      const SizedBox(
                        width: 4,
                      ),

                      //* MINI DESCRIPTION
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //? username
                            RenderUserName(
                              user: widget.user,
                              fontWeight: FontWeight.bold,
                            ),

                            //? handle
                            Text(widget.user.handle!,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                        color: Colors.black.withOpacity(0.7))),

                            //? school
                            widget.user.school != null
                                ? Text(widget.user.school!)
                                : const SizedBox(),

                            Text('${widget.user.followers} followers',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(fontWeight: FontWeight.bold))
                          ],
                        ),
                      ),

                      // Text(' \u2022 '),

                      // MyContainerButton(text: 'Follow', onPressed: () {})
                    ]),
              ),
            ),

            const SliverPadding(padding: EdgeInsets.all(8)),

            //? TABS WITH POSTS, BOOKS, VIDEOS
            SliverToBoxAdapter(
              child: BlocBuilder<TabCubit, TabState>(builder: (context, state) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(children: [
                    // state.index == 0
                    //     ? MyContainerButton(
                    //         text: 'Posts',
                    //         showShadow: false,
                    //         onPressed: () {
                    //           print('My Posts pressed');
                    //         })
                    //     : MyTextButton(
                    //         text: 'Posts',
                    //         onPressed: () {
                    //           print('My Posts Pressed');
                    //           context.read<TabCubit>().setTabIndex(0);
                    //         },
                    //       ),
                    // const SizedBox(
                    //   width: 8,
                    // ),
                    state.index == 0
                        ? MyContainerButton(
                            text: 'Contents',
                            showShadow: false,
                            onPressed: () {
                              print('My Books pressed');
                            })
                        : MyTextButton(
                            text: 'Contents',
                            fontWeight: FontWeight.w500,
                            onPressed: () {
                              print('My Contents Pressed');
                              context.read<TabCubit>().setTabIndex(0);

                              // context
                              // .read<ContentCubit>()
                              // .loadUserContents(context.read<AuthCubit>().state.user!.token, user.id);
                            },
                          ),
                    // const SizedBox(
                    //   width: 8,
                    // ),
                    // state.index == 2
                    // ? MyContainerButton(
                    //     text: 'Videos',
                    //     showShadow: false,
                    //     onPressed: () {
                    //       print('My Posts pressed');
                    //     })
                    // : MyTextButton(
                    //     text: 'Videos',
                    //     fontWeight: FontWeight.w500,
                    //     onPressed: () {
                    //       print('My Videos Pressed');
                    //       context.read<TabCubit>().setTabIndex(2);
                    //     },
                    //   ),
                  ]),
                );
              }),
            ),
            //? Spacing from top
            const SliverPadding(padding: EdgeInsets.all(8)),

            //? Scrollable list of contents

            BlocBuilder<ContentCubit, ContentState>(builder: (context, state) {
              final User user = context.read<AuthCubit>().state.user!;
              return BlocBuilder<TabCubit, TabState>(
                  builder: (context, tabstate) {
                print("STATE.MYCONTENTS = ${state.myContents}");
                return tabstate.index == 0
                    ? state.myContents != null && state.myContents!.isNotEmpty
                        ? SliverList.builder(
                            itemCount: state.myContents!.length,
                            itemBuilder: (content, index) {
                              final Content content = state.myContents![index];
                              const padding = EdgeInsets.only(
                                  left: 16.0, right: 16, bottom: 16);

                              return Padding(
                                padding: padding,

                                //* CONTENT
                                child: MyContent(
                                  content: content,
                                  moreActions: user.id == content.author.id
                                      ? [
                                          //? EDIT CONTENT
                                          PopupMenuItem(
                                            value: 'edit',
                                            onTap: () {
                                              //TODO: HANDLE EDIT CONTENT
                                              print("Edit content pressed");
                                              print(
                                                  "POST TAG LENGT ${content.tags}");

                                              Navigator.pushNamed(
                                                  context, '/create-tutorial',
                                                  arguments: {
                                                    'title': content.title,
                                                    'description':
                                                        content.description,
                                                    'price': content.price,
                                                    'genre':
                                                        content.tags?.join(''),
                                                    'thumbnailUrl':
                                                        content.thumbnailUrl,
                                                    'id': content.id
                                                  });
                                            },
                                            child: Text('Edit ${content.type}'),
                                          ),

                                          //? ADD CHAPTER
                                          PopupMenuItem(
                                            value: 'add',
                                            onTap: () {
                                              //TODO: HANDLE ADD CONTENT
                                              print("Add chapter pressed");

                                              Navigator.of(context).pushReplacementNamed(
                                                  '/write-book-page', arguments: {"content": content});
                                            },
                                            child: const Text('Add chapter'),
                                          ),

                                          //? DELETE CONTENT
                                          PopupMenuItem(
                                            value: 'delete',
                                            onTap: () {
                                              //TODO: HANDLE DELETE CONTENT
                                              print(
                                                  "Delete content pressed pressed");
                                            },
                                            child: Text(
                                              'Delete ${content.type}',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium
                                                  ?.copyWith(color: Colors.red),
                                            ),
                                          ),
                                        ]
                                      : [
                                          //? DELETE CONTENT
                                          PopupMenuItem(
                                            value: 'report',
                                            onTap: () {
                                              //TODO: HANDLE DELETE CONTENT
                                              print(
                                                  "Delete content pressed pressed");
                                            },
                                            child:
                                                Text('Report ${content.type}'),
                                          ),
                                        ],
                                  onThumbnailPressed: () {
                                    //? REQUEST FOR A PARTICULAR CONTENT
                                    print('${content.title} thumbnail pressed');
                                    context.read<ContentCubit>().getContentById(
                                        context
                                            .read<AuthCubit>()
                                            .state
                                            .user
                                            ?.token,
                                        content.id);

                                    //? NAVIGATE TO CONTENT DESCRIPTION PAGE
                                    // Navigator.of(context).pushNamed(
                                    //     '/content-description',
                                    //     arguments: content);
                                  },
                                  onMetaPressed: () {
                                    print('${content.title} meta pressed');
                                  },
                                ),
                              );
                            })
                        : const SliverToBoxAdapter(
                            child: Center(child: Text('No content yet')))
                    : const SizedBox();
              });
            })
          ],
        ),
      ),
    );
  }
}

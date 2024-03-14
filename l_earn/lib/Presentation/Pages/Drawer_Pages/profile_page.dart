import 'package:flutter/material.dart';

import 'package:l_earn/BusinessLogic/AuthCubit/auth/auth_cubit.dart';
import 'package:l_earn/BusinessLogic/AuthCubit/auth/auth_state.dart';
import 'package:l_earn/BusinessLogic/contentCubit/content_cubit.dart';
import 'package:l_earn/DataLayer/Models/content_model.dart';
import 'package:l_earn/DataLayer/Models/user_model.dart';
import 'package:l_earn/Presentation/components/build_banner_and_user_description.dart';
import 'package:l_earn/Presentation/components/my_content_widget.dart';
import 'package:l_earn/Presentation/components/my_dialog.dart';

import 'package:l_earn/Presentation/components/my_text_button.dart';
import 'package:l_earn/Presentation/components/my_container_button.dart';
import 'package:l_earn/BusinessLogic/tabCubit/tab_cubit.dart';

import 'package:l_earn/utils/colors.dart';

import 'package:l_earn/utils/mixins.dart';

import 'package:l_earn/utils/constants.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import "dart:io";

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

    loadContents();
  }

  void loadContents({int page = 1}) {
    context.read<ContentCubit>().loadContents(
        context.read<AuthCubit>().state.user!.token,
        userId: widget.user.id,
        page: page);
  }

  void deleteBook(String contentId) {
    //! avigator.pop(context);
    context.pop();

    //! PERFORM DELETE OPERATION
    context
        .read<ContentCubit>()
        .deleteBook(context.read<AuthCubit>().state.user?.token, id: contentId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ContentCubit, ContentState>(
      listener: (context, state) {
        print('STATE IS $state');
        print("FOLLOWER COUNT IS ${widget.user.followers}");
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
          //! avigator.pop(context);
          context.pop();
          //? NAVIGATE TO CONTENT DESCRIPTION PAGE
          //! avigator.of(context)
          //     .pushNamed('/content-description', arguments: state.content!);
          context.pushNamed(AppRoutes.contentDescription,
              extra: state.content!);
        } else if (state is ContentDeleted) {
          //! avigator.pop(context);
          context.pop();
          //? REFRESH CONTENT
          loadContents();
        }
      },

      //? S C A F F O L D
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () => context.pushNamed(AppRoutes.createTutorial),
          //! avigator.pushNamed(context, '/create-tutorial'),
          elevation: 20,
          backgroundColor: AppColor.mainColorBlack,
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
        appBar: widget.buildAppBar(context,
            automaticallyImplyLeading: Platform.isWindows,
            actions: context.read<AuthCubit>().state.user?.id == widget.user.id
                ? [
                    PopupMenuButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        itemBuilder: (context) {
                          var list = [
                            //? Edit Profile
                            PopupMenuItem(
                              value: 'Edit',
                              child: const Text("Edit profile"),
                              onTap: () =>
                                  context.pushNamed(AppRoutes.editProfile),
                              //! avigator.pushNamed(
                              //     context, '/edit-profile-page'),
                            ),

                            //? Verify Email
                            PopupMenuItem(
                              value: 'verify',
                              child: const Text("Verify email"),
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return MyDialog(
                                          title: "Choose an option",
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              ListTile(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16)),
                                                title:
                                                    const Text("I have a code"),
                                                subtitle: Text(
                                                  "If you have an unexpired otp",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium
                                                      ?.copyWith(fontSize: 14),
                                                ),
                                                onTap: () {
                                                  //! avigator.pop(context);
                                                  context.pop();
                                                  print(
                                                      "Don't generate new otp");
                                                },
                                              ),
                                              ListTile(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16)),
                                                title:
                                                    const Text("Get new code"),
                                                subtitle: Text(
                                                  "If you don't have an otp",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium
                                                      ?.copyWith(fontSize: 14),
                                                ),
                                                onTap: () {
                                                  //! avigator.pop(context);
                                                  context.pop();
                                                  print("Generate new otp");
                                                },
                                              ),
                                            ],
                                          ));
                                    });
                              },
                            ),
                          ];

                          if (widget.user.emailVerified == true) {
                            list.removeLast();
                            return list;
                          }

                          return list;
                        })
                  ]
                : null),
        body: CustomScrollView(
          // controller: _scrollController,
          slivers: [
            //? BANNER AND USER DESCRIPTION
            SliverToBoxAdapter(child:
                BlocBuilder<AuthCubit, AuthState>(builder: (context, state) {
              late User profileUser;
              if (widget.user.id != state.user!.id) {
                print("\n\n\nIS NOT CURRENT USER\n\n\n");
                profileUser = widget.user;
              } else {
                print("\n\n\nIS CURRENT USER\n\n\n");
                profileUser = state.user!;
              }

              return BuildBannerAndUserDescription(user: profileUser);
            })),

            const SliverPadding(padding: EdgeInsets.all(8)),

            //? TABS WITH POSTS, BOOKS, VIDEOS
            SliverToBoxAdapter(
              child: BlocBuilder<TabCubit, TabState>(builder: (context, state) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(children: [
                    state.index == 0
                        ? MyContainerButton(
                            text: 'Contents',
                            showShadow: false,
                            buttonColor: Colors.black.withOpacity(0.8),
                            onPressed: () {
                              print('My Contents pressed');
                            })
                        : MyTextButton(
                            text: 'Contents',
                            fontWeight: FontWeight.w500,
                            onPressed: () {
                              print('My Contents Pressed');
                              context.read<TabCubit>().setTabIndex(0);
                            },
                          ),
                  ]),
                );
              }),
            ),
            //? Spacing from top
            const SliverPadding(padding: EdgeInsets.all(8)),

            //? SCROLLABLE LIST OF CONTENTS

            BlocBuilder<ContentCubit, ContentState>(builder: (context, state) {
              final User user = context.read<AuthCubit>().state.user!;
              return BlocBuilder<TabCubit, TabState>(
                  builder: (context, tabstate) {
                print("STATE.MYCONTENTS = ${state.myContents}");
                print("S  T A T E    I S   $state");
                return tabstate.index == 0
                    ? state is ContentLoading
                        ? const SliverToBoxAdapter(
                            child: Center(
                                child: CircularProgressIndicator(
                                    color: Colors.blueGrey)))
                        : state.myContents != null &&
                                state.myContents!.isNotEmpty

                            //* BUILDING THE ACTUAL SCROLLABLE LIST OF CONTENTS
                            ? buildListOfContents(context,
                                contents: state.myContents!,
                                itemCount: state.myContents!.length,
                                user: user)
                            : SliverToBoxAdapter(
                                child: Center(
                                    child: Text(
                                        '${context.read<AuthCubit>().state.user?.id == widget.user.id ? 'You have' : "${widget.user.firstName} has"} not created any books yet')))
                    : const SizedBox();
              });
            })
          ],
        ),
      ),
    );
  }

//* M E T H O D S
  SliverList buildListOfContents(BuildContext context,
      {required List<Content> contents,
      required int itemCount,
      required User user}) {
    return SliverList.builder(
        itemCount: itemCount,
        itemBuilder: (content, index) {
          final Content content = contents[index];
          const padding = EdgeInsets.only(left: 16.0, right: 16, bottom: 16);

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
                          print("POST TAG LENGT ${content.tags}");

                          //! avigator.pushNamed(context, '/create-tutorial',
                          //     arguments: {
                          //       'title': content.title,
                          //       'description': content.description,
                          //       'price': content.price,
                          //       'genre': content.tags?.join(''),
                          //       'thumbnailUrl': content.thumbnailUrl,
                          //       'id': content.id
                          //     });
                          context.pushNamed(AppRoutes.createTutorial, extra: {
                            'title': content.title,
                            'description': content.description,
                            'price': content.price,
                            'genre': content.tags?.join(''),
                            'thumbnailUrl': content.thumbnailUrl,
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

                          context.pushNamed(
                              AppRoutes.writeBook,
                              extra: {"content": content});
                          //! avigator.of(context).pushReplacementNamed(
                          //     '/write-book-page',
                          //     arguments: {"content": content});
                        },
                        child: const Text('Add chapter'),
                      ),

                      //? DELETE CONTENT
                      PopupMenuItem(
                        value: 'delete',
                        onTap: () {
                          //TODO: HANDLE DELETE CONTENT
                          print("Delete content pressed pressed");

                          showDialog(
                              context: context,
                              builder: (context) {
                                return MyDialog(
                                  title: "Delete Book?",
                                  content: RichText(
                                    text: TextSpan(
                                        text:
                                            'Are you sure you want to delete ',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium,
                                        children: [
                                          TextSpan(
                                              text: '"${content.title}"',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium
                                                  ?.copyWith(
                                                      fontStyle:
                                                          FontStyle.italic)),
                                          const TextSpan(
                                              text: '? This operation is '),
                                          TextSpan(
                                              text: 'irreversible',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium
                                                  ?.copyWith(
                                                      color: Colors.red,
                                                      fontWeight:
                                                          FontWeight.bold))
                                        ]),
                                  ),
                                  actions: [
                                    //! Yes
                                    MyContainerButton(
                                        text: 'yes',
                                        showShadow: false,
                                        textColor: Colors.black,
                                        buttonColor: Colors.transparent,
                                        onPressed: () {
                                          deleteBook(content.id);
                                        }),

                                    //?No
                                    MyContainerButton(
                                        text: "No",
                                        onPressed: () {
                                          //! avigator.pop(context);
                                          context.pop();
                                          print("User clicked No");
                                        })
                                  ],
                                );
                              });
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
                          print("Delete content pressed pressed");
                        },
                        child: Text('Report ${content.type}'),
                      ),
                    ],
              onThumbnailPressed: () {
                //? REQUEST FOR A PARTICULAR CONTENT
                print('${content.title} thumbnail pressed');
                context.read<ContentCubit>().getContentById(
                    context.read<AuthCubit>().state.user?.token, content.id);
              },
              onMetaPressed: () {
                print('${content.title} meta pressed');
              },
            ),
          );
        });
  }
}

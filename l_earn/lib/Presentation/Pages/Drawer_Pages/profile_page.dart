import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:l_earn/BusinessLogic/AuthCubit/auth/auth_cubit.dart';

import 'package:l_earn/BusinessLogic/ProfileCubit/profile_cubit.dart';

import 'package:l_earn/BusinessLogic/contentCubit/content_cubit.dart';
import 'package:l_earn/DataLayer/Models/content_model.dart';

import 'package:l_earn/DataLayer/Models/user_model.dart';
import 'package:l_earn/Helpers/auth_helper.dart';
import 'package:l_earn/Presentation/components/build_banner_and_user_description.dart';

import 'package:l_earn/Presentation/components/my_circular_progress_indicator.dart';
import 'package:l_earn/Presentation/components/my_content_widget.dart';

import 'package:l_earn/Presentation/components/my_dialog.dart';
import 'package:l_earn/Presentation/components/my_image_loading_placeholder_widget.dart';


import 'package:l_earn/Presentation/components/my_container_button.dart';


import 'package:l_earn/utils/colors.dart';

import 'package:l_earn/utils/mixins.dart';

import 'package:l_earn/utils/constants.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import "dart:io";

import 'package:share_plus/share_plus.dart';

class ProfilePage extends StatefulWidget
    with AppBarMixin, ContentMixin, UserMixin {
  const ProfilePage({super.key, required this.userId, required this.shell});
  final String userId;
  final StatefulNavigationShell shell;

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
    // context
    //     .read<ContentCubit>()
    //     .loadContents(context.read<AuthCubit>().state.user?.token);

    loadContents( userId: widget.userId);

    context.read<ProfileCubit>().getUserById(
        context.read<AuthCubit>().state.user?.token, widget.userId);
  }

  void delete(contentId) {
    context
        .read<ContentCubit>()
        .deleteBook(context.read<AuthCubit>().state.user?.token, id: contentId);
  }

  void loadContents(
      {int page = 1, required String userId}) {
    context.read<ContentCubit>().loadContents(
        context.read<AuthCubit>().state.user!.token,
        userId: userId,
        page: page);
  }



  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ContentCubit, ContentState>(
          listener: (context, state) {
            print('STATE IS $state');

             if (state is ContentDeleted) {
              context.pop();

              //? REFRESH CONTENT
              loadContents(userId: widget.userId);
            }

          },
        ),
        BlocListener<ProfileCubit, ProfileState>(listener: (context, state) {
          if (state.error != null) {
            var content = state.error!.content;

            if (state.error!.content == 'Invalid  "user" id') {
              content = 'The requested user does not exist';
            }
            showDialog(
                context: context,
                builder: (context) {
                  return MyDialog(title: state.error!.title, content: content);
                });
          }
        })
      ],
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
            actions: context.read<AuthCubit>().state.user?.id == widget.userId
                ? [buildPopupMenuButton()]
                : null),
        body: CustomScrollView(
          slivers: [
            //? BANNER AND USER DESCRIPTION return BuildBannerAndUserDescription(user: profileUser);
            SliverToBoxAdapter(
              child: BlocBuilder<ProfileCubit, ProfileState>(
                  builder: (context, state) {
                return state.status != ProfileStatus.userLoaded
                    ? const ImageLoadingPlaceHolderWidget(
                        width: double.maxFinite,
                        height: 150,
                      )
                    : BuildBannerAndUserDescription(user: state.profileUser!);
              }),
            ),

            const SliverPadding(padding: EdgeInsets.all(8)),

            //? TABS WITH POSTS, BOOKS, VIDEOS
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    MyContainerButton(
                        text: "contents",
                        showShadow: false,
                        textColor: widget.shell.currentIndex == 0
                            ? Colors.white
                            : Colors.black.withOpacity(0.8),
                        buttonColor: widget.shell.currentIndex == 0
                            ? Colors.black.withOpacity(0.8)
                            : Colors.white,
                        onPressed: () {
                          print("current index ${widget.shell.currentIndex}");
                          if (widget.shell.currentIndex != 0) {
                            setState(() {
                              context.goNamed(AppRoutes.profile,
                                  queryParameters: {"user": widget.userId});
                            });
                          }
                        }),

                    //? Post
                    //! MyContainerButton(
                    //     text: "posts",
                    //     showShadow: false,
                    //     textColor: widget.shell.currentIndex == 1
                    //         ? Colors.white
                    //         : Colors.black.withOpacity(0.8),
                    //     buttonColor: widget.shell.currentIndex == 1
                    //         ? Colors.black.withOpacity(0.8)
                    //         : Colors.white,
                    //     onPressed: () {
                    //       print("current index ${widget.shell.currentIndex}");
                    //       if (widget.shell.currentIndex != 1) {
                    //         setState(() {
                    //           context.goNamed(AppRoutes.profilePost,
                    //               queryParameters: {"user": widget.userId});
                    //         });
                    //       }
                    //     }),

                    // const SizedBox(width: 10,)
                  ],
                ),
              ),
            ),

            //? Spacing from top
            const SliverPadding(padding: EdgeInsets.all(8)),

            //? SCROLLABLE LIST OF CONTENTS

            BlocBuilder<ContentCubit, ContentState>(builder: (conext, state) {
              if (widget.shell.currentIndex == 0) {
                if (state is ContentLoading) {
                  return const SliverToBoxAdapter(
                      child: MyCircularProgressIndicator());
                } else if (state.myContents != null &&
                    state.myContents!.isNotEmpty) {
                  final User user = context.read<AuthCubit>().state.user!;

                  return Builder(builder: (context) => buildListOfContents(context,
                      contents: state.myContents!,
                      itemCount: state.myContents!.length,
                      user: user));
                } else {
                  return const SliverToBoxAdapter(
                      child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text("No books yet"),
                  ));
                }
              } else {
                return SliverToBoxAdapter(child: Text("Post page"));
              }
              // return state is ContentLoading ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2,),) : widget.shell;
            })
          ],
        ),
      ),
    );
  }

  SliverList buildListOfContents(BuildContext context,
      {required List<Content> contents,
      required int itemCount,
      // required void Function() onDelete,
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
                      //? SHARE CONTENT
                      PopupMenuItem(
                        value: 'share',
                        onTap: () {
                          //TODO: HANDLE EDIT CONTENT
                          print("Share content pressed");
                          print("POST TAG LENGT ${content.tags}");

                          Share.share(
                              "${Uri.parse("${NetWorkConstants.baseShareUrl}/contents/${content.id}?nm=${content.title}")}");
                        },
                        child: Text('Share ${content.type}'),
                      ),
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

                          context.pushNamed(AppRoutes.writeBook,
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

                                          context.pop();

                                          delete(content.id);

                                          // deleteBook(content.id,
                                          //     context: context);
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
                      //? SHARE CONTENT
                      PopupMenuItem(
                        value: 'share',
                        onTap: () {
                          //TODO: HANDLE EDIT CONTENT
                          print("Share content pressed");
                          print("POST TAG LENGT ${content.tags}");

                          Share.share(
                              "${Uri.parse("${NetWorkConstants.baseShareUrl}/contents/${content.id}?nm=${content.title}")}");
                        },
                        child: Text('Share ${content.type}'),
                      ),

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

                context.pushNamed(AppRoutes.contentDescription,
                    pathParameters: {"id": content.id});
              },
              onMetaPressed: () {
                print('${content.title} meta pressed');
              },
            ),
          );
        });
  }

  Widget buildPopupMenuButton() {
    return BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, profileState) {
      // var profileState = context.watch<AuthState>();

      print("Profile state is $profileState");

      return profileState.status != ProfileStatus.userLoaded
          ? const SizedBox()
          : PopupMenuButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              itemBuilder: (context) {
                var list = [
                  //? Edit Profile
                  PopupMenuItem(
                    value: 'Edit',
                    child: Text("Edit profile",
                        style: Theme.of(context).textTheme.bodyMedium),
                    onTap: () => context.pushNamed(AppRoutes.editProfile),
                    //! avigator.pushNamed(
                    //     context, '/edit-profile-page'),
                  ),

                  //? Share Profile
                  PopupMenuItem(
                    value: 'Share',
                    child: Text("Share profile",
                        style: Theme.of(context).textTheme.bodyMedium),
                    onTap: () {
                      final User user = context.read<AuthCubit>().state.user!;

                      Share.share(
                          "${Uri.parse("${NetWorkConstants.baseShareUrl}/profile/${user.id}?nm=${user.firstName} ${user.lastName}")}");
                    },
                  ),

                  //? Verify Email
                  PopupMenuItem(
                    value: 'verify',
                    child: Text("Verify email",
                        style: Theme.of(context).textTheme.bodyMedium),
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
                                              BorderRadius.circular(16)),
                                      title: const Text("I have a code"),
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
                                        print("Don't generate new otp");

                                        AuthHelper.userMap["email"] = context
                                            .read<AuthCubit>()
                                            .state
                                            .user
                                            ?.email;

                                        //? navigate to emailVerificationPage
                                        context.pushNamed(
                                            AppRoutes.emailVerification);
                                      },
                                    ),
                                    ListTile(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(16)),
                                      title: const Text("Get new code"),
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

                                        AuthHelper.userMap["email"] = context
                                            .read<AuthCubit>()
                                            .state
                                            .user
                                            ?.email;

                                        //? send email otp
                                        widget.requestEmailOtp(
                                            context); //*_-------------------------------------

                                        //? navigate to emailVerificationPage
                                        context.pushNamed(
                                            AppRoutes.emailVerification);
                                      },
                                    ),
                                  ],
                                ));
                          });
                    },
                  ),
                ];

                if (profileState.profileUser?.emailVerified == true) {
                  list.removeLast();
                  return list;
                }
                if (profileState.profileUser?.emailVerified == false) {
                  list.removeAt(1);
                  return list;
                }

                return list;
              });
    });
  }
}

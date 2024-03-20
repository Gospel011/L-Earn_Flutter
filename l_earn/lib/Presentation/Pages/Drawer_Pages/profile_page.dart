import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:l_earn/BusinessLogic/AuthCubit/auth/auth_cubit.dart';
import 'package:l_earn/BusinessLogic/AuthCubit/auth/auth_state.dart';
import 'package:l_earn/BusinessLogic/ProfileCubit/profile_cubit.dart';

import 'package:l_earn/BusinessLogic/contentCubit/content_cubit.dart';
import 'package:l_earn/DataLayer/Models/content_model.dart';
import 'package:l_earn/DataLayer/Models/user_model.dart';
import 'package:l_earn/Helpers/auth_helper.dart';
import 'package:l_earn/Presentation/components/build_banner_and_user_description.dart';
import 'package:l_earn/Presentation/components/my_circularProgressIndicator.dart';
import 'package:l_earn/Presentation/components/my_circular_progress_indicator.dart';
import 'package:l_earn/Presentation/components/my_content_widget.dart';
import 'package:l_earn/Presentation/components/my_dialog.dart';
import 'package:l_earn/Presentation/components/my_image_loading_placeholder_widget.dart';

import 'package:l_earn/Presentation/components/my_text_button.dart';
import 'package:l_earn/Presentation/components/my_container_button.dart';
import 'package:l_earn/BusinessLogic/tabCubit/tab_cubit.dart';

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

    widget.loadContents(context, userId: widget.userId);

    context.read<ProfileCubit>().getUserById(
        context.read<AuthCubit>().state.user?.token, widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ContentCubit, ContentState>(
          listener: (context, state) {
            print('STATE IS $state');

            if (state is RequestingContentById) {
              showDialog(
                  context: context,
                  builder: (context) => const Center(
                      child:
                          CircularProgressIndicator(color: Colors.blueGrey)));
            } else if (state is ContentLoadingFailed ||
                state is ContentNotFound) {
              var content = state.error!.content;

              if (state.error!.content == 'Invalid  "content" id') {
                content = 'No content was found';
              }
              showDialog(
                  context: context,
                  builder: ((context) =>
                      MyDialog(title: state.error!.title, content: content)));
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
              widget.loadContents(context, userId: widget.userId);
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

                  return widget.buildListOfContents(context,
                      contents: state.myContents!,
                      itemCount: state.myContents!.length,
                      user: user);
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
                      Share.share(
                          "${NetWorkConstants.baseShareUrl}/profile/${context.read<AuthCubit>().state.user!.id}");
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

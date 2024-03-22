import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:l_earn/BusinessLogic/AuthCubit/auth/auth_cubit.dart';

import 'package:l_earn/BusinessLogic/AuthCubit/follow/follow_cubit.dart';
import 'package:l_earn/BusinessLogic/PostCubit/post_cubit.dart';
import 'package:l_earn/BusinessLogic/contentCubit/content_cubit.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:l_earn/DataLayer/Models/user_model.dart';
import 'package:l_earn/Presentation/components/my_image_widget.dart';
import 'package:l_earn/Presentation/components/my_profile_picture.dart';
import 'package:l_earn/Presentation/components/follower_count_widget.dart';
import 'package:l_earn/Presentation/components/render_user_name.dart';
import 'package:l_earn/Presentation/components/my_container_button.dart';
import 'package:l_earn/utils/colors.dart';
import 'package:l_earn/utils/constants.dart';

import 'package:flutter_animate/flutter_animate.dart';

class BuildBannerAndUserDescription extends StatefulWidget {
  const BuildBannerAndUserDescription({
    super.key,
    required this.user,
  });

  final User user;

  @override
  State<BuildBannerAndUserDescription> createState() =>
      _BuildBannerAndUserDescriptionState();
}

class _BuildBannerAndUserDescriptionState
    extends State<BuildBannerAndUserDescription> {
  late User newUser;
  @override
  void initState() {
    super.initState();
    newUser = widget.user;

    context.read<FollowCubit>().getFollowStatus(
        context.read<AuthCubit>().state.user?.token, widget.user.id!);
  }

  void followUser() {
    context.read<FollowCubit>().followUser(
        context.read<AuthCubit>().state.user?.token, widget.user.id!);
  }

  @override
  Widget build(BuildContext context) {
    print(
        ":::: U S E R   F R O M   B A N N E R A N D D E S C R I P T I O N   I S   ${widget.user}");
    return BlocListener<FollowCubit, FollowState>(
      listener: (context, state) {
        if (state is UserFollowed) {
          if (state.followed == true) {
            newUser = newUser.copyWith(followers: newUser.followers + 1);
          } else {
            newUser = newUser.copyWith(followers: newUser.followers - 1);
          }

          //* Update all contents and posts followers to reflect the follow change
          context.read<ContentCubit>().updateContentAuthor(newUser);
          context.read<PostCubit>().updatePostAuthor(newUser);
        }
      },
      child: Column(
        children: [
          //? BANNER
          SizedBox(
              width: double.maxFinite,
              height: 150,
              child: MyImageWidget(
                image: widget.user.banner ?? 'default.png',
                boxfit: BoxFit.cover,
                borderRadius: 0,
              )),

          const SizedBox(height: 8),

          //? PROFILE PICTURE | MINI DESCRIPTION
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              //* PROFILE PICTURE
              MyProfilePicture(user: widget.user, radius: 32, tappable: true,),

              const SizedBox(
                width: 4,
              ),

              //* MINI DESCRIPTION
              Expanded(
                  child: Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //? username
                          widget.user.id ==
                                  context.read<AuthCubit>().state.user?.id
                              ? RenderUserName(
                                  user: widget.user,
                                  fontWeight: FontWeight.bold,
                                )
                              : Row(children: [
                                  Expanded(
                                      child: Text(
                                          '${widget.user.firstName} ${widget.user.lastName}',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                                  fontWeight:
                                                      FontWeight.bold))),
                                  widget.user.isVerified == true
                                      ? Text(' ')
                                      : const SizedBox(),
                                  widget.user.isVerified == true
                                      ? AppIcons.verifiedIcon
                                      : const SizedBox(),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  BlocBuilder<FollowCubit, FollowState>(
                                      builder: (context, state) {
                                    Widget? followWidget;

                                    if (state is FollowInitial ||
                                        state is GettingFollowStatus) {
                                      followWidget = const SizedBox();
                                    } else {
                                      followWidget = state.followed == true
                                          ? PopupMenuButton(
                                              overlayColor: Colors.transparent,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8)),
                                              itemBuilder: (context) {
                                                return [
                                                  PopupMenuItem(
                                                      onTap: followUser,
                                                      child: const Text(
                                                          "unfollow"))
                                                ];
                                              },
                                              child: const Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text("\u2022 following"),
                                                  Icon(
                                                    Icons
                                                        .arrow_drop_down_rounded,
                                                    color: AppColor.textColor,
                                                  )
                                                ],
                                              ))
                                          : MyContainerButton(
                                              text: 'follow',
                                              onPressed: () {
                                                //  TODO: IMPLEMENT FOLLOW
                                                print(
                                                    'Follow button for ${widget.user.firstName} ${widget.user.lastName} ${widget.user.id} pressed');

                                                followUser();
                                              });
                                    }

                                    return followWidget;
                                  })
                                ]),

                          //? handle
                          Text(widget.user.handle!,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                      color: Colors.black.withOpacity(0.7))),

                          //? school
                          widget.user.school != null
                              ? Text(
                                  widget.user.school!,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                )
                              : const SizedBox(),

                          Row(children: [
                            //? department
                            widget.user.department != null
                                ? Expanded(
                                    child: Text(
                                    widget.user.department!,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ))
                                : const SizedBox(),

                            widget.user.level != null
                                ? const Text(' \u2022 ')
                                : const SizedBox(),
                            widget.user.level != null
                                ? Text('${widget.user.level} level')
                                : const SizedBox(),
                          ]),
                          
                          //? FOLLOW COUNT WIDGET
                          
                          BlocBuilder<FollowCubit, FollowState>(
                              builder: (context, state) {
                            int followerCount = widget.user.followers;
                            print("is userfollowed ${state is UserFollowed}");
                            if (state is UserFollowed) {
                              followerCount = newUser.followers;
                            }
                            return FollowerCountWidget(
                              followerCount: followerCount,
                            );
                          })


                        ],
                      )))
            ]),
          ),
        ],
      ),
    );
  }
}



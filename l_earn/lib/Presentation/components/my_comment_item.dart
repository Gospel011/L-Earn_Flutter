import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:l_earn/BusinessLogic/AuthCubit/auth/auth_cubit.dart';
import 'package:l_earn/BusinessLogic/likeCubit/like_cubit.dart';
import 'package:l_earn/DataLayer/Models/comment_model.dart';
import 'package:l_earn/Presentation/components/my_list_tile_widget.dart';
import 'package:l_earn/Presentation/components/my_profile_picture.dart';
import 'package:l_earn/utils/colors.dart';
import 'package:l_earn/utils/constants.dart';


class MyCommentItem extends StatelessWidget {
  const MyCommentItem(
      {super.key,
      required this.comment,
      required this.parentResourceId,
      required this.index});

  final Comment comment;
  final int index;
  final String parentResourceId;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //* profile picture
          MyProfilePicture(
            user: comment.user,
            radius: 12,
          ),

          //** COLUMN OF TAG AND POST
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                //? tag
                Row(
                  children: [
                    Text(
                      comment.user.handle!,
                      softWrap: true,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 14,
                          color: AppColor.textColor.withOpacity(0.8)),
                    ),
                    SizedBox(
                        height: 14,
                        child: comment.user.isVerified == true
                            ? AppIcons.verifiedIcon
                            : const SizedBox())
                  ],
                ),

                const SizedBox(
                  height: 2,
                ),

                //? comment
                Text(comment.comment,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontSize: 16, fontWeight: FontWeight.w500)),

                //? likes
                BlocProvider<LikeCubit>(
                  create: (context) => LikeCubit(comment.likes, comment.liked),
                  child: BlocBuilder<LikeCubit, LikeState>(
                      builder: (context, state) {
                    return MyListTileWidget(
                        title: state.liked == true
                            ? SizedBox(
                                height: 16,
                                child: AppIcons.likeSolidCompact,
                              )
                            : SizedBox(
                                height: 16,
                                child: AppIcons.likeCompact,
                              ),
                        subtitle: Text(
                          '${state.likes}',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(height: 0.8),
                        ),
                        onPressed: () {
                          print("Like pressed");

                          context.read<LikeCubit>().like(
                              context.read<AuthCubit>().state.user?.token,
                              comment.id,
                              "posts/$parentResourceId/comments/",
                              index);
                        });
                  }),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

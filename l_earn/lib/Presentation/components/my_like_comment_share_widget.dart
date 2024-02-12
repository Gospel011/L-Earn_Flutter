import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:l_earn/BusinessLogic/AuthCubit/auth/auth_cubit.dart';
import 'package:l_earn/BusinessLogic/likeCubit/like_cubit.dart';
import 'package:l_earn/DataLayer/Models/post_model.dart';
import 'package:l_earn/Presentation/components/my_list_tile_widget.dart';
import 'package:l_earn/utils/constants.dart';

class MyLikeCommentShareWidget extends StatelessWidget {
  const MyLikeCommentShareWidget({
    super.key,
    required this.post,
  });

  final Post post;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      //? LIKE
      BlocProvider<LikeCubit>(
        create: (context) => LikeCubit(post.likes, post.liked),
        child: BlocBuilder<LikeCubit, LikeState>(builder: (context, state) {
          return MyListTileWidget(
              title: state.liked ? AppIcons.liked : AppIcons.likeCompact,
              subtitle: Text('${state.likes}'),
              onPressed: () {
                //TODO: IMPLEMENT LIKING FUNCTIONALITY
                context
                    .read<LikeCubit>()
                    .like(context.read<AuthCubit>().state.user?.token, post.id, 'posts');
                print('like pressed');
              });
        }),
      ),

      const SizedBox(width: 10),

      //? COMMENT
      MyListTileWidget(
          title: AppIcons.comment,
          subtitle: Text('${post.comment.length}'),
          onPressed: () {
            //TODO: IMPLEMENT LIKING FUNCTIONALITY
            print('like pressed');
          }),

      const SizedBox(width: 10),

      //? SHARE
      MyListTileWidget(
          title: AppIcons.share,
          subtitle: Text('${post.shares}'),
          onPressed: () {
            //TODO: IMPLEMENT LIKING FUNCTIONALITY
            print('SHARE pressed');
          }),
    ]);
  }
}

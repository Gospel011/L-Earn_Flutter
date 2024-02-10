import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:l_earn/BusinessLogic/AuthCubit/auth/auth_cubit.dart';
import 'package:l_earn/BusinessLogic/AuthCubit/auth/auth_state.dart';
import 'package:l_earn/BusinessLogic/AuthCubit/pages/page_cubit.dart';
import 'package:l_earn/BusinessLogic/PostCubit/post_cubit.dart';
import 'package:l_earn/DataLayer/Models/post_model.dart';
import 'package:l_earn/Presentation/components/my_dialog.dart';
import 'package:l_earn/Presentation/components/my_profile_picture.dart';
import 'package:l_earn/utils/colors.dart';
import 'package:l_earn/utils/constants.dart';
import 'package:fl_chart/fl_chart.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<PostCubit, PostState>(
      listener: ((context, state) {
        if (state is NewPostsFailed) {
          showDialog(
              context: context,
              builder: (context) {
                return MyDialog(
                    title: state.error!.title, content: state.error!.content);
              });
        }
      }),
      child: Scaffold(
        body: BlocBuilder<PostCubit, PostState>(
          builder: (context, state) {
            return CustomScrollView(
              slivers: [
                //? TOP SPACING
                const SliverToBoxAdapter(
                  child: SizedBox(
                    height: 16,
                  ),
                ),

                //? SCROLLABLE LIST OF POSTS
                SliverList.builder(
                    itemCount: state.newPosts?.length ?? 0,
                    itemBuilder: (context, index) {
                      final Post post = state.newPosts![index];

                      return MyPostWidget(post: post);
                    }),

                SliverToBoxAdapter(
                    child: state is NewPostsLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                            color: Colors.blueGrey,
                          ))
                        : const SizedBox())
              ],
            );
          },
        ),
      ),
    );
  }
}

class MyPostWidget extends StatelessWidget {
  const MyPostWidget({
    super.key,
    required this.post,
  });

  final Post post;

  @override
  Widget build(BuildContext context) {
    final String fullName = '${post.user.firstName} ${post.user.lastName}';
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //? ROW WITH PROFILE PICTURE, NAME, HANDLE AND MORE ICON
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  //? PROFILE PICTURE
                  MyProfilePicture(
                    user: post.user,
                    radius: 24,
                  ),

                  const SizedBox(
                    width: 5,
                  ),

                  MyListTile(
                    children: [
                      //? FULL NAME
                      Text(
                        fullName,
                        textAlign: TextAlign.left,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),

                      //? HANDLE
                      Text(
                        post.user.handle ?? '',
                        textAlign: TextAlign.left,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColor.textColor.withOpacity(0.7)),
                      )
                    ],
                  ),
                ],
              ),

              //? MORE
              IconButton(
                  splashRadius: 30,
                  onPressed: () {
                    print("More Icon for $fullName pressed");
                  },
                  icon: const Icon(Icons.more_vert_outlined))
            ],
          ),

          //? TEXT
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: Text(post.text),
          ),

          //? [POLL -- > next launch] OR IMAGE
          // BarChart()
          post.image != null
              ? Container(
                  width: double.maxFinite,
                  constraints: const BoxConstraints(maxHeight: 500),
                  child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(16)),
                      child: Image.network(post.image!)))
              : const SizedBox(),

          //? LIKES COMMENTS SHARES
          MyLikeCommentShareWidget(post: post)
        ],
      ),
    );
  }
}

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
      MyListTileWidget(
          title: AppIcons.likeCompact,
          subtitle: Text('${post.likes}'),
          onPressed: () {
            //TODO: IMPLEMENT LIKING FUNCTIONALITY
            print('like pressed');
          }),

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

class MyListTile extends StatelessWidget {
  const MyListTile({
    super.key,
    required this.children,
  });

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children);
  }
}

class MyListTileWidget extends StatelessWidget {
  final Widget title;
  final Widget subtitle;
  final void Function()? onPressed;

  const MyListTileWidget(
      {super.key,
      required this.title,
      required this.subtitle,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      IconButton(
          padding: EdgeInsets.zero,
          onPressed: onPressed,
          visualDensity: VisualDensity.compact,
          isSelected: true,
          iconSize: 10,
          selectedIcon: AppIcons.likeSolidCompact,
          icon: title),
      subtitle
    ]);
  }
}

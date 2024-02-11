import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:l_earn/Presentation/components/my_circularProgressIndicator.dart';
import 'package:l_earn/Presentation/components/my_post_widget.dart';

import '../../../BusinessLogic/PostCubit/post_cubit.dart';
import '../../../DataLayer/Models/post_model.dart';
import '../../components/my_dialog.dart';



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
                        ? const MyCircularProgressIndicator()
                        : const SizedBox())
              ],
            );
          },
        ),
      ),
    );
  }
}



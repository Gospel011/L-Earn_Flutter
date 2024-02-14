import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:l_earn/BusinessLogic/AuthCubit/auth/auth_cubit.dart';
import 'package:l_earn/BusinessLogic/AuthCubit/auth/auth_state.dart';
import 'package:l_earn/BusinessLogic/AuthCubit/pages/page_cubit.dart';
import 'package:l_earn/BusinessLogic/PostCubit/post_cubit.dart';
import 'package:l_earn/BusinessLogic/learnCubit/content_cubit.dart';
import 'package:l_earn/DataLayer/Models/user_model.dart';
import 'package:l_earn/Presentation/Pages/Home_Pages/events_page.dart';
import 'package:l_earn/Presentation/Pages/Home_Pages/home.dart';
import 'package:l_earn/Presentation/Pages/Home_Pages/learn_page.dart';
import 'package:l_earn/Presentation/Pages/Home_Pages/profile_page.dart';
import 'package:l_earn/Presentation/components/my_bottom_app_bar_item.dart';
import 'package:l_earn/Presentation/components/my_drawer.dart';
import 'package:l_earn/Presentation/components/my_profile_picture.dart';
import 'package:l_earn/utils/constants.dart';

import 'package:l_earn/utils/mixins.dart';

class HomePage extends StatelessWidget with AppBarMixin {
  HomePage({super.key});

  final List<Widget> pages = [
    const Home(),
    const SizedBox(),
    const LearnPage(),
    // const EventsPage(),
    // const ProfilePage()
  ];

  // pagesTitles = ['Home', 'Learn', 'Post', 'Events', "Profile"];
  late final List<String> pagesTitle = [
    'Home',
    'Post',
    'Learn'
  ]; //, 'Events', "Profile"];

  late final List<Widget> pageIconsFill = [
    AppIcons.homeFill,
    AppIcons.post,
    AppIcons.learnFill,
    // AppIcons.eventsFill,
    // BlocBuilder<AuthCubit, AuthState>(builder: (context, state) {
    //   return state.user != null
    //       ? MyProfilePicture(
    //           user: state.user!,
    //           radius: 16,
    //           focus: true,
    //         )
    //       : const SizedBox();
    // })
  ];

  late final List<Widget> pageIconsThin = [
    AppIcons.homeThin,
    AppIcons.post,
    AppIcons.learnThin,
    // AppIcons.eventsThin,
    // BlocBuilder<AuthCubit, AuthState>(builder: (context, state) {
    //   return state.user != null
    //       ? MyProfilePicture(user: state.user!, radius: 16)
    //       : const SizedBox();
    // })
  ];

  @override
  Widget build(BuildContext context) {
    final User? user = context.read<AuthCubit>().state.user;

    context.read<PostCubit>().getNewPosts(user?.id, user?.token);
    context
        .read<ContentCubit>()
        .loadContents(context.read<AuthCubit>().state.user?.token);

    //* BLOC LISTENER
    return BlocListener<AuthCubit, AuthState>(
      listener: ((context, state) {
        if (state is AuthInitial) {
          Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
        }
      }),
      child: BlocProvider(
        create: (context) => PageCubit(),

        //* SCAFFOLD
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          bottomNavigationBar: BottomAppBar(child: Builder(builder: (context) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List<Widget>.generate(pageIconsFill.length, (index) {
                return buildBottomNavigationBar(index);
              }),
            );
          })),

          //* APP BAR
          appBar: buildAppBar(context, actions: [
            Builder(builder: (context) {
              return IconButton(
                  onPressed: () {
                    Scaffold.of(context).openEndDrawer();
                  },
                  icon: const SizedBox(height: 40, child: Icon(Icons.menu_rounded)));
            })
          ]),

          //* DRAWER
          endDrawer:
              BlocBuilder<AuthCubit, AuthState>(builder: (context, state) {
            return state.user != null
                ? MyDrawer(user: state.user!)
                : const SizedBox();
          }),

          //* BODY
          body: BlocBuilder<PageCubit, PageState>(
            builder: (context, state) {
              return pages[state.pageNo];
            },
          ),
        ),
      ),
    );
  }

  BlocBuilder<PageCubit, PageState> buildBottomNavigationBar(int index) {
    return BlocBuilder<PageCubit, PageState>(builder: (context, state) {
      print('Page state is ${state.pageNo}');
      return InkWell(
        // overlayColor: MaterialStatePropertyAll(Colors.transparent),
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          print('${pagesTitle[index]} page Pressed');
          if (index != 1) {
            context.read<PageCubit>().goToPage(index);
          } else {
            showModalBottomSheet(
                backgroundColor: const Color.fromARGB(0, 255, 193, 193),
                context: context,
                builder: (context) {
                  return MyBottomModalSheet(children: [
                    //* POST
                    ListTile(
                      onTap: () {
                        print("Make a post tapped");
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/make-post');
                      },
                      leading: AppIcons.write32,
                      title: const Text("Make a post"),
                    ),

                    //* CREATE A TUTORIAL
                    ListTile(
                      onTap: () {
                        print("Write a book tapped");
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/create-tutorial');
                      },
                      leading: AppIcons.learnFill,
                      title: const Text("Write a book"),
                    ),

                    //* CREATE AN EVENT
                    ListTile(
                      onTap: () {
                        print("Create a playlist tapped");
                        // Navigator.pushNamed(context, '/create-event');
                      },
                      leading: AppIcons.eventsFill,
                      title: const Text("Create a playlist"),
                    )
                  ]);
                });
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: MyBottomAppBarItem(
              icon: state.pageNo == index
                  ? pageIconsFill[index]
                  : pageIconsThin[index],
              text: pagesTitle[index]),
        ),
      );
    });
  }
}

class MyBottomModalSheet extends StatelessWidget {
  final List<Widget> children;
  const MyBottomModalSheet({super.key, required this.children, this.height});
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      height: height,
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadiusDirectional.only(
              topStart: Radius.circular(16), topEnd: Radius.circular(16))),
      // height: MediaQuery.of(context).size.height / 2.5,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: children,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:l_earn/BusinessLogic/AuthCubit/auth/auth_cubit.dart';
import 'package:l_earn/BusinessLogic/AuthCubit/pages/page_cubit.dart';
import 'package:l_earn/Presentation/Pages/Home_Pages/events_page.dart';
import 'package:l_earn/Presentation/Pages/Home_Pages/home.dart';
import 'package:l_earn/Presentation/Pages/Home_Pages/learn_page.dart';
import 'package:l_earn/Presentation/Pages/Home_Pages/profile_page.dart';
import 'package:l_earn/Presentation/components/my_bottom_app_bar_item.dart';
import 'package:l_earn/Presentation/components/my_drawer.dart';
import 'package:l_earn/Presentation/components/my_profile_picture.dart';
import 'package:l_earn/utils/constants.dart';

import 'package:l_earn/utils/mixins.dart';

class HomePage extends StatefulWidget with AppBarMixin {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final List<String> pagesTitles;
  late final List<Widget> pageIconsFill;
  late final List<Widget> pageIconsThin;
  final List<Widget> pages = [
    const Home(),
    const LearnPage(),
    const SizedBox(),
    const EventsPage(),
    const ProfilePage()
  ];

  @override
  void initState() {
    super.initState();
    pagesTitles = ['Home', 'Learn', 'Post', 'Events', "Profile"];

    pageIconsFill = [
      AppIcons.homeFill,
      AppIcons.learnFill,
      AppIcons.post,
      AppIcons.eventsFill,
      BlocBuilder<AuthCubit, AuthState>(builder: (context, state) {
        return state.user != null
            ? MyProfilePicture(
                user: state.user!,
                radius: 16,
                focus: true,
              )
            : const SizedBox();
      })
    ];

    pageIconsThin = [
      AppIcons.homeThin,
      AppIcons.learnThin,
      AppIcons.post,
      AppIcons.eventsThin,
      BlocBuilder<AuthCubit, AuthState>(builder: (context, state) {
        return state.user != null
            ? MyProfilePicture(user: state.user!, radius: 16)
            : const SizedBox();
      })
    ];
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: ((context, state) {
        if (state is AuthInitial) {
          Navigator.pushNamedAndRemoveUntil(
              context, '/login', (route) => false);
        }
      }),
      child: BlocProvider(
        create: (context) => PageCubit(),
        child: Scaffold(
          bottomNavigationBar: BottomAppBar(
              child: Builder(builder: (context) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List<Widget>.generate(pageIconsFill.length, (index) {
                    return BlocBuilder<PageCubit, PageState>(
                        builder: (context, state) {
                      print('Page state is ${state.pageNo}');
                      return InkWell(
                        
                        // overlayColor: MaterialStatePropertyAll(Colors.transparent),
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          print('${pagesTitles[index]} page Pressed');
                          if (index != 2) {
                            context.read<PageCubit>().goToPage(index);
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          child: MyBottomAppBarItem(
                              icon: state.pageNo == index
                                  ? pageIconsFill[index]
                                  : pageIconsThin[index],
                              text: pagesTitles[index]),
                        ),
                      );
                    });
                  }),
                );
              })),
          appBar: widget.buildAppBar(context, actions: [
            Builder(builder: (context) {
              return IconButton(
                  onPressed: () {
                    Scaffold.of(context).openEndDrawer();
                  },
                  icon: const Icon(Icons.menu_rounded));
            })
          ]),
          endDrawer:
              BlocBuilder<AuthCubit, AuthState>(builder: (context, state) {
            return state.user != null
                ? MyDrawer(user: state.user!)
                : const SizedBox();
          }),
          body: BlocBuilder<PageCubit, PageState>(
            builder: (context, state) {
              return pages[state.pageNo];
            },
          ),
        ),
      ),
    );
  }
}

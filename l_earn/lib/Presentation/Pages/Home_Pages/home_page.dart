import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:l_earn/BusinessLogic/AuthCubit/auth/auth_cubit.dart';
import 'package:l_earn/BusinessLogic/AuthCubit/auth/auth_state.dart';
import 'package:l_earn/BusinessLogic/AuthCubit/pages/page_cubit.dart';
import 'package:l_earn/BusinessLogic/PostCubit/post_cubit.dart';
import 'package:l_earn/BusinessLogic/contentCubit/content_cubit.dart';

import 'package:l_earn/DataLayer/Models/user_model.dart';

import 'package:l_earn/Presentation/Pages/Home_Pages/home.dart';
import 'package:l_earn/Presentation/Pages/Home_Pages/learn_page.dart';

import 'package:l_earn/Presentation/components/my_bottom_app_bar_item.dart';
import 'package:l_earn/Presentation/components/my_bottom_modal_sheet.dart';
import 'package:l_earn/Presentation/components/my_drawer.dart';

import 'package:l_earn/utils/constants.dart';
import 'package:go_router/go_router.dart';

import 'package:l_earn/utils/mixins.dart';
import 'dart:io';
import 'dart:async';
import 'package:app_links/app_links.dart';

class HomePage extends StatefulWidget with AppBarMixin {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Widget> pages = [
    const Home(),
    const SizedBox(),
    const LearnPage(),
    // const EventsPage(),
    // const ProfilePage()
  ];

  // pagesTitles = ['Home', 'Learn', 'Post', 'Events', "Profile"];
  late final List<String> pagesTitle = ['Home', 'Post', 'Learn'];
  //, 'Events', "Profile"];
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
  void initState() {
    super.initState();

    user = context.read<AuthCubit>().state.user;

    context.read<PostCubit>().getNewPosts(user?.id, user?.token);

    context
        .read<ContentCubit>()
        .loadContents(context.read<AuthCubit>().state.user?.token);

    initAppLinks();
  }

  late final User? user;
  bool canPop = false;

  final _appLinks = AppLinks();
  StreamSubscription? linkSubscription;
  Future<void> initAppLinks() async {

// Get the initial/first link.
// This is useful when app was terminated (i.e. not started)

    final uri = await _appLinks.getInitialAppLink();
// Do something (navigation, ...)

    print("Initial Applink Uri: $uri");

    handleUri(uri);

// Subscribe to further events when app is started.
// (Use stringLinkStream to get it as [String])
    linkSubscription = _appLinks.uriLinkStream.listen((uri) {
      // Do something (navigation, ...)
      print("Applink from stream Uri: $uri");

      handleUri(uri);

      print("::: Q U E R Y   P A R A M E T E R S : ${uri.queryParameters}");
    });

// Maybe later. Get the latest link.
// final uri = await _appLinks.getLatestAppLink();
// print("Applink from getLatestAppLink Uri: $uri");
  }

  void handleUri(Uri? uri) {
    
    if (uri != null) {
      // if (uri.path.contains('profile')) {
        print(":::::::::::::::::::::::::::::::::::::::::::::::::::::::::");
        //? [/profile/65b180c437c3742ad28bc4ce]

        String endpoint = uri.path.split("https://l-earn.onrender.com")[0];

        String path = endpoint.split('/')[1];
        String id = endpoint.split('/')[2];

        print("endpoint $endpoint, path $path, id: $id");

        switch (path) {
          case 'profile':
            context.goNamed(AppRoutes.profile, queryParameters: {"user": id});
            break;
          case 'posts':
            // context.goNamed(AppRoutes.post, queryParameters: {"user": id});
            break;
          case 'contents':
            print("contents");
            context.goNamed(AppRoutes.contentDescription, pathParameters: {"id": id});
            break;

        }

        print("endpoint: $endpoint, path: $path, id: $id");

        // if(path == 'profile') {

        //
        // }
      // }
    }
  }

  @override
  Widget build(BuildContext context) {
    //* BLOC LISTENER

    return BlocListener<AuthCubit, AuthState>(
      listener: ((context, state) {
        if (state is AuthInitial) {
          //! avigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
          context.goNamed(AppRoutes.login);
        }
      }),
      child: BlocProvider(
        create: (context) => PageCubit(),
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
          appBar: widget.buildAppBar(context, actions: [
            Builder(builder: (context) {
              return IconButton(
                  onPressed: () {
                    Scaffold.of(context).openEndDrawer();
                  },
                  icon: const SizedBox(
                      height: 40, child: Icon(Icons.menu_rounded)));
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
                        //! avigator.pop(context);
                        context.pop();

                        //! avigator.pushNamed(context, '/make-post');
                        context.goNamed(AppRoutes.post);
                      },
                      leading: AppIcons.write32,
                      title: const Text("Make a post"),
                    ),

                    //* CREATE A TUTORIAL
                    ListTile(
                      onTap: () {
                        print("Write a book tapped");
                        //! avigator.pop(context);
                        context.pop();

                        //! avigator.pushNamed(context, '/create-tutorial');

                        context.goNamed(AppRoutes.createTutorial);
                      },
                      leading: SizedBox(
                          height: 32, width: 32, child: AppIcons.learnFill),
                      title: const Text("Create content"),
                    ),

                    //* CREATE AN EVENT
                    // ListTile(
                    //   onTap: () {
                    //     print("Create a playlist tapped");
                    //     //! avigator.pushNamed(context, '/create-event');
                    //   },
                    //   leading: AppIcons.learnFill,
                    //   title: const Text("Create a playlist"),
                    // )
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

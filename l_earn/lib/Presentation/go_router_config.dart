import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:l_earn/BusinessLogic/AuthCubit/auth/auth_cubit.dart';
import 'package:l_earn/BusinessLogic/AuthCubit/auth/auth_state.dart';
import 'package:l_earn/BusinessLogic/AuthCubit/follow/follow_cubit.dart';
import 'package:l_earn/BusinessLogic/AuthCubit/timer/timer_cubit.dart';
import 'package:l_earn/BusinessLogic/AuthCubit/verification/verification_cubit.dart';
import 'package:l_earn/BusinessLogic/PostCubit/post_cubit.dart';
import 'package:l_earn/BusinessLogic/ProfileCubit/profile_cubit.dart';
import 'package:l_earn/BusinessLogic/commentCubit/comment_cubit.dart';
import 'package:l_earn/BusinessLogic/contentCubit/content_cubit.dart';
import 'package:l_earn/BusinessLogic/paymentCubit/payment_cubit.dart';
import 'package:l_earn/BusinessLogic/tabCubit/tab_cubit.dart';
import 'package:l_earn/DataLayer/Models/content_model.dart';
import 'package:l_earn/DataLayer/Models/invoice_model.dart';
import 'package:l_earn/DataLayer/Models/user_model.dart';
import 'package:l_earn/Presentation/Pages/Auth_Pages/emailVerification_page.dart';
import 'package:l_earn/Presentation/Pages/Auth_Pages/forgot_password_page.dart';
import 'package:l_earn/Presentation/Pages/Auth_Pages/login_page.dart';
import 'package:l_earn/Presentation/Pages/Auth_Pages/reset_password_page.dart';
import 'package:l_earn/Presentation/Pages/Auth_Pages/signup_page.dart';
import 'package:l_earn/Presentation/Pages/Drawer_Pages/payment_history_page.dart';
import 'package:l_earn/Presentation/Pages/Drawer_Pages/profile_page.dart';
import 'package:l_earn/Presentation/Pages/Drawer_Pages/tutors_profile.dart';
import 'package:l_earn/Presentation/Pages/Home_Pages/Content_Pages/Write_A_Book/write_a_book_page.dart';
import 'package:l_earn/Presentation/Pages/Home_Pages/Content_Pages/chapter_page.dart';
import 'package:l_earn/Presentation/Pages/Home_Pages/Content_Pages/content_description_page.dart';
import 'package:l_earn/Presentation/Pages/Home_Pages/Content_Pages/content_shell.dart';
import 'package:l_earn/Presentation/Pages/Home_Pages/Post_Action_Pages/create_an_event_page.dart';
import 'package:l_earn/Presentation/Pages/Home_Pages/Post_Action_Pages/create_tutorial_page.dart';
import 'package:l_earn/Presentation/Pages/Home_Pages/Post_Action_Pages/normal_post_page.dart';
import 'package:l_earn/Presentation/Pages/Home_Pages/expanded_post_page.dart';
import 'package:l_earn/Presentation/Pages/Home_Pages/home_page.dart';
import 'package:l_earn/Presentation/Pages/Payment_Page/payment_details.dart';
import 'package:l_earn/Presentation/Pages/Payment_Page/payment_page.dart';
import 'package:l_earn/Presentation/Pages/Profile_Pages/edit_profile_page.dart';
import 'package:l_earn/Presentation/Pages/Utility_Pages/image_view_page.dart';
import 'package:l_earn/utils/constants.dart';

class GoRouterConfig {
  GoRouterConfig({required this.authCubit});
  final AuthCubit authCubit;

  final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>();
  final TimerCubit _timerCubit = TimerCubit();
  final VerificationCubit _verificationCubit = VerificationCubit();
  final PostCubit postCubit = PostCubit();
  final CommentCubit commentCubit = CommentCubit();
  final ContentCubit contentCubit = ContentCubit();
  final ContentCubit contentCubit2 = ContentCubit();
  final PaymentCubit paymentCubit = PaymentCubit();

  GoRouter get router => GoRouter(
      navigatorKey: _rootNavigatorKey,
      initialLocation: '/login',
      routes: [
        //* HOME ROUTES
        GoRoute(
            //?__
            name: AppRoutes.home,
            path: '/home',
            builder: (context, state) {
              print("${AppRoutes.home} from go_router");
              return MultiBlocProvider(providers: [
                BlocProvider.value(value: postCubit),
                BlocProvider.value(value: contentCubit)
              ], child: HomePage());
            },
            routes: [
              //? Expanded Post Page
              GoRoute(
                name: AppRoutes.expandedPost,
                path: "expanded-post",
                builder: (context, state) {
                  print("${AppRoutes.expandedPost} from go_router");
                  return BlocProvider<PostCubit>(
                      create: (context) => PostCubit(), child: ExpandedPostPage(id: state.pathParameters["id"]!));
                },
              ),

              //? PROFILE PAGE ROUTE
              StatefulShellRoute.indexedStack(
                  builder: (context, state, shell) {
                    print("${AppRoutes.profile} from go_router");
                    return MultiBlocProvider(
                        providers: [
                          BlocProvider<TabCubit>(
                              create: (context) => TabCubit()),
                          BlocProvider.value(value: contentCubit),
                          BlocProvider.value(value: postCubit),
                          BlocProvider.value(value: _verificationCubit),
                          BlocProvider<ProfileCubit>(
                              create: (context) => ProfileCubit()),
                          BlocProvider<FollowCubit>(
                              create: (context) => FollowCubit()),
                          // BlocProvider<ContentCubit>(create: (context) => ContentCubit()),
                        ],
                        child: ProfilePage(
                            userId: state.uri.queryParameters['user']!,
                            shell: shell));
                  },
                  branches: [
                    //? PROFILE
                    StatefulShellBranch(routes: [
                      GoRoute(
                          path: "profile",
                          name: AppRoutes.profile,
                          builder: (context, state) {
                            print("\n\n\n\n");
                            print("Returning Contents Shell _________------");
                            print("\n\n\n\n");
                            return BlocProvider.value(
                              value: contentCubit,
                              child: const ContentsShell());

                            ///*uuuuuu
                          },
                          routes: [
                            //? EMAIL VERIFICATION ROUTE
                            GoRoute(
                                parentNavigatorKey: _rootNavigatorKey,
                                name: AppRoutes.emailVerification,
                                path: 'email-verification',
                                builder: (context, state) {
                                  print(
                                      "${AppRoutes.emailVerification} from go_router");
                                  return MultiBlocProvider(
                                    providers: [
                                      BlocProvider.value(
                                        value: _timerCubit,
                                      ),
                                      BlocProvider.value(
                                        value: _verificationCubit,
                                      ),
                                    ],
                                    child: EmailVerificationPage(),
                                  );
                                }),

                            //? EDIT PROFILE ROUTE
                            GoRoute(
                                parentNavigatorKey: _rootNavigatorKey,
                                name: AppRoutes.editProfile,
                                path: 'edit-profile',
                                builder: (context, state) {
                                  print(
                                      "${AppRoutes.editProfile} from go_router");
                                  return const EditProfilePage();
                                })
                          ])
                    ]),

                    StatefulShellBranch(routes: [
                      GoRoute(
                          path: 'profile/posts',
                          name: AppRoutes.profilePost,
                          builder: (context, state) {
                            return Center(
                              child: Text("Post page"),
                            );
                          })
                    ])
                  ]), // end of profile page routes

              //? TUTOR'S DASHBOARD
              GoRoute(
                  name: AppRoutes.tutorsDashboard,
                  path: 'tutors-dashboard',
                  builder: (context, state) {
                    print("${AppRoutes.tutorsDashboard} from go_router");
                    return BlocProvider.value(
                      value: paymentCubit,
                      child: const TutorsProfilePage(),
                    );
                  }),

              //? PAYMENT HISTORY
              GoRoute(
                  name: AppRoutes.paymentHistory,
                  path: 'payment-history',
                  builder: (context, state) {
                    print("${AppRoutes.paymentHistory} from go_router");
                    return BlocProvider.value(
                        value: paymentCubit, child: const PaymentHistoryPage());
                  },
                  routes: [
                    GoRoute(
                        name: AppRoutes.paymentDetails,
                        path: 'payment-details',
                        builder: (context, state) {
                          return PaymentDetailsPage(
                            invoice: state.extra
                                as Invoice, //! provide extra as [Invoice]
                          );
                        })
                  ]),

              //? MAKE POST PAGE
              GoRoute(
                  name: AppRoutes.post,
                  path: 'make-post',
                  builder: (context, state) {
                    print("${AppRoutes.post} from go_router");
                    return BlocProvider.value(
                        value: postCubit, child: const MakePostPage());
                  }),

              //? CREATE TUTORIAL PAGE
              GoRoute(
                  name: AppRoutes.createTutorial,
                  path: 'create-tutorial',
                  builder: (context, state) {
                    print("${AppRoutes.createTutorial} from go_router");
                    Map<String, dynamic>? args;
                    try {
                      args = state.extra as Map<String,
                          dynamic>?; //! provide extra as [Map<String, dynamic>]
                    } catch (e) {
                      print(e);
                    }
                    // {
                    //                                       'title': content.title,
                    //                                       'description': content.description,
                    //                                       'price': content.price,
                    //                                       'genre': content.tags?.join(','),
                    //                                       'thumbnailUrl': content.thumbnailUrl
                    //                                     }

                    return BlocProvider.value(
                        value: contentCubit,
                        child: CreateTutorialPage(
                          title: args?['title'] ?? '',
                          description: args?['description'] ?? '',
                          price: args?['price'].toString() ?? '',
                          genre: args?['genre'] ?? '',
                          thumbnailUrl: args?['thumbnailUrl'],
                          bookId: args?['id'],
                        ));
                  }),

              //? CONTENT DESCRIPTION ROUTE
              GoRoute(
                  name: AppRoutes.contentDescription,
                  path: 'content-description/:id',
                  builder: (context, state) {
                    return MultiBlocProvider(
                      providers: [
                        BlocProvider.value(value: contentCubit2),
                        // BlocProvider<ContentCubit>(
                        //   create: (context) => ContentCubit()
                        // ),
                        BlocProvider.value(value: paymentCubit)
                      ],
                      child: ContentDescriptionPage(
                        contentId: state.pathParameters[
                            "id"]!, //! provide path parameter as [String]
                      ),
                    );
                  },
                  routes: [
                    //? CHAPTER PAGE
                    GoRoute(
                        name: AppRoutes.chapterPage,
                        path: 'chapter-page',
                        builder: (context, state) {
                          return MultiBlocProvider(providers: [
                            BlocProvider.value(value: contentCubit2),
                            BlocProvider.value(value: postCubit),
                            BlocProvider<FollowCubit>(
                                create: (context) => FollowCubit()),
                          ], child: const ChapterPage());
                        })
                  ]), // end of content description

              //? WRITE BOOK PAGE
              GoRoute(
                  name: AppRoutes.writeBook,
                  path: 'write-book-page',
                  builder: (context, state) {
                    final args =
                        state.extra as Map? ?? {}; //! provide extra as [Map?]
                    return MultiBlocProvider(
                      providers: [
                        BlocProvider.value(value: contentCubit),
                        BlocProvider<FollowCubit>(
                            create: (context) => FollowCubit()),
                      ],
                      child: WriteABookPage(
                          content: args['content'],
                          chapterId: args['chapterId']),
                    );
                  }),

              //? CREATE EVENT PAGE
              GoRoute(
                  name: AppRoutes.createEvent,
                  path: 'create-event',
                  builder: (context, state) {
                    return const CreateEventPage();
                  })
            ]), // end of home routes

        //* PAYMENT ROUTE
        GoRoute(
            name: AppRoutes.payment,
            path: '/payment',
            builder: (context, state) {
              return BlocProvider.value(
                  value: paymentCubit,
                  child: PaymentPage(
                    content: state.extra as Content, //! provide extra [Content]
                  ));
            }),

        //* IMAGE VIEW ROUTE
        GoRoute(
            name: AppRoutes.imageView,
            path: '/image/:imageUrl',
            builder: (context, state) {
              return ImageViewPage(
                image: state.pathParameters['imageUrl']
                    as String, //! provide path parameter [imageUrl] as a [String]
              );
            }),

        //* AUTH ROUTES
        GoRoute(
            name: AppRoutes.login,
            path: '/login',
            builder: (context, state) {
              print("${AppRoutes.login} from go_router");
              return const LoginPage();
            },
            routes: [
              //?__ SIGNUP
              GoRoute(
                  name: AppRoutes.signup,
                  path: 'signup',
                  builder: (context, state) {
                    print("${AppRoutes.signup} from go_router");
                    return MultiBlocProvider(
                      providers: [
                        BlocProvider.value(
                          value: _timerCubit,
                        ),
                        BlocProvider.value(
                          value: _verificationCubit,
                        ),
                      ],
                      child: const SignupPage(),
                    );
                  }),

              //?__ fORGOT PASSWORD
              GoRoute(
                  name: AppRoutes.forgotPassword,
                  path: 'forgot-password',
                  builder: (context, state) {
                    print("${AppRoutes.forgotPassword} from go_router");
                    return BlocProvider.value(
                      value: _timerCubit,
                      child: const ForgotPasswordPage(),
                    );
                  },
                  routes: [
                    //? RESET PASSWORD
                    GoRoute(
                        name: AppRoutes.resetPassword,
                        path: 'reset-password',
                        builder: (context, state) {
                          print("${AppRoutes.resetPassword} from go_router");

                          return BlocProvider.value(
                            value: _timerCubit,
                            child: ResetPasswordPage(),
                          );
                        })
                  ]),
            ])
      ],
      redirect: (context, state) {
        print(
            "CURRENT LOCATION ${state.matchedLocation}, Logged in?: ${authCubit.state.user != null}");

        final bool isLoggedIn = authCubit.state.user != null;
        final String currentLocation = state.matchedLocation;

        if (isLoggedIn && currentLocation == '/login') {
          return '/home';
        }

        return null;
      });
}

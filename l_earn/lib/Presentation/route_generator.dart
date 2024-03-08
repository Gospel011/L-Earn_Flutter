import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:l_earn/BusinessLogic/AuthCubit/follow/follow_cubit.dart';
import 'package:l_earn/BusinessLogic/AuthCubit/timer/timer_cubit.dart';
import 'package:l_earn/BusinessLogic/AuthCubit/verification/verification_cubit.dart';
import 'package:l_earn/BusinessLogic/PostCubit/post_cubit.dart';
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
import 'package:l_earn/Presentation/Pages/Home_Pages/Content_Pages/Write_A_Book/create_a_chapter.dart';
import 'package:l_earn/Presentation/Pages/Home_Pages/Content_Pages/Write_A_Book/write_a_book_page.dart';
import 'package:l_earn/Presentation/Pages/Home_Pages/Content_Pages/chapter_page.dart';

import 'package:l_earn/Presentation/Pages/Home_Pages/Content_Pages/content_description_page.dart';
import 'package:l_earn/Presentation/Pages/Home_Pages/Post_Action_Pages/create_an_event_page.dart';
import 'package:l_earn/Presentation/Pages/Home_Pages/Post_Action_Pages/create_tutorial_page.dart';
import 'package:l_earn/Presentation/Pages/Home_Pages/Post_Action_Pages/normal_post_page.dart';

import 'package:l_earn/Presentation/Pages/Home_Pages/home_page.dart';
import 'package:l_earn/Presentation/Pages/Payment_Page/payment_details.dart';
import 'package:l_earn/Presentation/Pages/Payment_Page/payment_page.dart';
import 'package:l_earn/Presentation/Pages/Profile_Pages/edit_profile_page.dart';
import 'package:l_earn/Presentation/Pages/Utility_Pages/image_view_page.dart';
import 'package:l_earn/Presentation/Pages/error_page.dart';

class RouteGenerator {
  static final TimerCubit _timerCubit = TimerCubit();
  static final VerificationCubit _verificationCubit = VerificationCubit();
  static final PostCubit postCubit = PostCubit();
  static final CommentCubit commentCubit = CommentCubit();
  static final ContentCubit contentCubit = ContentCubit();
  static final PaymentCubit paymentCubit = PaymentCubit();

  Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    print('SETTING = $settings');
    switch (settings.name) {
      //? LOGIN PAGE
      case '/':
        return MaterialPageRoute(builder: (_) {
          print('/login from route generator');
          return const LoginPage();
        });

      //? PAYMENT DETAILS PAGE
      case '/payment-details':
        return MaterialPageRoute(builder: (_) {
          print('/payment-details from route generator');
          return PaymentDetailsPage(
            invoice: settings.arguments as Invoice,
          );
        });

      //? TUTOR'S PROFILE PAGE
      case '/tutors-profile':
        return MaterialPageRoute(builder: (_) {
          print('/tutors-profile from route generator');
          return BlocProvider.value(
            value: paymentCubit,
            child: const TutorsProfilePage(),
          );
        });

      //? PAYMENT PAGE
      case '/payment-page':
        return MaterialPageRoute(builder: (_) {
          print('/payment-page from route generator');
          return BlocProvider.value(
              value: paymentCubit,
              child: PaymentPage(
                content: settings.arguments as Content,
              ));
        });

      //? PAYMENT PAGE
      case '/payment-history-page':
        return MaterialPageRoute(builder: (_) {
          print('/payment-history-page from route generator');
          return BlocProvider.value(
              value: paymentCubit, child: const PaymentHistoryPage());
        });

      //? MAKE A POST PAGE
      case '/make-post':
        return MaterialPageRoute(builder: (_) {
          print('${settings.name} from route generator');
          return BlocProvider.value(
              value: postCubit, child: const MakePostPage());
        });

      case '/create-tutorial':
        return MaterialPageRoute(builder: (_) {
          print('${settings.name} from route generator');
          Map<String, dynamic>? args;
          try {
            args = settings.arguments as Map<String, dynamic>?;
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
        });

      case '/create-event':
        return MaterialPageRoute(builder: (_) {
          print('/create-event from route generator');
          return const CreateEventPage();
        });

      case '/image-view-page':
        return MaterialPageRoute(builder: (_) {
          print('/image-view-page from route generator');
          return ImageViewPage(
            image: settings.arguments as String,
          );
        });

      case '/edit-profile-page':
        return MaterialPageRoute(builder: (_) {
          print('/edit-profile-page from route generator');

          return const EditProfilePage();
        });

      //? HOME PAGE
      case '/home':
        return MaterialPageRoute(builder: (context) {
          print('/home from route generator');
          return MultiBlocProvider(providers: [
            BlocProvider.value(value: postCubit),
            BlocProvider.value(value: contentCubit)
          ], child: HomePage());
        });

      case '/content-description':
        print('content-discription from route generator');
        return MaterialPageRoute(builder: (context) {
          return MultiBlocProvider(
            providers: [
              BlocProvider.value(value: contentCubit),
              BlocProvider.value(value: paymentCubit)
            ],
            child: ContentDescriptionPage(
              content: settings.arguments as Content,
            ),
          );
        });

      case '/chapter-page':
        print('chapter-page from route generator');
        return MaterialPageRoute(builder: (context) {
          return BlocProvider.value(
            value: contentCubit,
            child: const ChapterPage(),
          );
        });

      case '/write-book-page':
        print('chapter-page from route generator');
        return MaterialPageRoute(builder: (context) {
          final args = settings.arguments as Map? ?? {};
          return BlocProvider.value(
            value: contentCubit,
            child: WriteABookPage(
                content: args['content'], chapterId: args['chapterId']),
          );
        });

      // case '/write-a-book-page':
      //   print('write-a-book-page from route generator');

      //   final args = settings.arguments as Map? ?? {};
      //   return MaterialPageRoute(builder: (context) {
      //     return BlocProvider.value(
      //       value: contentCubit,
      //       child: WriteABookPage(
      //         content: args['content'],
      //         chapterId: args['chapterId']
      //       ),
      //     );
      //   });

      case '/profile-page':
        print('profile-page from route generator');
        return MaterialPageRoute(builder: (context) {
          return MultiBlocProvider(
              providers: [
                BlocProvider<TabCubit>(create: (context) => TabCubit()),
                BlocProvider.value(value: contentCubit),
                BlocProvider<FollowCubit>(create: (context) => FollowCubit()),
                // BlocProvider<ContentCubit>(create: (context) => ContentCubit()),
              ],
              
              child: ProfilePage(
                user: settings.arguments as User,
              ));
        });

      case '/create-a-chapter-page':
        print('create-a-chapter-page from route generator');
        return MaterialPageRoute(builder: (context) {
          return const CreateAChapterPage();
        });

      case '/forgot-password':
        return MaterialPageRoute(builder: (context) {
          print('/forgot-password from route generator');
          return BlocProvider.value(
            value: _timerCubit,
            child: const ForgotPasswordPage(),
          );
        });

      case '/reset-password':
        return MaterialPageRoute(builder: (context) {
          print('/home from route generator');
          return BlocProvider.value(
            value: _timerCubit,
            child: ResetPasswordPage(),
          );
        });

      //? SIGN UP PAGE
      case '/signup':
        return MaterialPageRoute(builder: (_) {
          print('/sign_up from route generator');
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
        });

      //? VERIFICATION
      case '/emailVerificationPage':
        return MaterialPageRoute(builder: (context) {
          print('/verification from route generator');
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
        });

      //! ERROR PAGE
      default:
        return MaterialPageRoute(builder: (context) => const ErrorPage());
    }
  }
}

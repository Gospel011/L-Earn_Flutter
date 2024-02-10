import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:l_earn/BusinessLogic/AuthCubit/timer/timer_cubit.dart';
import 'package:l_earn/BusinessLogic/AuthCubit/verification/verification_cubit.dart';
import 'package:l_earn/BusinessLogic/PostCubit/post_cubit.dart';
import 'package:l_earn/Presentation/Pages/Auth_Pages/emailVerification_page.dart';
import 'package:l_earn/Presentation/Pages/Auth_Pages/forgot_password_page.dart';
import 'package:l_earn/Presentation/Pages/Auth_Pages/login_page.dart';
import 'package:l_earn/Presentation/Pages/Auth_Pages/reset_password_page.dart';
import 'package:l_earn/Presentation/Pages/Auth_Pages/signup_page.dart';
import 'package:l_earn/Presentation/Pages/Home_Pages/Post_Action_Pages/create_an_event_page.dart';
import 'package:l_earn/Presentation/Pages/Home_Pages/Post_Action_Pages/create_tutorial_page.dart';
import 'package:l_earn/Presentation/Pages/Home_Pages/Post_Action_Pages/normal_post_page.dart';

import 'package:l_earn/Presentation/Pages/Home_Pages/home_page.dart';
import 'package:l_earn/Presentation/Pages/error_page.dart';

class RouteGenerator {
  static final TimerCubit _timerCubit = TimerCubit();
  static final VerificationCubit _verificationCubit = VerificationCubit();
  static final PostCubit postCubit = PostCubit();

  Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    print('SETTING = $settings');
    switch (settings.name) {

      //? LOGIN PAGE
      case '/':
        return MaterialPageRoute(builder: (_) {
          print('/login from route generator');
          return const LoginPage();
        });
      case '/make-post':
        return MaterialPageRoute(builder: (_) {
          print('${settings.name} from route generator');
          return BlocProvider.value(
            value: postCubit,
            child: const MakePostPage());
        });

      case '/create-tutorial':
        return MaterialPageRoute(builder: (_) {
          print('${settings.name} from route generator');
          return const CreateTutorialPage();
        });

      case '/create-event':
        return MaterialPageRoute(builder: (_) {
          print('/create-event from route generator');
          return const CreateEventPage();
        });

      //? HOME PAGE
      case '/home':
        return MaterialPageRoute(builder: (context) {
          print('/home from route generator');
          return BlocProvider.value(
            value: postCubit,
            child: HomePage());
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

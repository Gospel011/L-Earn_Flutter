import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:l_earn/BusinessLogic/AuthCubit/timer/timer_cubit.dart';
import 'package:l_earn/BusinessLogic/AuthCubit/verification/verification_cubit.dart';
import 'package:l_earn/Presentation/Pages/emailVerification_page.dart';

import 'package:l_earn/Presentation/Pages/Home_Pages/home_page.dart';
import 'package:l_earn/Presentation/Pages/login_page.dart';
import 'package:l_earn/Presentation/Pages/signup_page.dart';

class RouteGenerator {
  static TimerCubit timerCubit = TimerCubit();
  static VerificationCubit verificationCubit = VerificationCubit();

  Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      //? HOME PAGE
      case '/':
        return MaterialPageRoute(builder: (context) {
          print('/home from route generator');
          return HomePage();
        });

      //? LOGIN PAGE
      case '/login':
        return MaterialPageRoute(builder: (_) {
          print('/login from route generator');
          return const LoginPage();
        });

      //? SIGN UP PAGE
      case '/signup':
        return MaterialPageRoute(builder: (_) {
          print('/sign_up from route generator');
          return MultiBlocProvider(
            providers: [
              BlocProvider.value(
                value: timerCubit,
              ),
              BlocProvider.value(
                value: verificationCubit,
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
                value:  timerCubit,
              ),
              BlocProvider.value(
                value:  verificationCubit,
              ),
            ],
            child: EmailVerificationPage(),
          );
        });

      //! ERROR PAGE
      default:
        return MaterialPageRoute(builder: (_) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(child: Text("The page requested does not exit")),
          );
        });
    }
  }
}

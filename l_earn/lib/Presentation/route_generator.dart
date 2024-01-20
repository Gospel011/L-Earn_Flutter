import 'package:flutter/material.dart';
import 'package:l_earn/Presentation/Pages/emailVerification_page.dart';

import 'package:l_earn/Presentation/Pages/home_page.dart';
import 'package:l_earn/Presentation/Pages/login_page.dart';
import 'package:l_earn/Presentation/Pages/signup_page.dart';

class RouteGenerator {

  Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      //? HOME PAGE
      case '/':
        return MaterialPageRoute(builder: (context) {
          print('/home from route generator');
          return const HomePage();
        });

      //? LOGIN PAGE
      case '/login':
        return MaterialPageRoute(builder: (_) {
          print('/ from route generator');
          return const LoginPage();
        });

      //? SIGN UP PAGE
      case '/signup':
        return MaterialPageRoute(builder: (_) {
          print('/sign_up from route generator');
          return const SignupPage();
        });

      //? VERIFICATION
      case '/emailVerificationPage':
        return MaterialPageRoute(builder: (context) {
          print('/verification from route generator');
          return EmailVerificationPage();
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

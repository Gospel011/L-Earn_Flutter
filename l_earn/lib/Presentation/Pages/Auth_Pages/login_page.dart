import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:l_earn/BusinessLogic/AuthCubit/auth/auth_cubit.dart';
import 'package:l_earn/BusinessLogic/AuthCubit/auth/auth_state.dart';
import 'package:l_earn/Helpers/auth_helper.dart';

import 'package:l_earn/Presentation/components/Functions/validators.dart';
import 'package:l_earn/Presentation/components/my_dialog.dart';
import 'package:l_earn/Presentation/components/my_elevated_button.dart';
import 'package:l_earn/Presentation/components/my_text_button.dart';
import 'package:l_earn/Presentation/components/my_textformfield.dart';
import 'package:l_earn/utils/colors.dart';
import 'package:l_earn/utils/mixins.dart';

class LoginPage extends StatefulWidget with AppBarMixin {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _obscureText = true;

  
  @override
  Widget build(BuildContext context) {
    //? Update email controller
    _emailController.text =
        context.read<AuthCubit>().state.email ?? _emailController.text;
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        //* Navigate to home page if login is successful
        print('state in login page bloc listener is $state');
        if (state is AuthLoggedIn) {
          print("::: state is authlogged in :::");
          Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
        } else if (state is AuthSignedUp) {
          print("::: state is auth signed up :::");
          _emailController.text = state.email!;
        } else if (state is AuthFailed) {
          showDialog(
              context: context,
              builder: (context) {
                return MyDialog(
                    title: state.error!.title, content: state.error!.content);
              });
        }
      },
      child: Scaffold(
          appBar: widget.buildAppBar(context, title: 'L-EARN'),
          body: SingleChildScrollView(
            child: Center(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 56,
                    ),

                    //? LOCK ICON
                    const Icon(
                      Icons.lock,
                      size: 64,
                    ),

                    const SizedBox(
                      height: 16,
                    ),

                    //? LOGIN TEXT
                    Text(
                      'Login',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColor.textColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 20), //*32
                    ),

                    const SizedBox(
                      height: 42,
                    ),

                    //? EMAIL TEXT FIELD
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: MyTextFormField(
                        hintText: "Email",
                        controller: _emailController,
                        validator: emailValidator,
                      ),
                    ),

                    const SizedBox(
                      height: 16,
                    ),

                    //? PASSWORD TEXT FIELD
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: MyTextFormField(
                        hintText: "Password",
                        controller: _passwordController,
                        validator: passwordValidator,
                        obscureText: _obscureText,
                        suffixIcon: Icon(_obscureText == false
                            ? Icons.visibility
                            : Icons.visibility_off),
                        suffixOnpressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      ),
                    ),

                    //? FORGOT PASSWORD
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          MyTextButton(
                              text: 'Forgot password?',
                              textDecoration: TextDecoration.underline,
                              textcolor: AppColor.buttonTextBlue,
                              onPressed: () {
                                print('Forgot password button pressed');
                                Navigator.pushNamed(
                                    context, '/forgot-password');
                              })
                        ],
                      ),
                    ),

                    const SizedBox(
                      height: 48,
                    ),

                    //? LOGIN BUTTON

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: BlocBuilder<AuthCubit, AuthState>(
                          builder: (context, state) {
                        return MyElevatedButton(
                          text: 'Login',
                          loading: state is AuthLoggingIn,
                          onPressed: () {
                            //TODO --> IMPLEMENT LOGIN
                            print('LOGIN PRESSED');
                            final isValid = _formKey.currentState?.validate();

                            if (isValid == true) {
                              //? update AuthHelper.userMap to have email and password
                              AuthHelper.userMap["email"] =
                                  _emailController.text;
                              AuthHelper.userMap["password"] =
                                  _passwordController.text;

                              print(':::: LOGGING IN ::::');
                              //? TELL AUTHCUBIT TO LOG USER IN
                              context.read<AuthCubit>().login();
                            }
                          },
                        );
                      }),
                    ),

                    //* OR LOGIN WITH

                    //* LOGIN WITH GOOGLE

                    //? DON'T HAVE AN ACCOUNT? SIGNUP
                    const SizedBox(
                      height: 8,
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text("Don't have an account?"),
                          MyTextButton(
                              text: 'signup',
                              textcolor: AppColor.buttonTextBlue,
                              textDecoration: TextDecoration.underline,
                              onPressed: () {
                                //TODO --> NAVIGATE TO SIGNUP
                                print('Signup button pressed');
                                Navigator.pushNamed(context, '/signup');
                              })
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          )),
    );
  }
}

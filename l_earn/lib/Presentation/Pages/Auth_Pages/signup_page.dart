import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:l_earn/BusinessLogic/AuthCubit/auth/auth_cubit.dart';
import 'package:l_earn/BusinessLogic/AuthCubit/auth/auth_state.dart';
import 'package:l_earn/BusinessLogic/AuthCubit/timer/timer_cubit.dart';

import 'package:l_earn/BusinessLogic/AuthCubit/verification/verification_cubit.dart';
import 'package:l_earn/Helpers/auth_helper.dart';
import 'package:l_earn/Presentation/components/Functions/validators.dart';
import 'package:l_earn/Presentation/components/my_dialog.dart';
import 'package:l_earn/Presentation/components/my_elevated_button.dart';
import 'package:l_earn/Presentation/components/my_text_button.dart';
import 'package:l_earn/Presentation/components/my_textformfield.dart';
import 'package:l_earn/utils/colors.dart';
import 'package:l_earn/utils/constants.dart';
import 'package:l_earn/utils/mixins.dart';
import 'package:go_router/go_router.dart';

class SignupPage extends StatefulWidget with AppBarMixin {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _obscureTextPassword = true;
  bool _obscureTextConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:
            widget.buildAppBar(context, title: 'L-EARN', includeClose: true),
        body: MultiBlocListener(
          listeners: [
            BlocListener<AuthCubit, AuthState>(
              listener: (context, state) {
                if (state is AuthFailed) {
                  print("Auth failed from signup page");
                  showDialog(
                      context: context,
                      builder: (context) {
                        return MyDialog(
                            title: state.error!.title,
                            content: state.error!.content);
                      });
                } else if (state is AuthSignedUp) {
                  print("Auth signed up from signup page");
                  AuthHelper.userMap["email"] = state.email;
                  //? send email otp
                  context
                      .read<VerificationCubit>()
                      .requestEmailVerificationOtp();

                  //? navigate to emailVerificationPage
                  // Navigator.pushNamed(context, '/emailVerificationPage');
                  context.pushNamed(AppRoutes.emailVerification);
                }
              },
            ),

            //? This is to start the timer if the email was sent successfully.
            BlocListener<VerificationCubit, VerificationState>(
              listener: (context, state) {
                if (state is AuthEmailVerificationMailSent) {
                  context
                      .read<TimerCubit>()
                      .setTimer(duration: const Duration(minutes: 1));
                }
              },
            ),
          ],
          child: SingleChildScrollView(
            child: Center(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 32,
                    ),

                    //? SIGNUP TEXT
                    Text(
                      'Signup',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(fontWeight: FontWeight.w500),
                    ),

                    const SizedBox(
                      height: 16,
                    ),

                    //? LOGIN TEXT
                    Text(
                      'Alright! Let\'s get you an account',
                    ),

                    const SizedBox(
                      height: 42,
                    ),

                    //? FIRST NAME AND LAST NAME TEXT FIELD
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: MyTextFormField(
                              hintText: "First name",
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[a-zA-Z]'))
                              ],
                              controller: _firstNameController,
                              validator: firstNameFieldValidator,
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Expanded(
                            child: MyTextFormField(
                              hintText: "Last name",
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[a-zA-Z]'))
                              ],
                              controller: _lastNameController,
                              validator: lastNameFieldValidator,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(
                      height: 16,
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
                        obscureText: _obscureTextPassword,
                        suffixIcon: Icon(_obscureTextPassword == false
                            ? Icons.visibility
                            : Icons.visibility_off),
                        suffixOnpressed: () {
                          setState(() {
                            _obscureTextPassword = !_obscureTextPassword;
                          });
                        },
                      ),
                    ),

                    const SizedBox(
                      height: 16,
                    ),

                    //? CONFIRM PASSWORD TEXT FIELD
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: MyTextFormField(
                        hintText: "Confirm password",
                        controller: _confirmPasswordController,
                        validator: (value) {
                          return signupConfirmPasswordValidator(
                              value, _passwordController.text);
                        },
                        obscureText: _obscureTextConfirmPassword,
                        suffixIcon: Icon(_obscureTextConfirmPassword == false
                            ? Icons.visibility
                            : Icons.visibility_off),
                        suffixOnpressed: () {
                          setState(() {
                            _obscureTextConfirmPassword =
                                !_obscureTextConfirmPassword;
                          });
                        },
                      ),
                    ),

                    const SizedBox(
                      height: 48,
                    ),

                    //? LOGIN BUTTON

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Builder(builder: (context) {
                        final authState = context.watch<AuthCubit>().state;

                        return MyElevatedButton(
                          loading: authState is AuthSigningUp,
                          text: 'Sign up',
                          onPressed: () {
                            //? validate inputs
                            final bool? isValid =
                                _formKey.currentState?.validate();

                            if (isValid == true) {
                              //* Update userMap details
                              //? FIRSTNAME
                              AuthHelper.userMap["firstName"] =
                                  _firstNameController.text;

                              //? LASTNAME
                              AuthHelper.userMap["lastName"] =
                                  _lastNameController.text;

                              //? EMAIL
                              AuthHelper.userMap["email"] =
                                  _emailController.text;

                              //? PASSWORD
                              AuthHelper.userMap["password"] =
                                  _passwordController.text;

                              //? CONFIRM PASSWORD
                              AuthHelper.userMap["confirmPassword"] =
                                  _confirmPasswordController.text;
                              //* SIGNUP
                              context.read<AuthCubit>().signUp();
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
                          Text("Already have an account?"),
                          MyTextButton(
                              text: 'login',
                              textcolor: AppColor.buttonTextBlue,
                              textDecoration: TextDecoration.underline,
                              onPressed: () {
                                print('Login button pressed');
                                context.goNamed(AppRoutes.login);
                              })
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}

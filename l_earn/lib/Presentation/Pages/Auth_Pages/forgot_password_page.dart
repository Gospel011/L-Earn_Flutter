import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:l_earn/BusinessLogic/AuthCubit/auth/auth_cubit.dart';
import 'package:l_earn/BusinessLogic/AuthCubit/auth/auth_state.dart';
import 'package:l_earn/BusinessLogic/AuthCubit/timer/timer_cubit.dart';

import 'package:l_earn/BusinessLogic/AuthCubit/verification/verification_cubit.dart';
import 'package:l_earn/Helpers/auth_helper.dart';
import 'package:l_earn/Presentation/components/Functions/validators.dart';
import 'package:l_earn/Presentation/components/my_dialog.dart';
import 'package:l_earn/Presentation/components/my_elevated_button.dart';

import 'package:l_earn/Presentation/components/my_textformfield.dart';

import 'package:l_earn/utils/mixins.dart';

class ForgotPasswordPage extends StatefulWidget with AppBarMixin {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  
  final TextEditingController _emailController = TextEditingController();
  

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:
            widget.buildAppBar(context, title: 'L-EARN', includeClose: true),
        body: MultiBlocListener(
          listeners: [
            BlocListener<AuthCubit, AuthState>(
              listener: (context, state) {
                if (state is AuthPasswordResetOtpNotSent) {
                  print("Auth failed from forgot password page");
                  showDialog(
                      context: context,
                      builder: (context) {
                        return MyDialog(
                            title: state.error!.title,
                            content: state.error!.content);
                      });
                } else if (state is AuthPasswordResetOtpSent) {
                  print("Auth password reset otp sent from /forgot-password page");
                  
                  
                  //? navigate to reset password page
                  Navigator.pushNamed(context, '/reset-password');
                }
            //? This is to start the timer if the email was sent successfully.
                  context
                      .read<TimerCubit>()
                      .setTimer(duration: const Duration(minutes: 1));
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
                      'It\'s Okay',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(fontWeight: FontWeight.w500),
                    ),

                    const SizedBox(
                      height: 16,
                    ),

                    //? LOGIN TEXT
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        "Everyone forgets. Just enter your email and we'll send you a password reset otp",
                        textAlign: TextAlign.center,
                      ),
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
                      height: 48,
                    ),

                    //? Send otp BUTTON

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Builder(builder: (context) {
                        final authState = context.watch<AuthCubit>().state;
                        
                        return MyElevatedButton(
                          loading: authState is AuthRequestingPasswordResetOtp,
                          text: 'Send Otp',
                          onPressed: () {
                            //? validate inputs
                            final bool? isValid =
                                _formKey.currentState?.validate();

                            if (isValid == true) {

                              //? EMAIL
                              AuthHelper.userMap["email"] =
                                  _emailController.text;

                              //TODO --> IMPLEMENT FORGOT PASSWORD
                              context.read<AuthCubit>().forgotPassword();
                            }
                          },
                        );
                      }),
                    ),

                  ],
                ),
              ),
            ),
          ),
        ));
  }
}

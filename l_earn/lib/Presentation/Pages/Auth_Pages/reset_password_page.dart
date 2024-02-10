import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:l_earn/BusinessLogic/AuthCubit/auth/auth_state.dart';
import 'package:l_earn/BusinessLogic/AuthCubit/timer/timer_cubit.dart';
import 'package:l_earn/Helpers/auth_helper.dart';
import 'package:l_earn/Presentation/components/Functions/validators.dart';
import 'package:l_earn/Presentation/components/my_dialog.dart';
import 'package:l_earn/Presentation/components/my_elevated_button.dart';
import 'package:l_earn/Presentation/components/my_textfield.dart';
import 'package:l_earn/Presentation/components/my_textformfield.dart';
import 'package:l_earn/utils/mixins.dart';

import 'package:l_earn/BusinessLogic/AuthCubit/auth/auth_cubit.dart';
import 'package:l_earn/BusinessLogic/AuthCubit/verification/verification_cubit.dart';
import 'package:l_earn/Presentation/components/my_text_button.dart';
import 'package:l_earn/utils/colors.dart';

import '../../../utils/enums.dart';

class ResetPasswordPage extends StatefulWidget with AppBarMixin {
  ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  //* FOCUS NODES
  final FocusNode _d1Focusnode = FocusNode();

  final FocusNode _d2Focusnode = FocusNode();

  final FocusNode _d3Focusnode = FocusNode();

  final FocusNode _d4Focusnode = FocusNode();

  final FocusNode _d5Focusnode = FocusNode();

  final FocusNode _d6Focusnode = FocusNode();

  //* TEXT EDITING CONTROLLERS
  final TextEditingController e1 = TextEditingController();

  final TextEditingController e2 = TextEditingController();

  final TextEditingController e3 = TextEditingController();

  final TextEditingController e4 = TextEditingController();

  final TextEditingController e5 = TextEditingController();

  final TextEditingController e6 = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _obscureTextPassword = true;
  bool _obscureTextConfirmPassword = true;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _d1Focusnode.requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    

    return Scaffold(
      appBar: widget.buildAppBar(context, title: 'L-EARN', includeClose: true),
      resizeToAvoidBottomInset: false,
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) async {
          if (state is AuthPasswordChanged) {
            print("P A S S W O R D CHANGE SUCCESSFUL");
            await showDialog(
                context: context,
                builder: (context) {
                  return const MyDialog(
                    title: 'Congratulations',
                    content:
                        'Your password has been changed successfully, make sure to always remember it and also keep it safe. You may now login with your new password.',
                  );
                });

            if (context.mounted) {
              Navigator.pushNamedAndRemoveUntil(
                  context, '/', (route) => false);
            }
          } else if (state is AuthPasswordResetFailed) {
            print("P A S S W O R D CHANGE failed");
            showDialog(
                context: context,
                builder: (context) {
                  return MyDialog(
                    title: state.error!.title,
                    content: state.error!.content,
                  );
                });
          }
        },
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Form(
              key: _formKey,
              child: Column(children: [
                const SizedBox(
                  height: 32,
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Reset Password',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),

                const SizedBox(
                  height: 16,
                ),

                //* Text
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Please provide the 6-digit code we sent to ${context.read<AuthCubit>().state.email}',
                    textAlign: TextAlign.center,
                  ),
                ),

                const SizedBox(
                  height: 16,
                ),

                //? SIX OTP BOXES
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: MyTextFormField(
                          controller: e1,
                          focusNode: _d1Focusnode,
                          validator: otpValidator,
                          onChanged: e1OnChanged,
                          textFieldType: TextFieldType.otp,
                        ),
                      ),

                      //* 10px Spacing
                      const SizedBox(
                        width: 10,
                      ),

                      Expanded(
                        child: MyTextFormField(
                          controller: e2,
                          focusNode: _d2Focusnode,
                          validator: otpValidator,
                          onChanged: e2OnChanged,
                          textFieldType: TextFieldType.otp,
                        ),
                      ),

                      //* 10px Spacing
                      const SizedBox(
                        width: 10,
                      ),

                      Expanded(
                        child: MyTextFormField(
                          controller: e3,
                          validator: otpValidator,
                          focusNode: _d3Focusnode,
                          onChanged: e3OnChanged,
                          textFieldType: TextFieldType.otp,
                        ),
                      ),

                      //* 10px Spacing
                      const SizedBox(
                        width: 10,
                      ),

                      Expanded(
                        child: MyTextFormField(
                          controller: e4,
                          focusNode: _d4Focusnode,
                          onChanged: e4OnChanged,
                          textFieldType: TextFieldType.otp, validator: otpValidator,
                        ),
                      ),

                      //* 10px Spacing
                      const SizedBox(
                        width: 10,
                      ),

                      Expanded(
                          child: MyTextFormField(
                        controller: e5,
                        focusNode: _d5Focusnode,
                        validator: otpValidator,
                        onChanged: e5OnChanged,
                        textFieldType: TextFieldType.otp,
                      )),

                      //* 10px Spacing
                      const SizedBox(
                        width: 10,
                      ),

                      Expanded(
                        child: MyTextFormField(
                          controller: e6,
                          focusNode: _d6Focusnode,
                          validator: otpValidator,
                          onChanged: e6OnChanged,
                          textFieldType: TextFieldType.otp,
                        ),
                      ),
                    ],
                  ),
                ),

                //? SOME SPACING
                const SizedBox(
                  height: 64,
                ),

                //? PASSWORD TEXT FIELD
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: MyTextFormField(
                    hintText: "new Password",
                    controller: _passwordController,
                    validator: passwordValidator,
                    inputFormatters: [LengthLimitingTextInputFormatter(8)],
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
                    hintText: "Confirm new password",
                    controller: _confirmPasswordController,
                    validator: (value) {
                      return signupConfirmPasswordValidator(
                          value, _passwordController.text.trim());
                    },
                    inputFormatters: [LengthLimitingTextInputFormatter(8)],
                    obscureText: _obscureTextConfirmPassword,
                    suffixIcon: Icon(_obscureTextConfirmPassword == false
                        ? Icons.visibility
                        : Icons.visibility_off),
                    suffixOnpressed: () {
                      setState(() {
                        _obscureTextConfirmPassword = !_obscureTextConfirmPassword;
                      });
                    },
                  ),
                ),
              ]),
            ),

            //? VERIFY EMAIL
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: buildFooter(),
            )
          ],
        ),
      ),
    );
  }

  Column buildFooter() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        BlocBuilder<AuthCubit, AuthState>(builder: (context, state) {
          return MyElevatedButton(
            text: 'Reset password',
            loading: state is AuthResetingPassword,
            onPressed: () async {
              bool? isValid = _formKey.currentState?.validate();

              if (isValid == true) {

              AuthHelper.userMap["otp"] =
                  "${e1.text}${e2.text}${e3.text}${e4.text}${e5.text}${e6.text}";
              AuthHelper.userMap["newPassword"] =
                  _passwordController.text.trim();
              AuthHelper.userMap["newConfirmPassword"] =
                  _confirmPasswordController.text.trim();
              context.read<AuthCubit>().resetPassword();
              }
            },
          );
        }),
        const SizedBox(
          height: 8,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text("Didn't receive the code?"),
              BlocBuilder<TimerCubit, TimerState>(
                builder: (context, state) {
                  print("T I M E R S T A T E IS $state");
                  return MyTextButton(
                      text: 'resend',
                      textcolor: AppColor.buttonTextBlue,
                      textDecoration: TextDecoration.underline,
                      onPressed: () {
                        //TODO --> NAVIGATE TO SIGNUP

                        if (state is TimerEnded) {
                          print('Resending...');

                          //? RESENT OTP
                          context.read<AuthCubit>().resetPassword();

                          //? start timer
                          context
                              .read<TimerCubit>()
                              .setTimer(duration: const Duration(minutes: 1));
                        } else {
                          print("Timer hasn't ended");
                        }
                      });
                },
              )
            ],
          ),
        ),
      ],
    );
  }

  void e6OnChanged(value) {
    value != '' ? _d6Focusnode.unfocus() : _d5Focusnode.requestFocus();
  }

  void e5OnChanged(value) {
    value != '' ? _d6Focusnode.requestFocus() : _d4Focusnode.requestFocus();
  }

  void e4OnChanged(value) {
    value != '' ? _d5Focusnode.requestFocus() : _d3Focusnode.requestFocus();
  }

  void e3OnChanged(value) {
    value != '' ? _d4Focusnode.requestFocus() : _d2Focusnode.requestFocus();
  }

  void e2OnChanged(value) {
    value != '' ? _d3Focusnode.requestFocus() : _d1Focusnode.requestFocus();
  }

  void e1OnChanged(value) {
    value != '' ? _d2Focusnode.requestFocus() : null;
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:l_earn/BusinessLogic/AuthCubit/timer/timer_cubit.dart';
import 'package:l_earn/Helpers/auth_helper.dart';
import 'package:l_earn/Presentation/components/my_dialog.dart';
import 'package:l_earn/Presentation/components/my_elevated_button.dart';
import 'package:l_earn/Presentation/components/my_textfield.dart';
import 'package:l_earn/utils/mixins.dart';

import 'package:l_earn/BusinessLogic/AuthCubit/auth/auth_cubit.dart';
import 'package:l_earn/BusinessLogic/AuthCubit/verification/verification_cubit.dart';
import 'package:l_earn/Presentation/components/my_text_button.dart';
import 'package:l_earn/utils/colors.dart';
import 'package:l_earn/utils/constants.dart';
import 'package:go_router/go_router.dart';

import '../../../../utils/enums.dart';

class EmailVerificationPage extends StatelessWidget with AppBarMixin {
  EmailVerificationPage({super.key});

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

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _d1Focusnode.requestFocus();
    });

    return Scaffold(
      appBar: buildAppBar(context, title: 'L-EARN', includeClose: true),
      body: BlocListener<VerificationCubit, VerificationState>(
        listener: (context, state) async {
          if (state is EmailVerified) {
            print("V E R I F I C A T I O N SUCCESSFUL");
            await showDialog(
                context: context,
                builder: (context) {
                  return MyDialog(
                    title: 'Congratulations',
                    content:
                        context.read<AuthCubit>().state.email == null ? "Your account is now verifed" : 'Your Account setup is complete. You may now login with your email and password.',
                  );
                });

            if (context.mounted) {
              // Navigator.pushNamedAndRemoveUntil(
              //     context, '/', (route) => false);

              context.read<AuthCubit>().state.email == null ? context.goNamed(AppRoutes.home) : context.goNamed(AppRoutes.login);
            }
          } else if (state is VerificationFailed) {
            print("V e r i f i c a t i o n failed");
            showDialog(
                context: context,
                builder: (context) {
                  return MyDialog(
                    title: state.error.title,
                    content: state.error.content,
                  );
                });
          }
        },
        child: SafeArea(
            child: Padding(
          padding:
              const EdgeInsets.only(left: 16, right: 16, top: 24, bottom: 20),
          child: Column(children: [
            const SizedBox(
              height: 32,
            ),

            Text(
              'Verify Email',
              style: Theme.of(context).textTheme.bodyLarge,
            ),

            const SizedBox(
              height: 16,
            ),

            //* Text
            Text(
              'Please provide the 6-digit code we sent to ${context.read<AuthCubit>().state.email ?? context.read<AuthCubit>().state.user?.email}',
              textAlign: TextAlign.center,
            ),

            const SizedBox(
              height: 16,
            ),

            //? SIX OTP BOXES
            Row(
              children: [
                Expanded(
                  child: MyTextField(
                    controller: e1,
                    focusNode: _d1Focusnode,
                    onChanged: e1OnChanged,
                    textFieldType: TextFieldType.otp,
                  ),
                ),

                //* 10px Spacing
                const SizedBox(
                  width: 10,
                ),

                Expanded(
                  child: MyTextField(
                    controller: e2,
                    focusNode: _d2Focusnode,
                    onChanged: e2OnChanged,
                    textFieldType: TextFieldType.otp,
                  ),
                ),

                //* 10px Spacing
                const SizedBox(
                  width: 10,
                ),

                Expanded(
                  child: MyTextField(
                    controller: e3,
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
                  child: MyTextField(
                    controller: e4,
                    focusNode: _d4Focusnode,
                    onChanged: e4OnChanged,
                    textFieldType: TextFieldType.otp,
                  ),
                ),

                //* 10px Spacing
                const SizedBox(
                  width: 10,
                ),

                Expanded(
                    child: MyTextField(
                  controller: e5,
                  focusNode: _d5Focusnode,
                  onChanged: e5OnChanged,
                  textFieldType: TextFieldType.otp,
                )),

                //* 10px Spacing
                const SizedBox(
                  width: 10,
                ),

                Expanded(
                  child: MyTextField(
                    controller: e6,
                    focusNode: _d6Focusnode,
                    onChanged: e6OnChanged,
                    textFieldType: TextFieldType.otp,
                  ),
                ),
              ],
            ),
            const Expanded(child: SizedBox()),

            //? VERIFY EMAIL
            BlocBuilder<VerificationCubit, VerificationState>(
                builder: (context, state) {
              return MyElevatedButton(
                text: 'Verify',
                loading: state is VerifyingEmail,
                onPressed: () async {
                  AuthHelper.userMap["otp"] =
                      "${e1.text}${e2.text}${e3.text}${e4.text}${e5.text}${e6.text}";
                  context.read<VerificationCubit>().verifyEmailOtp();
                },
              );
            }),

            //? DON'T HAVE AN ACCOUNT? SIGNUP
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

                            // if (state is TimerEnded) {
                            //   print('Resending...');

                            //   //? RESENT OTP
                            //   context
                            //       .read<VerificationCubit>()
                            //       .requestEmailVerificationOtp();

                            //   //? start timer
                            //   context.read<TimerCubit>().setTimer(
                            //       duration: const Duration(minutes: 1));
                            // } else {
                            //   print("Timer hasn't ended");
                            // }
                          });
                    },
                  )
                ],
              ),
            )
          ]),
        )),
      ),
    );
  }

  void e6OnChanged(value) {
                    value != ''
                        ? _d6Focusnode.unfocus()
                        : _d5Focusnode.requestFocus();
                  }

  void e5OnChanged(value) {
                  value != ''
                      ? _d6Focusnode.requestFocus()
                      : _d4Focusnode.requestFocus();
                }

  void e4OnChanged(value) {
                    value != ''
                        ? _d5Focusnode.requestFocus()
                        : _d3Focusnode.requestFocus();
                  }

  void e3OnChanged(value) {
                    value != ''
                        ? _d4Focusnode.requestFocus()
                        : _d2Focusnode.requestFocus();
                  }

  void e2OnChanged(value) {
                    value != ''
                        ? _d3Focusnode.requestFocus()
                        : _d1Focusnode.requestFocus();
                  }

  void e1OnChanged(value) {
                    value != '' ? _d2Focusnode.requestFocus() : null;
                  }
}

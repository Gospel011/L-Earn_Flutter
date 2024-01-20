import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:l_earn/Presentation/components/my_elevated_button.dart';
import 'package:l_earn/Presentation/components/my_textfield.dart';
import 'package:l_earn/utils/mixins.dart';

import '../../../utils/enums.dart';

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
      body: SafeArea(
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
          const Text(
            'Please provide the 6-digit code we sent to example@gmail.com',
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
                  onChanged: (value) {
                    value != '' ? _d2Focusnode.requestFocus() : null;
                  },
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
                  onChanged: (value) {
                    value != ''
                        ? _d3Focusnode.requestFocus()
                        : _d1Focusnode.requestFocus();
                  },
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
                  onChanged: (value) {
                    value != ''
                        ? _d4Focusnode.requestFocus()
                        : _d2Focusnode.requestFocus();
                  },
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
                  onChanged: (value) {
                    value != ''
                        ? _d5Focusnode.requestFocus()
                        : _d3Focusnode.requestFocus();
                  },
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
                onChanged: (value) {
                  value != ''
                      ? _d6Focusnode.requestFocus()
                      : _d4Focusnode.requestFocus();
                },
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
                  onChanged: (value) {
                    value != ''
                        ? _d6Focusnode.unfocus()
                        : _d5Focusnode.requestFocus();
                  },
                  textFieldType: TextFieldType.otp,
                ),
              ),
            ],
          ),
          const Expanded(child: SizedBox()),

          //? VERIFY EMAIL
          MyElevatedButton(
            text: 'Verify',
            onPressed: () async {
              await showDialog(
                  context: context,
                  builder: (context) {
                    return const AlertDialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(16))),
                      title: Center(child: Text('Congratulations')),
                      content: Text(
                          'Your Account setup is complete. You may now login with your email and password.'),
                    );
                  });

              if (context.mounted) {
                Navigator.pushNamedAndRemoveUntil(
                  context, '/login', (route) => false);
              }
            },
          ),
        ]),
      )),
    );
  }
}

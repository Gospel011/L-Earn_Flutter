import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:l_earn/Presentation/components/Functions/validators.dart';
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

  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: widget.buildAppBar(context, title: 'L-EARN'),
        body: SingleChildScrollView(
          child: Center(
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
                    inputFormatters: [LengthLimitingTextInputFormatter(8)],
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
                  child: MyElevatedButton(
                    text: 'Login',
                    onPressed: () {
                      //TODO --> IMPLEMENT LOGIN
                      print('LOGIN PRESSED');
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/', (route) => false);
                    },
                  ),
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
        ));
  }
}

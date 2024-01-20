import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:l_earn/Presentation/components/Functions/validators.dart';
import 'package:l_earn/Presentation/components/my_elevated_button.dart';
import 'package:l_earn/Presentation/components/my_text_button.dart';
import 'package:l_earn/Presentation/components/my_textformfield.dart';
import 'package:l_earn/utils/colors.dart';
import 'package:l_earn/utils/mixins.dart';

class SignupPage extends StatefulWidget with AppBarMixin {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<SignupPage> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _obscureTextPassword = true;
  bool _obscureTextConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: widget.buildAppBar(
          context,
          title: 'L-EARN',
          includeClose: true
        ),
        body: SingleChildScrollView(
          child: Center(
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
                          controller: _firstNameController,
                          validator: emailValidator,
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        child: MyTextFormField(
                          hintText: "Last name",
                          controller: _lastNameController,
                          validator: emailValidator,
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

                //? PASSWORD TEXT FIELD
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: MyTextFormField(
                    hintText: "Confirm password",
                    controller: _confirmPasswordController,
                    validator: passwordValidator,
                    inputFormatters: [LengthLimitingTextInputFormatter(8)],
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
                  child: MyElevatedButton(
                    text: 'Sign up',
                    onPressed: () {
                      //TODO --> IMPLEMENT LOGIN
                      print('SIGN UP PRESSED');
                      Navigator.pushNamed(context, '/emailVerificationPage');
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
                      Text("Already have an account?"),
                      MyTextButton(
                          text: 'login',
                          textcolor: AppColor.buttonTextBlue,
                          textDecoration: TextDecoration.underline,
                          onPressed: () {
                            //TODO --> NAVIGATE TO SIGNUP
                            print('Login button pressed');
                            Navigator.pushNamedAndRemoveUntil(
                                context, '/login', (route) => false);
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

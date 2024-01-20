import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../utils/colors.dart';

class MyTextFormField extends StatelessWidget {
  /// This is used to access the user's input
  final TextEditingController controller;

  /// A function that accepts a nullable string. Used to validate the input
  /// before further action is taked
  final String? Function(String?) validator;

  /// This tells the user what to input in the TextFormField
  final String hintText;

  /// This is the [widget] that would be shown at the far right of the
  /// TextFormField
  final Widget? suffixIcon;

  /// This is the function that is executed when the [suffixIcon] is pressed.
  final void Function()? suffixOnpressed;

  /// This specifies whether to hide the text or not.
  final bool? obscureText;

  /// This specifies whether the user is allowed to input text in the
  /// TextFormField.
  final bool? enabled;

  /// This specifies which type of keyboard should be shown to the user
  final TextInputType? keyboardType;

  /// This filters the users input and accepts only the valid ones.
  final List<TextInputFormatter>? inputFormatters;
  const MyTextFormField(
      {super.key,
      required this.hintText,
      required this.controller,
      required this.validator,
      this.suffixIcon,
      this.suffixOnpressed,
      this.obscureText,
      this.enabled,
      this.keyboardType,
      this.inputFormatters});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.centerRight,
      children: [
        TextFormField(
          obscureText: obscureText ?? false,
          enabled: enabled,
          controller: controller,
          validator: validator,
          cursorColor: AppColor.textColor,
          cursorWidth: 1.0,
          decoration: InputDecoration(hintText: hintText),
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
        ),
        suffixIcon != null
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child:
                    IconButton(onPressed: suffixOnpressed, icon: suffixIcon!),
              )
            : const SizedBox(),
      ],
    );
  }
}

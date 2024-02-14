import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:l_earn/utils/enums.dart';
import '../../utils/colors.dart';

class MyTextFormField extends StatelessWidget {
  /// This is used to access the user's input
  final TextEditingController controller;

  /// A function that accepts a nullable string. Used to validate the input
  /// before further action is taked
  final String? Function(String?) validator;

  /// This tells the user what to input in the TextFormField
  final String? hintText;

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

  /// This controls whether the textform field should be in focus or not
  final FocusNode? focusNode;

  /// What happens when the textform field value is changed
  final void Function(String)? onChanged;

  /// The textfield type
  final TextFieldType? textFieldType;

  /// The maxLines for this TextFormField. By default it is 1
  final int? maxLines;

  /// Them minLines for this TextFormField. By default it is null
  final int? minLines;

  /// This filters the users input and accepts only the valid ones.
  final List<TextInputFormatter>? inputFormatters;
  const MyTextFormField(
      {super.key,
      this.hintText,
      required this.controller,
      required this.validator,
      this.suffixIcon,
      this.suffixOnpressed,
      this.maxLines = 1,
      this.minLines,
      this.obscureText,
      this.enabled,
      this.keyboardType,
      this.inputFormatters,
      this.focusNode,
      this.onChanged,
      this.textFieldType});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscureText ?? false,
      maxLines: maxLines,
      minLines: minLines,
      enabled: enabled,
      style: textFieldType == TextFieldType.post
              ? Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)
              : Theme.of(context).textTheme.bodyMedium,
      focusNode: focusNode,
      onChanged: onChanged,
      controller: controller,
      validator: validator,
      cursorColor: AppColor.textColor,
      textAlign: textFieldType == TextFieldType.otp
          ? TextAlign.center
          : TextAlign.start,
      keyboardType: textFieldType == TextFieldType.otp
          ? TextInputType.number
          : keyboardType,
      cursorWidth: 1.0,
      decoration: InputDecoration(
        contentPadding: textFieldType == TextFieldType.otp
            ? EdgeInsets.symmetric(horizontal: 8)
            : null,
        hintText: hintText,
        suffixIcon: suffixIcon != null
            ? IconButton(onPressed: suffixOnpressed, icon: suffixIcon!)
            : null,
      ),
      inputFormatters: textFieldType == TextFieldType.otp
          ? [
              LengthLimitingTextInputFormatter(1),
              FilteringTextInputFormatter.digitsOnly
            ]
          : inputFormatters,
    );
  }
}

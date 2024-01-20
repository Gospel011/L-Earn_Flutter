import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:l_earn/utils/colors.dart';
import 'package:l_earn/utils/constants.dart';
import 'package:l_earn/utils/enums.dart';

class MyTextField extends StatelessWidget {
  final TextFieldType? textFieldType;
  final TextEditingController controller;
  final FocusNode? focusNode;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  final TextAlign textAlign;
  final EdgeInsetsGeometry? contentPadding;
  final void Function(String)? onChanged;
  final String? hintText;
  final bool? obscureText;
  final int? maxLines;
  final int? maxLength;
  

  const MyTextField(
      {super.key,
      this.textFieldType,
      required this.controller,
      this.maxLength,
      this.focusNode,
      this.inputFormatters,
      this.keyboardType,
      this.contentPadding,
      this.textAlign = TextAlign.start,
      this.onChanged,
      this.hintText,
      this.maxLines,
      this.obscureText});

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: obscureText ?? false,
      maxLines: maxLines ?? 1,
      maxLength: maxLength,
      maxLengthEnforcement: maxLength != null ? MaxLengthEnforcement.enforced : null,
      decoration: textFieldType == TextFieldType.otp
          ? InputDecoration(
              contentPadding: contentPadding ?? const EdgeInsets.symmetric(horizontal: 8))
          : InputDecoration(hintText: hintText, contentPadding: contentPadding ?? const EdgeInsets.symmetric(horizontal: 8)),
      controller: controller,
      focusNode: focusNode,
      textAlign: textFieldType == TextFieldType.otp
          ? TextAlign.center
          : TextAlign.start,
      cursorColor: AppColor.textColor, //? default theme
      cursorWidth: cursorWidth, //? default cursor width
      keyboardType:
          textFieldType == TextFieldType.otp ? TextInputType.number : keyboardType,
      inputFormatters: textFieldType == TextFieldType.otp
          ? [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(1)
            ]
          : inputFormatters,
      onChanged: onChanged,
    );
  }
}

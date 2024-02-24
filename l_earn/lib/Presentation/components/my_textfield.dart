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
  final bool? showCursor;
  final bool readOnly;
  final bool enabled;
  final int? maxLines;
  final int? maxLength;
  final int? minLines;

  const MyTextField(
      {super.key,
      this.textFieldType,
      this.enabled = true,
      this.readOnly = false,
      required this.controller,
      this.maxLength,
      this.focusNode,
      this.inputFormatters,
      this.keyboardType,
      this.contentPadding,
      this.textAlign = TextAlign.start,
      this.showCursor = true,
      this.onChanged,
      this.hintText,
      this.maxLines = 0,
      this.minLines,
      this.obscureText});

  @override
  Widget build(BuildContext context) {
    return TextField(
      showCursor: readOnly == true ? false : showCursor,
      readOnly: readOnly,
      selectionControls: readOnly == true ? EmptyTextSelectionControls() : null,
      enabled: showCursor == false ? showCursor : enabled,
      obscureText: obscureText ?? false,
      maxLines: maxLines == 0 ? 1 : maxLines,
      maxLength: maxLength,
      style: Theme.of(context).textTheme.bodyMedium,
      minLines: minLines ?? 1,
      maxLengthEnforcement:
          maxLength != null ? MaxLengthEnforcement.enforced : null,
      decoration: textFieldType == TextFieldType.otp
          //*  INPUT DECORATION FOR OTP
          ? InputDecoration(
              contentPadding:
                  contentPadding ?? const EdgeInsets.symmetric(horizontal: 8))
          : textFieldType == TextFieldType.post
              //*  INPUT DECORATION FOR POST
              ? InputDecoration(
                  contentPadding: contentPadding,
                  hintText: hintText,
                  enabledBorder:
                      const OutlineInputBorder(borderSide: BorderSide.none),
                  focusedBorder:
                      const OutlineInputBorder(borderSide: BorderSide.none))
              //*  INPUT DECORATION FOR OTHER TEXTFIELD TYPE
              : InputDecoration(
                  hintText: hintText,
                  contentPadding: contentPadding ??
                      const EdgeInsets.symmetric(horizontal: 8)),
      controller: controller,
      focusNode: focusNode,
      textAlign: textFieldType == TextFieldType.otp
          ? TextAlign.center
          : TextAlign.start,
      cursorColor: AppColor.textColor, //? default theme
      cursorWidth: cursorWidth, //? default cursor width
      keyboardType: textFieldType == TextFieldType.otp
          ? TextInputType.number
          : keyboardType,
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

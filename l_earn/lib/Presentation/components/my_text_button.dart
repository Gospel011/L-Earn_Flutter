import 'package:flutter/material.dart';
import 'package:l_earn/utils/colors.dart';


class MyTextButton extends StatefulWidget {
  final void Function()? onPressed;
  final String text;
  final Color? textcolor;
  final TextDecoration? textDecoration;
  final FontWeight? fontWeight;

  const MyTextButton(
      {super.key,
      required this.text,
      required this.onPressed,
      this.textcolor,
      this.textDecoration,
      this.fontWeight});

  @override
  State<MyTextButton> createState() => _MyTextButtonState();
}

class _MyTextButtonState extends State<MyTextButton> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      autofocus: true,
      onPressed: widget.onPressed,
      style: ButtonStyle(
          foregroundColor:
              MaterialStatePropertyAll(widget.textcolor ?? AppColor.textColor),
          overlayColor: const MaterialStatePropertyAll(Colors.transparent),
          textStyle: MaterialStatePropertyAll(TextStyle(
              decoration: widget.textDecoration,
              fontWeight: widget.fontWeight ?? FontWeight.w400,
              fontSize: 16,
              height: 22 / 16))),
      child: Text(widget.text),
    );
  }
}

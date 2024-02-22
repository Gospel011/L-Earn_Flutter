import 'package:flutter/material.dart';
import 'package:l_earn/utils/colors.dart';

class MyOutlineButton extends StatelessWidget {
  const MyOutlineButton(
      {super.key, required this.text, required this.onPressed});

  final String text;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
          decoration: BoxDecoration(
              border: Border.all(color: AppColor.textfieldEnabledBoderColor),
              borderRadius: BorderRadius.circular(16)),
          child: Center(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ))),
    );
  }
}
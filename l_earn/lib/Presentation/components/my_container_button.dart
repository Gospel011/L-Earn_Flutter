import 'package:flutter/material.dart';
import 'package:l_earn/Presentation/components/my_circularProgressIndicator.dart';
import 'package:l_earn/Presentation/components/my_text_button.dart';

class MyContainerButton extends StatelessWidget {
  const MyContainerButton(
      {super.key,
      required this.text,
      required this.onPressed,
      this.loading,
      this.textColor,
      this.showShadow = true,
      this.buttonColor});

  final bool? loading;
  final String text;
  final Color? textColor;
  final Color? buttonColor;
  final bool showShadow;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // splashColor: Colors.white,
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
            color: buttonColor ?? Colors.black,
            boxShadow: showShadow == true ? [
              BoxShadow(
                  color: Colors.grey.shade500,
                  offset: const Offset(1, 1),
                  spreadRadius: 1,
                  blurRadius: 5),
              BoxShadow(
                  color: Colors.grey.shade300,
                  offset: const Offset(-1, -1),
                  spreadRadius: 1,
                  blurRadius: 5),
            ] : null,
            borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
              height: 24,
              child: MyTextButton(
                text: text,
                loading: loading,
                onPressed: onPressed,
                textcolor: textColor ?? Colors.white,
              )),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:l_earn/Presentation/components/my_circularProgressIndicator.dart';
import 'package:l_earn/Presentation/components/my_text_button.dart';

class MyContainerButton extends StatelessWidget {
  const MyContainerButton(
      {super.key, required this.text, required this.onPressed, this.loading});

  final bool? loading;
  final String text;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // splashColor: Colors.white,
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
            color: Colors.black,
            boxShadow: [
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
            ],
            borderRadius: BorderRadius.circular(12)),
        child: 
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                    height: 24,
                    child: MyTextButton(
                      text: text,
                      loading: loading,
                      onPressed: onPressed,
                      textcolor: Colors.white,
                    )),
              ),
      ),
    );
  }
}

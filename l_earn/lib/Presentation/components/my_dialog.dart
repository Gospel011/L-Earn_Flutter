import 'package:flutter/material.dart';

class MyDialog extends StatelessWidget {
  final String title;
  final dynamic content;
  final List<Widget>? actions;
  const MyDialog({super.key, required this.title, required this.content, this.actions});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16))),
      title: Center(
          child: Text(
        title,
        style: Theme.of(context)
            .textTheme
            .bodyMedium
            ?.copyWith(fontSize: 18, fontWeight: FontWeight.bold),
      )),
      content: content is! String
          ? content
          : Text(
              content as String,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
      actions: actions,
    );
  }
}

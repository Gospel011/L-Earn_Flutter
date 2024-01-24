import 'package:flutter/material.dart';


class MyBottomAppBarItem extends StatelessWidget {
  final Widget icon;
  final String text;
  const MyBottomAppBarItem({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: [icon, Text(text)]);
  }
}

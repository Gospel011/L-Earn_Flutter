import 'package:flutter/material.dart';


class MyListTile extends StatelessWidget {
  const MyListTile({
    super.key,
    required this.children,
  });


  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children);
  }
}

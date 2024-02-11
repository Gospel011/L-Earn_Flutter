import 'package:flutter/material.dart';
import 'package:l_earn/utils/constants.dart';

class MyListTileWidget extends StatelessWidget {
  final Widget title;
  final Widget subtitle;
  final void Function()? onPressed;

  const MyListTileWidget(
      {super.key,
      required this.title,
      required this.subtitle,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      IconButton(
          padding: EdgeInsets.zero,
          onPressed: onPressed,
          visualDensity: VisualDensity.compact,
          isSelected: true,
          iconSize: 10,
          selectedIcon: AppIcons.likeSolidCompact,
          icon: title),
      subtitle
    ]);
  }
}
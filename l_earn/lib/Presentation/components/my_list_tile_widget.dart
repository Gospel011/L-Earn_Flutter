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
      //? ICON
      IconButton(
          padding: EdgeInsets.zero,
          onPressed: onPressed,
          visualDensity: VisualDensity.compact,
          splashRadius: 25,
          isSelected: true,
          selectedIcon: AppIcons.likeSolidCompact,
          icon: title),

      //? TEXT
      subtitle
    ]);
  }
}
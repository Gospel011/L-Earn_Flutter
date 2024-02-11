import 'package:flutter/material.dart';
import 'package:l_earn/DataLayer/Models/user_model.dart';
import 'package:l_earn/utils/constants.dart';

class RenderUserName extends StatelessWidget {
  const RenderUserName({super.key, required this.user, this.fontWeight});

  final User user;
  final FontWeight? fontWeight;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "${user.firstName} ${user.lastName}",
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(fontWeight: fontWeight),
        ),

        //! Check if user is verified before displaying the verified icon beside their name
        if (user.isVerified == true) const Text(" "),
        if (user.isVerified == true) AppIcons.verifiedIcon
      ],
    );
  }
}
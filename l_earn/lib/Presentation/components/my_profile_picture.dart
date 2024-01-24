import 'package:flutter/material.dart';
import 'package:l_earn/DataLayer/Models/user_model.dart';

class MyProfilePicture extends StatelessWidget {
  final double? radius;
  final bool focus;
  const MyProfilePicture({super.key, required this.user, this.radius, this.focus = false});

  final User user;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: focus ? Colors.black : Colors.transparent, width: 2),
          shape: BoxShape.circle),
      child: CircleAvatar(
        backgroundColor: Colors.blueGrey,
        foregroundImage: user.profilePicture != 'default.png'
            ? NetworkImage(user.profilePicture!)
            : null,
        radius: radius ?? 48,
      ),
    );
  }
}

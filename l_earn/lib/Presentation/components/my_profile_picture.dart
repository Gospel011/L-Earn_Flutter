import 'dart:io';

import 'package:flutter/material.dart';
import 'package:l_earn/DataLayer/Models/user_model.dart';
import 'package:image_picker/image_picker.dart';

class MyProfilePicture extends StatelessWidget {
  final double? radius;
  final bool focus;
  const MyProfilePicture(
      {super.key,
      required this.user,
      this.radius,
      this.focus = false,
      XFile? pickedImage})
      : _pickedImage = pickedImage;

  final User user;
  final XFile? _pickedImage;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
              color: focus ? Colors.black : Colors.transparent, width: 2),
          shape: BoxShape.circle),
      child: _pickedImage != null
          ? ClipRRect(
            borderRadius: BorderRadius.circular(radius ?? 48),
            child: Container(
                height: radius != null ? radius! * 2 : 48 * 2,
                width: radius != null ? radius! * 2 : 48 * 2,
                child: Image.file(File(_pickedImage!.path), fit: BoxFit.cover),
              ),
          )
          : CircleAvatar(
              backgroundColor: Colors.blueGrey,
              foregroundImage: user.profilePicture != 'default.png'
                  ? NetworkImage(user.profilePicture!)
                  : null,
              radius: radius ?? 48,
            ),
    );
  }
}

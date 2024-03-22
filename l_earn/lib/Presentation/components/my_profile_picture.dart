import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:l_earn/DataLayer/Models/user_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:l_earn/utils/constants.dart';

class MyProfilePicture extends StatelessWidget {
  final double? radius;
  final bool focus;
  const MyProfilePicture(
      {super.key,
      required this.user,
      this.radius,
      this.tappable = false,
      this.focus = false,
      XFile? pickedImage})
      : _pickedImage = pickedImage;

  final User user;
  final bool tappable;
  final XFile? _pickedImage;


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        tappable
            ? context.pushNamed(AppRoutes.imageView,
                pathParameters: {"imageUrl": user.profilePicture!})
            : null;
      },
      child: Container(
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
                  child:
                      Image.file(File(_pickedImage!.path), fit: BoxFit.cover),
                ),
              )
            : CircleAvatar(
                backgroundColor: Colors.blueGrey,
                radius: radius ?? 48,
                child: user.profilePicture != 'default.png'
                    ? ClipRRect(
                      borderRadius: BorderRadius.circular(48),
                      child: CachedNetworkImage( imageUrl: user.profilePicture!, fit: BoxFit.cover,))
                    : null,
              ),
      ),
    );
  }
}

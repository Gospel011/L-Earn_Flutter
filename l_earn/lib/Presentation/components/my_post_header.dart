import 'package:flutter/material.dart';
import 'package:l_earn/DataLayer/Models/user_model.dart';
import 'package:l_earn/Presentation/components/my_list_tile.dart';
import 'package:l_earn/Presentation/components/my_profile_picture.dart';
import 'package:l_earn/Presentation/components/render_user_name.dart';
import 'package:l_earn/utils/colors.dart';

class MyPostHeader extends StatelessWidget {
  const MyPostHeader(
      {super.key,
      required this.user,
      this.tagOnly,
      this.radius,
      this.fontSize});

  final User user;
  final bool? tagOnly;
  final double? radius;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    final String fullName = '${user.firstName} ${user.lastName}';
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //? PROFILE PICTURE
            MyProfilePicture(
              user: user,
              radius: radius ?? 24,
            ),

            const SizedBox(
              width: 5,
            ),

            MyListTile(
              children: [
                //? FULL NAME
                tagOnly == true
                    ? const SizedBox()
                    : RenderUserName(user: user, fontWeight: FontWeight.bold),

                //? HANDLE
                Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                    user.handle ?? '',
                    textAlign: TextAlign.left,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColor.textColor.withOpacity(0.7),
                        fontSize: fontSize ?? 16),
                  ),
                ),
              ],
            ),

          ],
        ),

        //? MORE
        IconButton(
            splashRadius: 30,
            onPressed: () {
              print("More Icon for $fullName pressed");
            },
            icon: const Icon(Icons.more_vert_outlined))
      ],
    );
  }
}

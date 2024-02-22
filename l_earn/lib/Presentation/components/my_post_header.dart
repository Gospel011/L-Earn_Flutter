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
      this.moreActions,
      this.tagOnly,
      this.radius,
      this.fontSize});

  final User user;
  final bool? tagOnly;
  final double? radius;
  final double? fontSize;
  final List<PopupMenuEntry<String>>? moreActions;

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
                Text(
                  user.handle ?? '',
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColor.textColor.withOpacity(0.7),
                      fontSize: fontSize ?? 16),
                ),
              ],
            ),
          ],
        ),

        //? MORE
        PopupMenuButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            offset: Offset(-10, 0),
            itemBuilder: (context) {
              return [
                ...?moreActions
                // PopupMenuItem(
                //   child: Text('Edit'),
                //   value: 'Edit',
                // ),
                // PopupMenuItem(
                //   child: Text('Add chapter'),
                //   value: 'Add',
                // ),
                // PopupMenuItem(
                //   child: Text('Delete'),
                //   value: 'Delete',
                // ),
              ];
            })
      ],
    );
  }
}

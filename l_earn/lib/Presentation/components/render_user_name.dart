import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:l_earn/DataLayer/Models/user_model.dart';
import 'package:l_earn/utils/constants.dart';

class RenderUserName extends StatelessWidget {
  const RenderUserName(
      {super.key, required this.user, this.fontWeight, this.iconSize = 24});

  final User user;
  final FontWeight? fontWeight;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return RichText(
      overflow: TextOverflow.ellipsis,
        text: TextSpan(
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(fontWeight: fontWeight),

            text: '',
            // text: "Oparah Nwachukwu Nkume Raymond",
            children: [
              TextSpan(text: "${user.firstName} ${user.lastName} "),
          WidgetSpan(
              child: user.isVerified == true
                  ? SizedBox(
                      width: iconSize,
                      height: iconSize,
                      child: AppIcons.verifiedIcon)
                  : const SizedBox())
        ]));

    // return Row(
    //   children: [
      
    //     Text(
    //         "Oparah Nwachukwu Nkume Raymond",
    //         style: Theme.of(context)
    //             .textTheme
    //             .bodyMedium
    //             ?.copyWith(fontWeight: fontWeight),
    //       ),
        
      

    //   user.isVerified == true
    //               ? SizedBox(
    //                   width: iconSize,
    //                   height: iconSize,
    //                   child: AppIcons.verifiedIcon)
    //               : const SizedBox()
    // ]);
  }
}


// Text(
//           "${user.firstName} ${user.lastName}",
//           maxLines: 1,
//           overflow: TextOverflow.ellipsis,
//           style: Theme.of(context)
//               .textTheme
//               .bodyMedium
//               ?.copyWith(fontWeight: fontWeight),
//         ),
    
//         //! Check if user is verified before displaying the verified icon beside their name
//         if (user.isVerified == true) const Text(" "),
//         if (user.isVerified == true) SizedBox(width: iconSize, height: iconSize, child: AppIcons.verifiedIcon)
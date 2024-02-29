import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:l_earn/BusinessLogic/AuthCubit/auth/auth_cubit.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:l_earn/DataLayer/Models/user_model.dart';
import 'package:l_earn/Presentation/components/my_image_widget.dart';
import 'package:l_earn/Presentation/components/my_profile_picture.dart';
import 'package:l_earn/Presentation/components/render_user_name.dart';
import 'package:l_earn/Presentation/components/my_container_button.dart';
import 'package:l_earn/utils/constants.dart';

class BuildBannerAndUserDescription extends StatelessWidget {
  const BuildBannerAndUserDescription({
    super.key,
    required this.user,
  });

  final User user;

  @override
  Widget build(BuildContext context) {
    print(
        ":::: U S E R   F R O M   B A N N E R A N D D E S C R I P T I O N   I S   $user");
    return Column(
      children: [
        //? BANNER
        SizedBox(
            width: double.maxFinite,
            height: 150,
            child: MyImageWidget(
              image: user.banner ?? 'default.png',
              boxfit: BoxFit.cover,
              borderRadius: 0,
            )),

        const SizedBox(height: 8),

        //? PROFILE PICTURE | MINI DESCRIPTION
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            //* PROFILE PICTURE
            MyProfilePicture(user: user, radius: 32),

            const SizedBox(
              width: 4,
            ),

            //* MINI DESCRIPTION
            Expanded(
                child: Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //? username
                        user.id == context.read<AuthCubit>().state.user?.id
                            ? RenderUserName(user: user, fontWeight: FontWeight.bold,)
                            : Row(children: [
                                Expanded(
                                    child: Text(
                                        '${user.firstName} ${user.lastName}',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                                fontWeight: FontWeight.bold))),
                                user.isVerified == true
                                    ? Text(' ')
                                    : const SizedBox(),
                                user.isVerified == true
                                    ? AppIcons.verifiedIcon
                                    : const SizedBox(),
                                const SizedBox(
                                  width: 4,
                                ),
                                MyContainerButton(
                                    text: 'follow',
                                    onPressed: () {
                                      //  TODO: IMPLEMENT FOLLOW
                                      print(
                                          'Follow button for ${user.firstName} ${user.lastName} ${user.id} pressed');
                                    })
                              ]),

                        //? handle
                        Text(user.handle!,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                    color: Colors.black.withOpacity(0.7))),

                        //? school
                        user.school != null
                            ? Text(
                                user.school!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              )
                            : const SizedBox(),

                        Row(children: [
                          //? department
                          user.department != null
                              ? Expanded(
                                  child: Text(
                                  user.department!,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ))
                              : const SizedBox(),

                          user.level != null
                              ? const Text(' \u2022 ')
                              : const SizedBox(),
                          user.level != null
                              ? Text('${user.level} level')
                              : const SizedBox(),
                        ]),

                        Text('${user.followers} followers',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(fontWeight: FontWeight.bold))
                      ],
                    )))
          ]),
        ),
      ],
    );
  }
}

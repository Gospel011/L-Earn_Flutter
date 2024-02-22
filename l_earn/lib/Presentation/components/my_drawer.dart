import 'package:flutter/material.dart';
import 'package:l_earn/DataLayer/Models/user_model.dart';
import 'package:l_earn/BusinessLogic/AuthCubit/auth/auth_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:l_earn/Presentation/components/my_container_button.dart';
import 'package:l_earn/Presentation/components/my_profile_picture.dart';
import 'package:l_earn/Presentation/components/render_user_name.dart';

class MyDrawer extends StatelessWidget {
  final User user;
  const MyDrawer({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          //* Image and Name
          DrawerHeader(
              decoration: const BoxDecoration(shape: BoxShape.circle),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  //* Picture
                  MyProfilePicture(user: user),

                  const SizedBox(
                    height: 8,
                  ),

                  //* Name
                  RenderUserName(user: user)
                ],
              )),

          //? VIEW PROFILE
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: MyDrawerItem(
              text: "View profile",
              onPressed: () {
                print("View profile button pressed");
                Navigator.pop(context);

                Navigator.pushNamed(context, '/profile-page', arguments: context.read<AuthCubit>().state.user!);
              },
            ),
          ),

          //? Logout
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: MyDrawerItem(
              text: "Logout",
              onPressed: () {
                print("Logout button pressed");
                Navigator.pop(context);
                context.read<AuthCubit>().logout();
              },
            ),
          ),

          const Expanded(
            child: SizedBox(),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              '"The key to a successful product is scattered among the minds of it\'s users."',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontStyle: FontStyle.italic, fontSize: 16),
            ),
          ),

          const SizedBox(
            height: 8,
          ),

          //? Contact us
          MyContainerButton(
            text: "Contact us",
            onPressed: () {
              print('Contact us button pressed');
            },
          ),

          const SizedBox(
            height: 24,
          )
        ],
      ),
    );
  }
}

class MyDrawerItem extends StatelessWidget {
  final String text;
  final void Function() onPressed;
  const MyDrawerItem({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onPressed,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              text,
            ),
          ),
        ],
      ),
    );
  }
}

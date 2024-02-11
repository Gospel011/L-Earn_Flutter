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

          //? Logout
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                //TODO --> HANDLE LOGOUT
                print("Logout button pressed");
                Navigator.pop(context);
                context.read<AuthCubit>().logout();
              },
              child: const Row(
                children: [
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      "Logout",
                    ),
                  ),
                ],
              ),
            ),
          ),

          //? Contact us
          MyContainerButton(
            text: "Contact us",
            onPressed: () {
              print('Contact us button pressed');
            },
          )
        ],
      ),
    );
  }
}



import 'package:flutter/material.dart';
import 'package:l_earn/DataLayer/Models/user_model.dart';
import 'package:l_earn/BusinessLogic/AuthCubit/auth/auth_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:l_earn/Presentation/components/my_profile_picture.dart';
import 'package:l_earn/utils/constants.dart';

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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "${user.firstName} ${user.lastName}",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),

                      //! Check if user is verified before displaying the verified icon beside their name
                      const Text(" "),
                      AppIcons.verifiedIcon
                    ],
                  )
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
          GestureDetector(
            // splashColor: Colors.white,
            onTap: () {
              print('Contact us button pressed');
            },
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.black,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.shade500,
                        offset: const Offset(1, 1),
                        spreadRadius: 1,
                        blurRadius: 5),
                    BoxShadow(
                        color: Colors.grey.shade300,
                        offset: const Offset(-1, -1),
                        spreadRadius: 1,
                        blurRadius: 5),
                  ],
                  borderRadius: BorderRadius.circular(12)),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Contact us",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}


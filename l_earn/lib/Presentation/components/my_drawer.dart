import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:l_earn/DataLayer/Models/user_model.dart';
import 'package:l_earn/BusinessLogic/AuthCubit/auth/auth_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:l_earn/Presentation/components/my_container_button.dart';
import 'package:l_earn/Presentation/components/my_profile_picture.dart';
import 'package:l_earn/Presentation/components/render_user_name.dart';
import 'package:l_earn/utils/constants.dart';
import 'package:go_router/go_router.dart';

class MyDrawer extends StatelessWidget {
  final User user;
  const MyDrawer({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          SingleChildScrollView(
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
                        RenderUserName(
                          user: user,
                          fontWeight: FontWeight.bold,
                        )
                      ],
                    )),
            
                //? VIEW PROFILE
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: MyDrawerItem(
                    text: "View profile",
                    leadingIcon: const Icon(Icons.person),
                    onPressed: () {
                      print("View profile button pressed");
                      //! avigator.pop(context);
                      context.pop();
            
                      context.goNamed(AppRoutes.profile, queryParameters: {
                        "user": context.read<AuthCubit>().state.user!.id
                      });
            
                      //! avigator.pushNamed(context, '/profile-page',
                      //     arguments: context.read<AuthCubit>().state.user!);
                    },
                  ),
                ),
            
                //? TUTORS PROFILE PAGE
                context.read<AuthCubit>().state.user?.role == 'tutor'
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: MyDrawerItem(
                          text: "Tutor's dashboard",
                          leadingIcon: const Icon(Icons.dashboard),
                          onPressed: () {
                            print("Payment history button pressed");
                            //! avigator.pop(context);
                            context.pop();
            
                            //! avigator.pushNamed(context, '/tutors-profile');
                            context.goNamed(AppRoutes.tutorsDashboard);
                          },
                        ),
                      )
                    : const SizedBox(),
            
                //? DRAFTS
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: MyDrawerItem(
                    text: "Drafts",
                    leadingIcon: const Icon(Icons.drafts),
                    onPressed: () {
                      print("Drafts button pressed");
            
                      context.pop();
            
                      context.goNamed(AppRoutes.drafts);
                    },
                  ),
                ),
            
                //? VIEW PAYMENT HISTORY
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: MyDrawerItem(
                    text: "Payment history",
                    leadingIcon: const Icon(Icons.history),
                    onPressed: () {
                      print("Payment history button pressed");
                      //! avigator.pop(context);
                      context.pop();
            
                      //! avigator.pushNamed(context, '/payment-history-page');
                      context.goNamed(AppRoutes.paymentHistory);
                    },
                  ),
                ),
            
                //? Logout
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: MyDrawerItem(
                    text: "Logout",
                    leadingIcon: const Icon(Icons.logout),
                    onPressed: () {
                      print("Logout button pressed");
                      //! avigator.pop(context);
                      context.pop();
                      context.read<AuthCubit>().logout();
                    },
                  ),
                ),
            
                //! const Expanded(
                //!   child: SizedBox(),
                //! ),
            
                // const SizedBox(
                //   height: 24,
                // )
              ],
            ),
          ),

          //? Contact us
            Positioned(
              bottom: 24,
              child: MyContainerButton(
                text: "Contact us",
                onPressed: () {
                  print('Contact us button pressed');
                },
              ),
            ),
        ],
      ),
    );
  }
}

class MyDrawerItem extends StatelessWidget {
  final String text;
  final void Function() onPressed;
  const MyDrawerItem(
      {super.key,
      required this.text,
      required this.onPressed,
      this.leadingIcon});
  final Widget? leadingIcon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onPressed,
      child: Row(
        children: [
          leadingIcon != null
              ? Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: leadingIcon,
                )
              : const SizedBox(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              text,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

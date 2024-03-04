import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:l_earn/BusinessLogic/AuthCubit/auth/auth_cubit.dart';
import 'package:l_earn/DataLayer/Models/user_model.dart';
import 'package:l_earn/Presentation/components/my_profile_picture.dart';
import 'package:l_earn/utils/mixins.dart';

class TutorsProfilePage extends StatelessWidget with AppBarMixin {
  const TutorsProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final User user = context.read<AuthCubit>().state.user!;

    return Scaffold(
      appBar: buildAppBar(context, title: 'Tutor\'s Dashboard'),
      body: Center(
          child: Column(
        children: [
          const SizedBox(height: 8,),
          //? TUTORS MINI PROFILE
          SizedBox(
            // height: ,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyProfilePicture(
                    user: user,
                  ),
            
                  const SizedBox(width: 8,),
            
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("${user.firstName} ${user.lastName}"),
                      Text("${user.followers}"),
                      const Text('Followers')
                    ],
                  )
                ],
              ),
            ),
          )
          //? SALES || AMOUNT
          //? TOP PAYING CONTENTS
        ],
      )),
    );
  }
}

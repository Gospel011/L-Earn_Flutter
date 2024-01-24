import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:l_earn/BusinessLogic/AuthCubit/auth/auth_cubit.dart';
import 'package:l_earn/Presentation/components/my_elevated_button.dart';
import 'package:l_earn/Presentation/components/my_text_button.dart';
import 'package:l_earn/utils/mixins.dart';

class HomePage extends StatelessWidget with AppBarMixin {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildAppBar(context, actions: [
          Builder(builder: (context) {
            return IconButton(
                onPressed: () {
                  Scaffold.of(context).openEndDrawer();
                },
                icon: const Icon(Icons.menu_rounded));
          })
        ]),
        endDrawer: Drawer(
          child: Column(
            children: [
              //? Image
              const DrawerHeader(
                  decoration: BoxDecoration(shape: BoxShape.circle),
                  child: CircleAvatar(
                    backgroundColor: Colors.blueGrey,
                    radius: 48,
                  )),

              //? Logout
              Row(
                children: [
                  MyTextButton(
                      text: "Logout",
                      onPressed: () {
                        //TODO --> HANDLE LOGOUT
                        print("Logout button pressed");
                      }),
                ],
              ),

              //? Contact us
              Align(
                alignment: Alignment.center,
                child: InkWell(
                  onTap: () {
                    print('Contact us button pressed');
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.black,
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.25), offset: Offset(4, 4))
                        ],
                        borderRadius: BorderRadius.circular(12)),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("Contact us", style: TextStyle(color: Colors.white),),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Text(
              'Welcome ${context.read<AuthCubit>().state.user?.firstName}. The app is still in development and would be done soon',
              textAlign: TextAlign.center,
            ),
          ),
        ));
  }
}

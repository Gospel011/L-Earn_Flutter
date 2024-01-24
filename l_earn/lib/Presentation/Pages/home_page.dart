import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:l_earn/BusinessLogic/AuthCubit/auth/auth_cubit.dart';
import 'package:l_earn/Presentation/components/my_drawer.dart';

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
        endDrawer: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            return MyDrawer(user: state.user!);
          }
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


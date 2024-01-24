import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:l_earn/BusinessLogic/AuthCubit/auth/auth_cubit.dart';
import 'package:l_earn/Presentation/components/my_drawer.dart';

import 'package:l_earn/utils/mixins.dart';

class HomePage extends StatelessWidget with AppBarMixin {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: ((context, state) {
        if (state is AuthInitial) {
          Navigator.pushNamedAndRemoveUntil(
              context, '/login', (route) => false);
        }
      }),
      child: Scaffold(
        bottomNavigationBar: BottomAppBar(child: Row(children: [
          SvgPicture.asset(r'assets/svg_icons/book-filled.svg')
        ],)),
          appBar: buildAppBar(context, actions: [
            Builder(builder: (context) {
              return IconButton(
                  onPressed: () {
                    Scaffold.of(context).openEndDrawer();
                  },
                  icon: const Icon(Icons.menu_rounded));
            })
          ]),
          endDrawer:
              BlocBuilder<AuthCubit, AuthState>(builder: (context, state) {
            return state.user != null ? MyDrawer(user: state.user!) : const SizedBox();
          }),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                'Welcome ${context.read<AuthCubit>().state.user?.firstName}. The app is still in development and would be done soon',
                textAlign: TextAlign.center,
              ),
            ),
          )),
    );
  }
}

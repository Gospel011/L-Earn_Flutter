import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:l_earn/BusinessLogic/AuthCubit/auth/auth_cubit.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Text('Welcome ${context.read<AuthCubit>().state.user?.firstName}. The app is still in development and would be done soon.',
                    textAlign: TextAlign.center,)
      ),
    );
  }
}
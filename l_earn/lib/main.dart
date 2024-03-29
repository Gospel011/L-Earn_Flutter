import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:l_earn/BusinessLogic/AuthCubit/auth/auth_cubit.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:l_earn/BusinessLogic/commentCubit/comment_cubit.dart';
import 'package:path_provider/path_provider.dart';

import 'package:l_earn/Presentation/route_generator.dart';
import 'package:l_earn/Presentation/go_router_config.dart';
import 'package:l_earn/utils/themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  HydratedBloc.storage = await HydratedStorage.build(
      storageDirectory: await getApplicationDocumentsDirectory());

  

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (context) => AuthCubit(),
        ),
      ],
      
      child: Builder(builder: (context) {
        print('Current state is ${context.read<AuthCubit>().state}');

        final GoRouterConfig router = GoRouterConfig(authCubit: context.read<AuthCubit>());
        return MaterialApp.router(
            title: 'Flutter Demo',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.myAppTheme,
            routerConfig: router.router,
            // onGenerateRoute: widget.routeGenerator.onGenerateRoute,
            // initialRoute: context.read<AuthCubit>().state.user == null ? '/' : '/home',
            );
      }),
    );
  }
}

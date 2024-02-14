import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:l_earn/BusinessLogic/AuthCubit/auth/auth_cubit.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:l_earn/BusinessLogic/commentCubit/comment_cubit.dart';
import 'package:path_provider/path_provider.dart';

import 'package:l_earn/Presentation/route_generator.dart';
import 'package:l_earn/utils/themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  HydratedBloc.storage = await HydratedStorage.build(
      storageDirectory: await getApplicationDocumentsDirectory());

  final RouteGenerator _routeGenerator = RouteGenerator();

  runApp(MyApp(
    routeGenerator: _routeGenerator,
  ));
}

class MyApp extends StatefulWidget {
  final RouteGenerator routeGenerator;
  const MyApp({super.key, required this.routeGenerator});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // BlocProvider<CommentCubit>(
        //   create: (context) => CommentCubit(),
        // ),
        BlocProvider<AuthCubit>(
          create: (context) => AuthCubit(),
        ),
      ],
      
      child: Builder(builder: (context) {
        print('Current state is ${context.read<AuthCubit>().state}');
        return MaterialApp(
            title: 'Flutter Demo',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.myAppTheme,
            onGenerateRoute: widget.routeGenerator.onGenerateRoute,
            initialRoute: context.read<AuthCubit>().state.user == null ? '/' : '/home');
      }),
    );
  }
}

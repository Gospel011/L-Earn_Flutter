import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:l_earn/BusinessLogic/AuthCubit/auth/auth_cubit.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:l_earn/DataLayer/Models/drafts/drafts_model.dart';

import 'package:l_earn/Presentation/go_router_config.dart';
import 'package:l_earn/utils/themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dir = await getApplicationDocumentsDirectory();

  HydratedBloc.storage = await HydratedStorage.build(
      storageDirectory: dir);

  // Hive.initFlutter(dir.path);
  Hive.init('${dir.path}/db');
  Hive.registerAdapter(DraftsAdapter());

  

  await Hive.openBox<Drafts>('drafts');

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

        final GoRouterConfig router =
            GoRouterConfig(authCubit: context.read<AuthCubit>(), draftsBox: Hive.box<Drafts>('drafts'));
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

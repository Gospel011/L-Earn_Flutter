import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:l_earn/utils/constants.dart';

import '../../../../utils/mixins.dart';

class CreateEventPage extends StatelessWidget with AppBarMixin {
  const CreateEventPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:
            buildAppBar(context, includeClose: true, closeButtonOnpressed: () {
          context.goNamed(AppRoutes.home);
        }),
        body: const Center(child: Text("Create an event")));
  }
}

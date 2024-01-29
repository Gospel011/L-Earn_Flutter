import 'package:flutter/material.dart';

import '../../../../utils/mixins.dart';

class CreateEventPage extends StatelessWidget with AppBarMixin {
  const CreateEventPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:
            buildAppBar(context, includeClose: true, closeButtonOnpressed: () {
          Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
        }),
        body: Center(child: Text("Create an event")));
  }
}

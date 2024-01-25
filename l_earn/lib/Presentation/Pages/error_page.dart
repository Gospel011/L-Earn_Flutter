import 'package:flutter/material.dart';
import 'package:l_earn/utils/mixins.dart';

class ErrorPage extends StatelessWidget with AppBarMixin {
  const ErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          buildAppBar(context),
      body: const Center(child: Text("The page requested does not exit")),
    );
  }
}

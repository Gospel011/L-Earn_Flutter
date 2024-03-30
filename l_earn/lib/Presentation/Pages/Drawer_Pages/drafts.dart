import 'package:flutter/material.dart';
import 'package:l_earn/utils/mixins.dart';

class DraftsPage extends StatelessWidget with AppBarMixin{
  const DraftsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: const Center(child: Text("Drafts Page"))
    );
  }
}
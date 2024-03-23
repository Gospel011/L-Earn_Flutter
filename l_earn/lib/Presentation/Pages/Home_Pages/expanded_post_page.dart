import 'package:flutter/material.dart';
import 'package:l_earn/utils/mixins.dart';

class ExpandedPostPage extends StatelessWidget with AppBarMixin {
  const ExpandedPostPage({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: Center(
        child: Text("Expanded Post Page $id"),
      ),
    );
  }
}

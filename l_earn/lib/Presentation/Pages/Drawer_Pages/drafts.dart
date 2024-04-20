import 'package:flutter/material.dart';
import 'package:l_earn/utils/mixins.dart';
import 'package:provider/provider.dart';
import 'package:l_earn/providers/drafts_provider.dart';

class DraftsPage extends StatelessWidget with AppBarMixin{
  const DraftsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: Consumer<DraftsProvider>(
        builder: (context, provider, _) {
          return Center(child: Text("Drafts Page (${provider.drafts.length})"));
        }
      )
    );
  }
}
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
          // return Center(child: Text("Drafts Page (${provider.drafts.length})"));

          final double offset = 2;

          return CustomScrollView(
            slivers: <Widget>[
              // top spacing
              SliverToBoxAdapter(child: SizedBox(height: 24)),

              // continue writing || filter
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      // text
                      Expanded(child: Text(
                        "Continue Writing",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 32, fontWeight: FontWeight.w500)
                      )),

                      // filter
                      PopupMenuButton(
                        child: Container(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text("Last updated"),
                              Icon(Icons.arrow_drop_down),
                            ]
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey.shade400,
                                  blurRadius: 2,
                                  offset: Offset(offset, offset)),
                              BoxShadow(
                                  color: Colors.white,
                                  blurRadius: 2,
                                  offset: Offset(-offset, -offset)),
                            ]
                          )
                        ),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        itemBuilder: (context) {
                          return [
                            PopupMenuItem(child: Text("Last updated"))
                          ];
                        }
                      )

                    ],
                  )
                  )
              ),

              // chapters
              SliverToBoxAdapter(child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text("${context.read<DraftsProvider>().drafts.length} chapters")
              )),

              // search bar

              // list of drafts
            ],
          );
        }
      )
    );
  }
}
import 'package:flutter/material.dart';
import 'package:l_earn/utils/mixins.dart';
import 'package:provider/provider.dart';
import 'package:l_earn/providers/drafts_provider.dart';
import 'package:l_earn/Presentation/components/my_textformfield.dart';
import 'package:l_earn/Helpers/stream_helper.dart';
import 'package:go_router/go_router.dart';
import 'package:l_earn/utils/constants.dart';

class DraftsPage extends StatelessWidget with AppBarMixin, TimeParserMixin {
  const DraftsPage({super.key});

  static final _searchController = TextEditingController();

  static final _draftsStream = StreamHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildAppBar(context),
        body: Consumer<DraftsProvider>(builder: (context, provider, _) {
          // return Center(child: Text("Drafts Page (${provider.drafts.length})"));

          final double offset = 2;

          final boxShadow = [
                            BoxShadow(
                                color: Colors.grey.shade400,
                                blurRadius: 2,
                                offset: Offset(offset, offset)),
                            BoxShadow(
                                color: Colors.white,
                                blurRadius: 2,
                                offset: Offset(-offset, -offset)),
                          ];
                      final style = Theme.of(context).textTheme.bodyMedium;

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
                          Expanded(
                              child: Text("Continue Writing",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                          fontSize: 32,
                                          height: 1.1,
                                          fontWeight: FontWeight.w500))),

                          // filter
                          PopupMenuButton(
                              child: Container(
                                  child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text("Last updated"),
                                        Icon(Icons.arrow_drop_down),
                                      ]),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 16.0, vertical: 4.0),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      color: Colors.white,
                                      boxShadow: boxShadow)),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16)),
                              itemBuilder: (context) {
                                return [
                                  const PopupMenuItem(
                                      child: Text("Last updated"))
                                ];
                              })
                        ],
                      ))),

              // chapters
              SliverToBoxAdapter(
                  child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                          "${context.read<DraftsProvider>().drafts.length} chapters"))),

              //? S E A R C H   B A R
              SliverToBoxAdapter(
                  child: Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16, top: 32),
                child: Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    // input field
                    MyTextFormField(
                      controller: _searchController,
                      hintText: 'Search for book or chapter',
                      onChanged: (value) {
                        print("Value is ___________________________________\n$value");

                        final searchResult = context.read<DraftsProvider>().find(value);

                        print("Search Result (${searchResult.length}) : $searchResult");

                        _draftsStream.add(searchResult);
                      },
                      validator: (value) {},
                      borderRadius: 24,
                      hintStyle: TextStyle(fontSize: 18),
                      contentPadding: const EdgeInsets.only(
                          left: 8, right: 64, top: 20, bottom: 20),
                    ),

                    //* search button
                    Container(
                        // padding: const EdgeInsets.symmetric(
                        //     horizontal: 16, vertical: 8),
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: IconButton(
                            icon: const Icon(Icons.search, color: Colors.white),
                            onPressed: () {
                              print("Searching for ${_searchController.text}");
                            }))
                  ],
                ),
              )),

              // list of drafts
              StreamBuilder(
                stream: _draftsStream.stream,
                initialData: context.read<DraftsProvider>().drafts,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  return SliverList.builder(
                itemCount: snapshot.data.length == 0 ? 1 : snapshot.data.length,
                // itemCount: snapshot.hasData ? snapshot.data.length : context.read<DraftsProvider>().drafts.length,
                itemBuilder: (BuildContext context, int index) {

                  if (snapshot.data.length == 0) return Padding(
                    padding: EdgeInsets.all(16),
                    child: const Text("No drafts found")
                  );

                  final draft = snapshot.data[index];
                  // final draft = snapshot.hasData ? snapshot.data[index] : context.read<DraftsProvider>().drafts[index];
                  final id = draft.id; // id
                  final chapterContent = draft.content; // chapterContent
                  final bookName = draft.bookName; // bookName
                  final chapter = draft.chapter; //chapter
                  final title = draft.title;  // title
                  final lastUpdated = draft.dateLastUpdated;
                  final timeDifference = calculateTimeDifference(lastUpdated.toString());
                  final timestamp = formatTimestamp(lastUpdated.toString());

                  final extras = {
                          "chapterId": id,
                          "title": title,
                          "chapter": chapter,
                          "bookName": bookName,
                          "chapterContent": chapterContent
                        };


                  print("Empty ${snapshot.data}");

                  return Padding(
                    padding: EdgeInsets.only(left: 16, right: 16, top: index == 0 ? 24 : 8, bottom: 8),
                    child: GestureDetector(
                      onTap: () {
                        print("Extras $extras");
                        context.pushNamed(AppRoutes.writeBook, extra: extras);
                      },
                      child: Container(
                      padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: boxShadow,
                      borderRadius: BorderRadius.circular(16)
                    ),
                    child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // chapter
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("Chapter $chapter", style: style?.copyWith(fontWeight: FontWeight.bold)),
    
                          // title
                          Text(title),
    
                          // date last updated formatTimestamp calculateTimeDifference
                          Text(
                            "Last updated \u2022 ${!timeDifference.contains('month') ? "$timeDifference ago" : timestamp}",
                            style: style?.copyWith(fontSize: 14)
                            )
                        ],
                      )
                    ],
                  )
                  )
                    )
                  );
                },
              );
                },
              ),
            ],
          );
        }));
  }
}

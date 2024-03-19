import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:l_earn/BusinessLogic/AuthCubit/auth/auth_cubit.dart';
import 'package:l_earn/BusinessLogic/contentCubit/content_cubit.dart';
import 'package:l_earn/BusinessLogic/tabCubit/tab_cubit.dart';
import 'package:l_earn/DataLayer/Models/content_model.dart';
import 'package:l_earn/DataLayer/Models/user_model.dart';
import 'package:l_earn/Presentation/components/my_circularProgressIndicator.dart';
import 'package:l_earn/Presentation/components/my_circular_progress_indicator.dart';
import 'package:l_earn/Presentation/components/my_container_button.dart';
import 'package:l_earn/Presentation/components/my_content_widget.dart';
import 'package:l_earn/Presentation/components/my_dialog.dart';
import 'package:l_earn/utils/constants.dart';
import 'package:l_earn/utils/mixins.dart';

class ContentsShell extends StatelessWidget with ContentMixin {
  const ContentsShell({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ContentCubit, ContentState>(builder: (context, state) {
      final User user = context.read<AuthCubit>().state.user!;
      return BlocBuilder<TabCubit, TabState>(builder: (context, tabstate) {
        print("STATE.MYCONTENTS = ${state.myContents}");
        print("S  T A T E    I S   $state");
        return state.myContents != null && state.myContents!.isNotEmpty

            //* BUILDING THE ACTUAL SCROLLABLE LIST OF CONTENTS
            ? Text("Contents here") : Text("loding...");
            // : SliverToBoxAdapter(child: MyCircularProgressIndicator());
        // child: Text(
        // '${userIid == user.id ? 'You have' : "${user.firstName} has"} not created any books yet')));
      });
    });
  }

  //* M E T H O D S
  Widget buildListOfContents(BuildContext context,
      {required List<Content> contents,
      required int itemCount,
      required User user}) {
    return SliverList.builder(
        itemCount: itemCount,
        itemBuilder: (content, index) {
          final Content content = contents[index];
          const padding = EdgeInsets.only(left: 16.0, right: 16, bottom: 16);

          return Padding(
            padding: padding,

            //* CONTENT
            child: MyContent(
              content: content,
              moreActions: user.id == content.author.id
                  ? [
                      //? EDIT CONTENT
                      PopupMenuItem(
                        value: 'edit',
                        onTap: () {
                          //TODO: HANDLE EDIT CONTENT
                          print("Edit content pressed");
                          print("POST TAG LENGT ${content.tags}");

                          //! avigator.pushNamed(context, '/create-tutorial',
                          //     arguments: {
                          //       'title': content.title,
                          //       'description': content.description,
                          //       'price': content.price,
                          //       'genre': content.tags?.join(''),
                          //       'thumbnailUrl': content.thumbnailUrl,
                          //       'id': content.id
                          //     });
                          context.pushNamed(AppRoutes.createTutorial, extra: {
                            'title': content.title,
                            'description': content.description,
                            'price': content.price,
                            'genre': content.tags?.join(''),
                            'thumbnailUrl': content.thumbnailUrl,
                            'id': content.id
                          });
                        },
                        child: Text('Edit ${content.type}'),
                      ),

                      //? ADD CHAPTER
                      PopupMenuItem(
                        value: 'add',
                        onTap: () {
                          //TODO: HANDLE ADD CONTENT
                          print("Add chapter pressed");

                          context.pushNamed(AppRoutes.writeBook,
                              extra: {"content": content});
                          //! avigator.of(context).pushReplacementNamed(
                          //     '/write-book-page',
                          //     arguments: {"content": content});
                        },
                        child: const Text('Add chapter'),
                      ),

                      //? DELETE CONTENT
                      PopupMenuItem(
                        value: 'delete',
                        onTap: () {
                          //TODO: HANDLE DELETE CONTENT
                          print("Delete content pressed pressed");

                          showDialog(
                              context: context,
                              builder: (context) {
                                return MyDialog(
                                  title: "Delete Book?",
                                  content: RichText(
                                    text: TextSpan(
                                        text:
                                            'Are you sure you want to delete ',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium,
                                        children: [
                                          TextSpan(
                                              text: '"${content.title}"',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium
                                                  ?.copyWith(
                                                      fontStyle:
                                                          FontStyle.italic)),
                                          const TextSpan(
                                              text: '? This operation is '),
                                          TextSpan(
                                              text: 'irreversible',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium
                                                  ?.copyWith(
                                                      color: Colors.red,
                                                      fontWeight:
                                                          FontWeight.bold))
                                        ]),
                                  ),
                                  actions: [
                                    //! Yes
                                    MyContainerButton(
                                        text: 'yes',
                                        showShadow: false,
                                        textColor: Colors.black,
                                        buttonColor: Colors.transparent,
                                        onPressed: () {
                                          deleteBook(content.id,
                                              context: context);
                                        }),

                                    //?No
                                    MyContainerButton(
                                        text: "No",
                                        onPressed: () {
                                          //! avigator.pop(context);
                                          context.pop();
                                          print("User clicked No");
                                        })
                                  ],
                                );
                              });
                        },
                        child: Text(
                          'Delete ${content.type}',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: Colors.red),
                        ),
                      ),
                    ]
                  : [
                      //? DELETE CONTENT
                      PopupMenuItem(
                        value: 'report',
                        onTap: () {
                          //TODO: HANDLE DELETE CONTENT
                          print("Delete content pressed pressed");
                        },
                        child: Text('Report ${content.type}'),
                      ),
                    ],
              onThumbnailPressed: () {
                //? REQUEST FOR A PARTICULAR CONTENT
                print('${content.title} thumbnail pressed');
                context.read<ContentCubit>().getContentById(
                    context.read<AuthCubit>().state.user?.token, content.id);
              },
              onMetaPressed: () {
                print('${content.title} meta pressed');
              },
            ),
          );
        });
  }
}

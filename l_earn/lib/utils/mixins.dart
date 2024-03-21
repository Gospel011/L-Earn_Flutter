import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:l_earn/DataLayer/Models/content_model.dart';
import 'package:l_earn/DataLayer/Models/user_model.dart';
import 'package:l_earn/Presentation/components/my_container_button.dart';
import 'package:l_earn/Presentation/components/my_content_widget.dart';
import 'package:l_earn/Presentation/components/my_dialog.dart';
import 'package:l_earn/utils/colors.dart';
import 'package:l_earn/utils/constants.dart';
import 'package:go_router/go_router.dart';
import 'package:l_earn/BusinessLogic/AuthCubit/verification/verification_cubit.dart';

import 'package:l_earn/BusinessLogic/contentCubit/content_cubit.dart';
import 'package:l_earn/BusinessLogic/AuthCubit/auth/auth_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';

mixin AppBarMixin {
  AppBar buildAppBar(BuildContext context,
      {String? title = 'L-EARN',
      bool automaticallyImplyLeading = false,
      Color? backgroundColor,
      bool includeClose = false,
      List<Widget>? actions,
      TextStyle? titleTextStyle,
      void Function()? closeButtonOnpressed,
      bool centerTitle = false}) {
    return AppBar(
      automaticallyImplyLeading: automaticallyImplyLeading,
      backgroundColor:
          backgroundColor ?? Theme.of(context).appBarTheme.backgroundColor,
      centerTitle: centerTitle,
      title: title != null
          ? Text(
              title,
              style: titleTextStyle ??
                  Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColor.textColor, fontWeight: FontWeight.bold),
            )
          : null,
      actions: actions ??
          [
            //! If close and actions is included, don't show close, only show
            //! actions
            includeClose == true
                ? IconButton(
                    onPressed: () {
                      closeButtonOnpressed == null
                          ? context.goNamed(AppRoutes.login)
                          : closeButtonOnpressed();
                    },
                    icon: const Icon(Icons.close_rounded))
                : const SizedBox()
          ],
    );
  }
}

mixin ImageMixin {
  Future<XFile?> getSingleImageFromSource(BuildContext context) async {
    XFile? pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    return pickedImage;
  }
}

mixin TimeParserMixin {
  String calculateTimeDifference(String timestamp) {
    DateTime now = DateTime.now();
    DateTime pastTime = DateTime.parse(timestamp);

    pastTime = pastTime.toLocal();

    Duration difference = now.difference(pastTime);

    int months = now.month - pastTime.month + (12 * (now.year - pastTime.year));
    int days = difference.inDays;
    int hours = difference.inHours;
    int minutes = difference.inMinutes;
    int seconds = difference.inSeconds;

    print('Months passed: $months');
    print('Days passed: $days');
    print('Hours passed: $hours');
    print('Minutes passed: $minutes');

    late String res;

    if (months != 0 && days > 30) {
      res = '$months month${months == 1 ? '' : 's'}';
    } else if (days != 0 && hours > 24) {
      res = '$days day${days == 1 ? '' : 's'}';
    } else if (hours != 0 && minutes > 60) {
      res = '$hours hour${hours == 1 ? '' : 's'}';
    } else if (minutes != 0) {
      res = '$minutes minute${minutes == 1 ? '' : 's'}';
    } else {
      res = '$seconds second${seconds == 1 ? '' : 's'}';
    }

    return res;
  }

  String formatTimestamp(String timestamp) {
    DateTime dateTime = DateTime.parse(timestamp);

    dateTime = dateTime.toLocal();

    String formattedDate = DateFormat('MMM d, y. h:mm a').format(dateTime);

    return formattedDate;
  }
}

mixin PriceParserMixin {
  String parsePrice(String price) {
    price = price.replaceAll(',', '');

    //? split the price into the whole and decimal part
    var partitionedPrice = price.split('.');

    price = partitionedPrice[0];

    // price = price.replaceAll(RegExp(r'\.+'), '');

    String reversedNumberString = price.split('').reversed.join('');

    List<String> parts = [];
    for (int i = 0; i < reversedNumberString.length; i += 3) {
      int end = i + 3;
      if (end > reversedNumberString.length) {
        end = reversedNumberString.length;
      }
      parts.add(reversedNumberString.substring(i, end));
    }

    print("P A R T I T I O N E D   P R I C E   I S   $partitionedPrice");

    String result =
        '${parts.join(',').split('').reversed.join('')}${partitionedPrice.length == 2 && partitionedPrice[1] != '0' ? '.${partitionedPrice[1]}' : ''}';
    return result;
  }
}

mixin UserMixin {
  void requestEmailOtp(BuildContext context) {
    context.read<VerificationCubit>().requestEmailVerificationOtp();
  }
}

mixin PostMixin {

}

mixin ContentMixin {
  void loadContents(BuildContext context, {int page = 1, required String userId}) {
    context.read<ContentCubit>().loadContents(
        context.read<AuthCubit>().state.user!.token,
        userId: userId,
        page: page);
  }

  void deleteBook(String contentId, {required BuildContext context}) {
    //! avigator.pop(context);
    context.pop();

    //! PERFORM DELETE OPERATION
    context
        .read<ContentCubit>()
        .deleteBook(context.read<AuthCubit>().state.user?.token, id: contentId);
  }


   SliverList buildListOfContents(BuildContext context,
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
                      //? SHARE CONTENT
                      PopupMenuItem(
                        value: 'share',
                        onTap: () {
                          //TODO: HANDLE EDIT CONTENT
                          print("Share content pressed");
                          print("POST TAG LENGT ${content.tags}");

                          Share.share("${NetWorkConstants.baseShareUrl}/contents/${content.id}");
                          
                        },
                        child: Text('Edit ${content.type}'),
                      ),
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
                
                context.pushNamed(AppRoutes.contentDescription,
                  pathParameters: {"id": content.id});
              },
              onMetaPressed: () {
                print('${content.title} meta pressed');
              },
            ),
          );
        });
  }
}
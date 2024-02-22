import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:l_earn/BusinessLogic/contentCubit/content_cubit.dart';
import 'package:l_earn/DataLayer/Models/user_model.dart';
import 'package:l_earn/Presentation/components/my_elevated_button.dart';
import 'package:l_earn/Presentation/components/my_profile_picture.dart';
import 'package:l_earn/Presentation/components/my_textfield.dart';
import 'package:l_earn/Presentation/components/render_user_name.dart';

import 'package:l_earn/utils/colors.dart';

class MyQuillEditor extends StatefulWidget {
  const MyQuillEditor(
      {super.key,
      this.readOnly = true,
      required this.controller,
      required this.textEditingController,
      this.user,
      this.fresh});
  final bool? readOnly;
  final QuillController controller;
  final User? user;
  final bool? fresh;
  final TextEditingController textEditingController;

  @override
  State<MyQuillEditor> createState() => _ChapterPageState();
}

class _ChapterPageState extends State<MyQuillEditor> {
  late final QuillSimpleToolbarConfigurations quillSimpleToolbarConfigurations;
  late final QuillEditorConfigurations quillEditorConfigurations;

  @override
  Widget build(BuildContext context) {


    //? CONFIGURATIONS FOR QUILL EDITOR
    quillEditorConfigurations = QuillEditorConfigurations(
      controller: widget.controller,
      placeholder: 'Compose your chapter one character at a time...',
      readOnly: widget.readOnly!,
      showCursor: !widget.readOnly!,
      disableClipboard: widget.readOnly!,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sharedConfigurations: const QuillSharedConfigurations(
        locale: Locale('en'),
      ),
    );



            var themeData = ThemeData(
                textTheme: TextTheme(
                    bodyMedium: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: AppColor.mainColorBlack)),
                inputDecorationTheme: const InputDecorationTheme(
                    border: OutlineInputBorder(borderSide: BorderSide.none),
                    enabledBorder: InputBorder.none));

    return Column(
      children: [
        Expanded(
          child: CustomScrollView(
            slivers: [
              //? SPACING FROM TOP
              const SliverPadding(padding: EdgeInsets.all(8)),
          
              //? CHAPTER X: TITLE
              SliverToBoxAdapter(
                child: Theme(
                    data: themeData,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: MyTextField(
                        controller: widget.textEditingController,
                        hintText: "Title",
                        maxLines: null,
                        showCursor: !widget.readOnly!,
                        keyboardType: widget.readOnly! == true
                            ? TextInputType.none
                            : TextInputType.text,
                      ),
                    )),
              ),
          
              const SliverPadding(padding: EdgeInsets.all(16)),
          
              //? AUTHOURS MINI PROFILE
          
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //? PROFILE PICTURE
                      MyProfilePicture(
                        user: widget.user!,
                        radius: 24,
                      ),
          
                      const SizedBox(width: 4),
          
                      //? COLUMN WITH NAME AND FOLLOWERS
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          //* U S E R N A M E
                          RenderUserName(
                            user: widget.user!,
                            fontWeight: FontWeight.bold,
                          ),
          
                          //* F O L L O W E R S
                          Text(
                              '${widget.user!.followers} followers')
                        ],
                      ),
          
                      // MyContainerButton(
                      //     text: 'Follow',
                      //     onPressed: () {
                      //       print('Follow button pressed');
                      //     })
                    ],
                  ),
                ),
              ),
          
              const SliverPadding(padding: EdgeInsets.all(8)),
          
              //? FOLLOW OR FOLLOWING BUTTON
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: MyElevatedButton(
                      text: 'Follow',
                      onPressed: () {
                        print('Follow button pressed');
                      }),
                ),
              ),
          
              const SliverPadding(padding: EdgeInsets.all(16)),
          
              //? EDITOR
              SliverToBoxAdapter(
                child: QuillEditor.basic(
                  configurations: quillEditorConfigurations,
                ),
              ),
            ],
          ),
        ),
        
        widget.readOnly == true ? const SizedBox() : QuillToolbar.simple(
            configurations: QuillSimpleToolbarConfigurations(
                toolbarSize: 48,
                controller: widget.controller,
                multiRowsDisplay: false,
                sharedConfigurations: const QuillSharedConfigurations(
                  locale: Locale('en'),
                )))
      ],
    );
  }
}

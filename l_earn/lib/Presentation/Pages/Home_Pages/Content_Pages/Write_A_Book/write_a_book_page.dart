import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:l_earn/Presentation/Pages/Home_Pages/Content_Pages/my_quill_editor.dart';
import 'package:l_earn/BusinessLogic/AuthCubit/auth/auth_cubit.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:l_earn/utils/mixins.dart';
import 'package:l_earn/Presentation/components/my_container_button.dart';

class WriteABookPage extends StatelessWidget with AppBarMixin {
  const WriteABookPage({super.key});

  static final _contentController = QuillController.basic();
  static final _titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: buildAppBar(context, actions: [
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: MyContainerButton(
                  text: 'post',
                  onPressed: () {
                    //TODO: IMPLEMENT POSTING FUNCTIONALITY FOR CONTENT

                    print("post pressed");

                    print(
                        ":::::::::::::::::: P R I N T I N G   U S E R   C O N T E N T :::::::::::::::::::::::::");

                    print(
                        "Title: ${_titleController.text}\nContent: ${jsonEncode(_contentController.document.toDelta().toJson())}");
                  }))
        ]),
        body: MyQuillEditor(
            controller: _contentController,
            textEditingController: _titleController,
            user: context.read<AuthCubit>().state.user,
            readOnly: false,
            fresh: true));
  }
}

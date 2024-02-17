import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import '../../../../utils/mixins.dart';

class MyQuillEditor extends StatefulWidget {
  const MyQuillEditor(
      {super.key,
      this.defaultContent,
      required this.controller,
      this.readOnly = true});
  final String? defaultContent;
  final QuillController controller;
  final bool? readOnly;

  @override
  State<MyQuillEditor> createState() => _ChapterPageState();
}

class _ChapterPageState extends State<MyQuillEditor> {
  late final QuillSimpleToolbarConfigurations quillSimpleToolbarConfigurations;
  late final QuillEditorConfigurations quillEditorConfigurations;

  @override
  void initState() {
    super.initState();
    var jsonStr = widget.defaultContent;

    final jsonMap = jsonDecode(jsonStr ?? '');

    widget.controller.document = Document.fromJson(jsonMap);

    //? CONFIGURATIONS FOR QUILL TOOL BAR
    quillSimpleToolbarConfigurations = QuillSimpleToolbarConfigurations(
      toolbarSize: 48,
      controller: widget.controller,
      multiRowsDisplay: false,
      sharedConfigurations: const QuillSharedConfigurations(
        locale: Locale('en'),
      ),
    );


    //? CONFIGURATIONS FOR QUILL EDITOR
    quillEditorConfigurations = QuillEditorConfigurations(
      controller: widget.controller,
      readOnly: widget.readOnly!,
      showCursor: !widget.readOnly!,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sharedConfigurations: const QuillSharedConfigurations(
        locale: Locale('en'),
      ),
    );
  }

  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [

          //? Editor
          Expanded(
              child: QuillEditor.basic(
            configurations: quillEditorConfigurations,
          )),

          //? Toolbar
          widget.readOnly == false
              ? QuillToolbar.simple(
                  configurations: quillSimpleToolbarConfigurations,
                )
              : const SizedBox(),
        ],
      );
  }
}

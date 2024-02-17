import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:l_earn/Presentation/Pages/Home_Pages/Content_Pages/my_quill_editor.dart';
import '../../../../utils/mixins.dart';

class ChapterPage extends StatefulWidget with AppBarMixin {
  const ChapterPage({super.key, required this.quillEditor});
  final MyQuillEditor quillEditor;

  @override
  State<ChapterPage> createState() => _ChapterPageState();
}

class _ChapterPageState extends State<ChapterPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.buildAppBar(context),
      body: widget.quillEditor,
    );
  }
}

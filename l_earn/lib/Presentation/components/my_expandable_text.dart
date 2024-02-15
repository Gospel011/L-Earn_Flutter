import 'package:flutter/material.dart';

class MyExpandableText extends StatefulWidget {
  const MyExpandableText({
    super.key,
    required this.text,
  });

  final String text;

  @override
  State<MyExpandableText> createState() => _MyExpandableTextState();
}

class _MyExpandableTextState extends State<MyExpandableText> {
  int? maxLines = 4;
  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    print("Expanded: $isExpanded");
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: GestureDetector(
        onTap: () {
          setState(() {
            isExpanded = !isExpanded;
          });
        },
        child: Text(
          widget.text,
          maxLines: isExpanded ? null : maxLines,
          overflow: isExpanded ? null : TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
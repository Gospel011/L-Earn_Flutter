import 'package:flutter/material.dart';

class MyBottomModalSheet extends StatelessWidget {
  final List<Widget> children;
  const MyBottomModalSheet({super.key, required this.children, this.height});
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      height: height,
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadiusDirectional.only(
              topStart: Radius.circular(16), topEnd: Radius.circular(16))),
      // height: MediaQuery.of(context).size.height / 2.5,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: children,
        ),
      ),
    );
  }
}

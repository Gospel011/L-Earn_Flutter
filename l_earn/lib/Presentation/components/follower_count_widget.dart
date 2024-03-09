import 'package:flutter/material.dart';

class FollowerCountWidget extends StatelessWidget {
  const FollowerCountWidget({
    super.key,
    required this.followerCount,
    this.fontWeight
    
  });

  final int followerCount;
  final FontWeight? fontWeight;

  @override
  Widget build(BuildContext context) {
    return Text(followerCount == 1 ? '1 follower' : '$followerCount followers',
        style: Theme.of(context)
            .textTheme
            .bodyMedium
            ?.copyWith(fontWeight: fontWeight ?? FontWeight.bold));
  }
}
import 'package:flutter/material.dart';
import 'package:l_earn/DataLayer/Models/user_model.dart';
import 'package:l_earn/Presentation/components/my_profile_picture.dart';

class TutorMiniProfile extends StatelessWidget {
  const TutorMiniProfile({
    super.key,
    required this.user,
  });

  final User user;

  @override
  Widget build(BuildContext context) {
    final BoxDecoration decoration = BoxDecoration(
        borderRadius: BorderRadius.circular(16), color: Colors.white);
    const EdgeInsets padding = EdgeInsets.all(8);

    return Container(
      decoration: decoration,
      padding: padding,
      child: SizedBox(
        height: 98,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MyProfilePicture(
                user: user,
              ),
              const SizedBox(
                width: 8,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${user.firstName} ${user.lastName}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontWeight: FontWeight.bold)),
                    Text("${user.followers}",
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(fontWeight: FontWeight.bold)),
                    const Text('Followers')
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}


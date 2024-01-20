import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MyElevatedButton extends StatelessWidget {
  final String text;
  final bool? loading;
  final void Function()? onPressed;
  final IconData? icon;
  final String? leadingIcon;
  

  const MyElevatedButton(
      {super.key, this.onPressed, required this.text, this.icon, this.loading, this.leadingIcon});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: ElevatedButton(
          onPressed: loading == true ? null : onPressed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (leadingIcon != null)
                SvgPicture.asset(leadingIcon!)
              else
                const SizedBox(
                  width: 0,
                ),

                if (leadingIcon != null)
                const SizedBox(width: 10,)
              else
                const SizedBox(
                  width: 0,
                ),
              loading != true
                  ? Text(
                      text,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: Colors.white),
                    )
                  : const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      )),
              if (icon != null)
                Icon(icon)
              else
                const SizedBox(
                  width: 0,
                ),
            ],
          )),
    );
  }
}

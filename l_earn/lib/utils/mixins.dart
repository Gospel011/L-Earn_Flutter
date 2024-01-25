import 'package:flutter/material.dart';
import 'package:l_earn/utils/colors.dart';

mixin AppBarMixin {
  AppBar buildAppBar(BuildContext context,
      {String? title = 'L-EARN',
      bool automaticallyImplyLeading = false,
      bool includeClose = false,
      List<Widget>? actions,
      void Function()? closeButtonOnpressed,
      bool centerTitle = false}) {
    return AppBar(
      automaticallyImplyLeading: automaticallyImplyLeading,
      centerTitle: centerTitle,
      title: title != null
          ? Text(
              title,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColor.textColor, fontWeight: FontWeight.bold),
            )
          : null,
      actions: actions ?? [

        
        //! If close and actions is included, don't show close, only show
        //! actions
        includeClose == true ? IconButton(
            onPressed: () {
               closeButtonOnpressed == null ? Navigator.pushNamedAndRemoveUntil(
                  context, '/', (route) => false) : closeButtonOnpressed();
            },
            icon: const Icon(Icons.close_rounded)) : const SizedBox()
      ],
    );
  }
}

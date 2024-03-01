import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:l_earn/utils/colors.dart';

mixin AppBarMixin {
  AppBar buildAppBar(BuildContext context,
      {String? title = 'L-EARN',
      bool automaticallyImplyLeading = false,
      Color? backgroundColor,
      bool includeClose = false,
      List<Widget>? actions,
      TextStyle? titleTextStyle,
      void Function()? closeButtonOnpressed,
      bool centerTitle = false}) {
    return AppBar(
      automaticallyImplyLeading: automaticallyImplyLeading,
      backgroundColor: backgroundColor ?? Theme.of(context).appBarTheme.backgroundColor,
      centerTitle: centerTitle,
      title: title != null
          ? Text(
              title,
              style: titleTextStyle ??
                  Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColor.textColor, fontWeight: FontWeight.bold),
            )
          : null,
      actions: actions ??
          [
            //! If close and actions is included, don't show close, only show
            //! actions
            includeClose == true
                ? IconButton(
                    onPressed: () {
                      closeButtonOnpressed == null
                          ? Navigator.pushNamedAndRemoveUntil(
                              context, '/', (route) => false)
                          : closeButtonOnpressed();
                    },
                    icon: const Icon(Icons.close_rounded))
                : const SizedBox()
          ],
    );
  }
}

mixin ImageMixin {
  Future<XFile?> getSingleImageFromSource(BuildContext context) async {
    XFile? pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    return pickedImage;
  }
}

mixin TimeParserMixin {
  String calculateTimeDifference(String timestamp) {
  DateTime now = DateTime.now();
  DateTime pastTime = DateTime.parse(timestamp);

  pastTime = pastTime.toLocal();
  
  Duration difference = now.difference(pastTime);

  int months = now.month - pastTime.month + (12 * (now.year - pastTime.year));
  int days = difference.inDays;
  int hours = difference.inHours;
  int minutes = difference.inMinutes;
  int seconds = difference.inSeconds;

  print('Months passed: $months');
  print('Days passed: $days');
  print('Hours passed: $hours');
  print('Minutes passed: $minutes');

  late String res;

  if (months != 0) {
    res = '$months month${months == 1 ? '' : 's'}';
  } else if (days != 0) {
    res = '$days day${days == 1 ? '' : 's'}';
  }
  else if (hours != 0) {
    res = '$hours hour${hours == 1 ? '' : 's'}';
  }
  else if (minutes != 0) {
    res = '$minutes minute${minutes == 1 ? '' : 's'}';
  }
  else {
    res = '$seconds second${seconds == 1 ? '' : 's'}';
  }

  return res;
}


String formatTimestamp(String timestamp) {
    DateTime dateTime = DateTime.parse(timestamp);

    dateTime = dateTime.toLocal();

    String formattedDate = DateFormat('MMM d, y. h:mm a').format(dateTime);

    return formattedDate;
  }

}

mixin PriceParserMixin {
  String parsePrice(String price) {

    price = price.replaceAll(',', '');

    String reversedNumberString = price.split('').reversed.join('');

    List<String> parts = [];
    for (int i = 0; i < reversedNumberString.length; i += 3) {
      int end = i + 3;
      if (end > reversedNumberString.length) {
        end = reversedNumberString.length;
      }
      parts.add(reversedNumberString.substring(i, end));
    }

    

    String result = parts.join(',').split('').reversed.join('');
    return result;
  }
}
